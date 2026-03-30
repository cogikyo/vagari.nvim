# syntax=docker/dockerfile:1

# Multi-stage build: Go API with frontend assets.

# --- Stage 1: Build frontend ------------------------------------------------
FROM node:20-alpine AS frontend

WORKDIR /app/frontend

# Install dependencies first (layer caching)
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci --no-audit --no-fund

# Build the frontend
COPY frontend/ .
RUN npm run build

# --- Stage 2: Build Go binary -----------------------------------------------
FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git ca-certificates tzdata

WORKDIR /app

# Cache Go modules
COPY go.mod go.sum ./
RUN go mod download && go mod verify

# Copy source and build
COPY . .
COPY --from=frontend /app/frontend/dist ./internal/static/dist

ARG VERSION=dev
ARG COMMIT_SHA=unknown
ARG BUILD_TIME

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-s -w \
      -X main.version=${VERSION} \
      -X main.commit=${COMMIT_SHA} \
      -X main.buildTime=${BUILD_TIME}" \
    -trimpath \
    -o /bin/server \
    ./cmd/server

# --- Stage 3: Runtime -------------------------------------------------------
FROM scratch

# Import certificates and timezone data
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

# Non-root user
COPY --from=builder /etc/passwd /etc/passwd
USER nobody:nobody

COPY --from=builder /bin/server /server

# Metadata
LABEL org.opencontainers.image.title="vagari-api" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.source="https://github.com/example/vagari"

EXPOSE 8080/tcp
EXPOSE 9090/tcp

ENV ENVIRONMENT=production \
    LOG_LEVEL=info \
    PORT=8080 \
    GRPC_PORT=9090

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["/server", "health"]

ENTRYPOINT ["/server"]
CMD ["serve", "--addr", "0.0.0.0:8080"]
