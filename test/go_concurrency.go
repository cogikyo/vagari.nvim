package pipeline

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"sync"
	"time"
)

// Stage processes items from in and sends results to the returned channel.
type Stage[In, Out any] func(ctx context.Context, in <-chan In) <-chan Result[Out]

// Result wraps a value or error from a pipeline stage.
type Result[T any] struct {
	Value T
	Err   error
}

// FanOut distributes work across n goroutines, merging results into one channel.
func FanOut[T, U any](ctx context.Context, n int, in <-chan T, work func(T) (U, error)) <-chan Result[U] {
	out := make(chan Result[U], n)
	var wg sync.WaitGroup

	for i := 0; i < n; i++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			for item := range in {
				select {
				case <-ctx.Done():
					return
				default:
					val, err := work(item)
					out <- Result[U]{Value: val, Err: err}
				}
			}
		}(i)
	}

	go func() {
		wg.Wait()
		close(out)
	}()

	return out
}

// Batch collects items into fixed-size slices with a flush timeout.
func Batch[T any](ctx context.Context, in <-chan T, size int, timeout time.Duration) <-chan []T {
	out := make(chan []T)

	go func() {
		defer close(out)
		buf := make([]T, 0, size)
		timer := time.NewTimer(timeout)
		defer timer.Stop()

		for {
			select {
			case <-ctx.Done():
				if len(buf) > 0 {
					out <- buf
				}
				return

			case item, ok := <-in:
				if !ok {
					if len(buf) > 0 {
						out <- buf
					}
					return
				}
				buf = append(buf, item)
				if len(buf) >= size {
					out <- buf
					buf = make([]T, 0, size)
					timer.Reset(timeout)
				}

			case <-timer.C:
				if len(buf) > 0 {
					out <- buf
					buf = make([]T, 0, size)
				}
				timer.Reset(timeout)
			}
		}
	}()

	return out
}

// RetryWithBackoff attempts fn up to maxAttempts times with exponential backoff.
func RetryWithBackoff(ctx context.Context, maxAttempts int, base time.Duration, fn func() error) error {
	var errs []error

	for attempt := 0; attempt < maxAttempts; attempt++ {
		err := fn()
		if err == nil {
			return nil
		}

		errs = append(errs, err)
		slog.Warn("attempt failed",
			"attempt", attempt+1,
			"max", maxAttempts,
			"error", err,
		)

		if attempt < maxAttempts-1 {
			delay := base * time.Duration(1<<uint(attempt))
			select {
			case <-ctx.Done():
				return fmt.Errorf("context cancelled after %d attempts: %w", attempt+1, ctx.Err())
			case <-time.After(delay):
			}
		}
	}

	return fmt.Errorf("all %d attempts failed: %w", maxAttempts, errors.Join(errs...))
}
