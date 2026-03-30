import React, { useState, useEffect, useCallback, useRef, type ReactNode } from "react";

interface User {
  id: number;
  name: string;
  email: string;
  role: "admin" | "editor" | "viewer";
  avatar?: string;
  lastLogin: Date;
}

interface UserCardProps {
  user: User;
  isSelected?: boolean;
  onSelect: (id: number) => void;
  onDelete: (id: number) => Promise<void>;
  children?: ReactNode;
}

const STATUS_COLORS = {
  admin: "#e74c3c",
  editor: "#f39c12",
  viewer: "#3498db",
} as const;

/**
 * UserCard displays a single user with selection and delete actions.
 * Demonstrates hooks, refs, conditional rendering, and event handling.
 */
export function UserCard({ user, isSelected = false, onSelect, onDelete, children }: UserCardProps) {
  const [isDeleting, setIsDeleting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const cardRef = useRef<HTMLDivElement>(null);
  const timeoutRef = useRef<ReturnType<typeof setTimeout>>();

  // Scroll selected card into view
  useEffect(() => {
    if (isSelected && cardRef.current) {
      cardRef.current.scrollIntoView({ behavior: "smooth", block: "nearest" });
    }
  }, [isSelected]);

  // Cleanup timeout on unmount
  useEffect(() => {
    return () => {
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current);
      }
    };
  }, []);

  const handleDelete = useCallback(async () => {
    setIsDeleting(true);
    setError(null);

    try {
      await onDelete(user.id);
    } catch (err) {
      const message = err instanceof Error ? err.message : "Failed to delete user";
      setError(message);
      timeoutRef.current = setTimeout(() => setError(null), 5000);
    } finally {
      setIsDeleting(false);
    }
  }, [user.id, onDelete]);

  const formattedDate = new Intl.DateTimeFormat("en-US", {
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  }).format(user.lastLogin);

  const roleColor = STATUS_COLORS[user.role];
  const initials = user.name
    .split(" ")
    .map((n) => n[0])
    .join("")
    .toUpperCase();

  return (
    <div
      ref={cardRef}
      role="button"
      tabIndex={0}
      aria-selected={isSelected}
      data-user-id={user.id}
      onClick={() => onSelect(user.id)}
      onKeyDown={(e) => e.key === "Enter" && onSelect(user.id)}
    >
      <div>
        {user.avatar ? (
          <img src={user.avatar} alt={`${user.name}'s avatar`} width={40} height={40} />
        ) : (
          <span aria-hidden="true">{initials}</span>
        )}
      </div>

      <div>
        <h3>{user.name}</h3>
        <p>{user.email}</p>
        <span style={{ color: roleColor }}>{user.role}</span>
        <time dateTime={user.lastLogin.toISOString()}>Last login: {formattedDate}</time>
      </div>

      {error && <p role="alert">{error}</p>}

      <button onClick={handleDelete} disabled={isDeleting} aria-busy={isDeleting}>
        {isDeleting ? "Deleting..." : "Delete"}
      </button>

      {children}
    </div>
  );
}

export default React.memo(UserCard);
