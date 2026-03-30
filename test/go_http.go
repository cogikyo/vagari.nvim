package api

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"strings"
	"time"
)

// Server wraps an HTTP server with middleware and graceful shutdown.
type Server struct {
	mux    *http.ServeMux
	logger *slog.Logger
	addr   string
}

type contextKey string

const requestIDKey contextKey = "request_id"

// Response is the standard JSON envelope.
type Response struct {
	Data   any    `json:"data,omitempty"`
	Error  string `json:"error,omitempty"`
	Status int    `json:"status"`
}

func NewServer(addr string, logger *slog.Logger) *Server {
	s := &Server{
		mux:    http.NewServeMux(),
		logger: logger,
		addr:   addr,
	}
	s.routes()
	return s
}

func (s *Server) routes() {
	s.mux.HandleFunc("GET /api/health", s.handleHealth)
	s.mux.HandleFunc("GET /api/users/{id}", s.handleGetUser)
	s.mux.HandleFunc("POST /api/users", s.handleCreateUser)
}

// Middleware: logging, recovery, request ID.
func (s *Server) middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		reqID := r.Header.Get("X-Request-ID")
		if reqID == "" {
			reqID = fmt.Sprintf("%d", time.Now().UnixNano())
		}

		ctx := context.WithValue(r.Context(), requestIDKey, reqID)
		w.Header().Set("X-Request-ID", reqID)
		w.Header().Set("Content-Type", "application/json")

		// Recovery
		defer func() {
			if err := recover(); err != nil {
				s.logger.Error("panic recovered",
					"error", err,
					"request_id", reqID,
					"path", r.URL.Path,
				)
				writeJSON(w, http.StatusInternalServerError, Response{
					Error:  "internal server error",
					Status: http.StatusInternalServerError,
				})
			}
		}()

		next.ServeHTTP(w, r.WithContext(ctx))

		s.logger.Info("request",
			"method", r.Method,
			"path", r.URL.Path,
			"duration", time.Since(start).String(),
			"request_id", reqID,
		)
	})
}

func (s *Server) handleHealth(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, Response{
		Data:   map[string]string{"status": "healthy"},
		Status: http.StatusOK,
	})
}

func (s *Server) handleGetUser(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	if id == "" {
		writeJSON(w, http.StatusBadRequest, Response{
			Error:  "missing user id",
			Status: http.StatusBadRequest,
		})
		return
	}

	// Simulated lookup
	user := map[string]any{
		"id":          id,
		"email":       "user@example.com",
		"created_at":  time.Now().Add(-72 * time.Hour).Format(time.RFC3339),
		"active":      true,
		"login_count": 42,
	}

	writeJSON(w, http.StatusOK, Response{Data: user, Status: http.StatusOK})
}

type CreateUserRequest struct {
	Email string `json:"email"`
	Name  string `json:"name"`
}

func (s *Server) handleCreateUser(w http.ResponseWriter, r *http.Request) {
	var req CreateUserRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeJSON(w, http.StatusBadRequest, Response{
			Error:  "invalid request body",
			Status: http.StatusBadRequest,
		})
		return
	}

	if !strings.Contains(req.Email, "@") {
		writeJSON(w, http.StatusUnprocessableEntity, Response{
			Error:  "invalid email address",
			Status: http.StatusUnprocessableEntity,
		})
		return
	}

	writeJSON(w, http.StatusCreated, Response{
		Data:   map[string]string{"id": "new-id", "email": req.Email},
		Status: http.StatusCreated,
	})
}

// ListenAndServe starts the server with graceful shutdown support.
func (s *Server) ListenAndServe(ctx context.Context) error {
	srv := &http.Server{
		Addr:         s.addr,
		Handler:      s.middleware(s.mux),
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 10 * time.Second,
		IdleTimeout:  120 * time.Second,
	}

	errCh := make(chan error, 1)
	go func() { errCh <- srv.ListenAndServe() }()

	select {
	case <-ctx.Done():
		shutdownCtx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		defer cancel()
		return srv.Shutdown(shutdownCtx)
	case err := <-errCh:
		if errors.Is(err, http.ErrServerClosed) {
			return nil
		}
		return err
	}
}

func writeJSON(w http.ResponseWriter, status int, v any) {
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(v)
}
