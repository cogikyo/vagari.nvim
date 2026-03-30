import { useState, useEffect, createPortal, Fragment } from "react";

const API_URL = process.env.REACT_APP_API_URL ?? "/api";

// Simple data fetching hook
function useQuery(url) {
  const [state, setState] = useState({ data: null, error: null, loading: true });

  useEffect(() => {
    let cancelled = false;
    const controller = new AbortController();

    fetch(`${API_URL}${url}`, { signal: controller.signal })
      .then((res) => {
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        return res.json();
      })
      .then((data) => !cancelled && setState({ data, error: null, loading: false }))
      .catch((err) => !cancelled && setState({ data: null, error: err, loading: false }));

    return () => {
      cancelled = true;
      controller.abort();
    };
  }, [url]);

  return state;
}

// Badge component with spread props
function Badge({ children, variant = "default", ...rest }) {
  const colors = {
    default: "gray",
    success: "green",
    warning: "orange",
    error: "red",
  };

  return (
    <span style={{ color: colors[variant] ?? colors.default }} {...rest}>
      {children}
    </span>
  );
}

// Modal using portal
function Modal({ isOpen, onClose, title, children }) {
  if (!isOpen) return null;

  return createPortal(
    <div role="dialog" aria-modal="true" aria-label={title} onClick={onClose}>
      <div onClick={(e) => e.stopPropagation()}>
        <header>
          <h2>{title}</h2>
          <button onClick={onClose} aria-label="Close">&times;</button>
        </header>
        <div>{children}</div>
      </div>
    </div>,
    document.body,
  );
}

// Main page component
export default function DashboardPage() {
  const { data: users, error, loading } = useQuery("/users");
  const [selectedId, setSelectedId] = useState(null);
  const [modalOpen, setModalOpen] = useState(false);
  const [filter, setFilter] = useState("");

  if (loading) {
    return <div aria-busy="true">Loading...</div>;
  }

  if (error) {
    return (
      <div role="alert">
        <Badge variant="error">Error</Badge>
        <p>{error.message}</p>
        <button onClick={() => window.location.reload()}>Retry</button>
      </div>
    );
  }

  const filtered = users?.filter(
    (user) =>
      user.name.toLowerCase().includes(filter.toLowerCase()) ||
      user.email.toLowerCase().includes(filter.toLowerCase()),
  ) ?? [];

  const selected = users?.find((u) => u.id === selectedId);

  return (
    <Fragment>
      <header>
        <h1>Users ({filtered.length})</h1>
        <input
          type="search"
          placeholder="Filter users..."
          value={filter}
          onChange={(e) => setFilter(e.target.value)}
          aria-label="Filter users"
        />
      </header>

      <ul>
        {filtered.length === 0 ? (
          <li>No users match &ldquo;{filter}&rdquo;</li>
        ) : (
          filtered.map(({ id, name, email, role, active }) => (
            <li key={id} aria-selected={id === selectedId}>
              <button onClick={() => setSelectedId(id)}>
                <strong>{name}</strong>
                <span>{email}</span>
                <Badge variant={active ? "success" : "default"}>
                  {active ? "Active" : "Inactive"}
                </Badge>
                <Badge>{role}</Badge>
              </button>
            </li>
          ))
        )}
      </ul>

      {selected && (
        <aside>
          <h2>{selected.name}</h2>
          <dl>
            {Object.entries(selected).map(([key, value]) => (
              <Fragment key={key}>
                <dt>{key}</dt>
                <dd>{typeof value === "boolean" ? (value ? "Yes" : "No") : String(value)}</dd>
              </Fragment>
            ))}
          </dl>
          <button onClick={() => setModalOpen(true)}>Edit</button>
        </aside>
      )}

      <Modal isOpen={modalOpen} onClose={() => setModalOpen(false)} title="Edit User">
        <p>Editing {selected?.name ?? "unknown"}</p>
      </Modal>
    </Fragment>
  );
}
