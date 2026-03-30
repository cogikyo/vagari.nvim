package repository

import (
	"context"
	"encoding/json"
	"fmt"
	"sync"
)

// Ordered constrains type parameters to comparable, ordered types.
type Ordered interface {
	~int | ~float64 | ~string
}

// Entity represents a persistable domain object.
type Entity[ID Ordered] interface {
	GetID() ID
	Validate() error
}

// Metadata holds audit fields embedded into other structs.
type Metadata struct {
	CreatedBy string          `json:"created_by" db:"created_by"`
	Version   int             `json:"version"    db:"version"`
	Tags      map[string]any  `json:"tags,omitempty"`
}

// User is a concrete entity with embedded metadata.
type User struct {
	Metadata
	ID       int64    `json:"id"       db:"id"`
	Email    string   `json:"email"    db:"email"`
	Roles    []Role   `json:"roles"    db:"roles"`
	Settings Settings `json:"settings" db:"settings"`
}

type Role string

const (
	RoleAdmin  Role = "admin"
	RoleEditor Role = "editor"
	RoleViewer Role = "viewer"
)

type Settings struct {
	Theme      string `json:"theme"`
	PageSize   int    `json:"page_size"`
	DarkMode   bool   `json:"dark_mode"`
	MaxRetries uint8  `json:"max_retries"`
}

func (u *User) GetID() int64 { return u.ID }

func (u *User) Validate() error {
	if u.Email == "" {
		return fmt.Errorf("user %d: %w", u.ID, ErrMissingEmail)
	}
	return nil
}

var ErrMissingEmail = fmt.Errorf("email is required")

// Repository provides generic CRUD for any entity type.
type Repository[T Entity[ID], ID Ordered] struct {
	mu    sync.RWMutex
	store map[ID]T
}

func NewRepository[T Entity[ID], ID Ordered]() *Repository[T, ID] {
	return &Repository[T, ID]{
		store: make(map[ID]T),
	}
}

func (r *Repository[T, ID]) Get(ctx context.Context, id ID) (T, bool) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	val, ok := r.store[id]
	return val, ok
}

func (r *Repository[T, ID]) Save(ctx context.Context, entity T) error {
	if err := entity.Validate(); err != nil {
		return fmt.Errorf("validation failed: %w", err)
	}

	r.mu.Lock()
	defer r.mu.Unlock()

	r.store[entity.GetID()] = entity
	return nil
}

// MarshalAll serializes every record; demonstrates type assertion.
func (r *Repository[T, ID]) MarshalAll() ([]byte, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	items := make([]T, 0, len(r.store))
	for _, v := range r.store {
		items = append(items, v)
	}

	return json.Marshal(items)
}
