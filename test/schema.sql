-- Database schema: DDL, DML, joins, CTEs, window functions, triggers.

BEGIN;

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Enums
CREATE TYPE user_role AS ENUM ('admin', 'editor', 'viewer');
CREATE TYPE task_status AS ENUM ('pending', 'in_progress', 'review', 'done', 'cancelled');
CREATE TYPE priority_level AS ENUM ('low', 'medium', 'high', 'critical');

-- Tables
CREATE TABLE IF NOT EXISTS users (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email       VARCHAR(255) NOT NULL UNIQUE,
    name        TEXT NOT NULL,
    role        user_role NOT NULL DEFAULT 'viewer',
    active      BOOLEAN NOT NULL DEFAULT TRUE,
    metadata    JSONB DEFAULT '{}',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS projects (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(200) NOT NULL,
    slug        VARCHAR(200) NOT NULL UNIQUE,
    owner_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    description TEXT,
    archived    BOOLEAN DEFAULT FALSE,
    settings    JSONB NOT NULL DEFAULT '{"visibility": "private"}',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS tasks (
    id          BIGSERIAL PRIMARY KEY,
    project_id  INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    assignee_id UUID REFERENCES users(id) ON DELETE SET NULL,
    title       VARCHAR(500) NOT NULL,
    body        TEXT,
    status      task_status NOT NULL DEFAULT 'pending',
    priority    priority_level NOT NULL DEFAULT 'medium',
    labels      TEXT[] DEFAULT ARRAY[]::TEXT[],
    due_date    DATE,
    estimate_h  NUMERIC(6, 2),
    completed_at TIMESTAMPTZ,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT valid_completion CHECK (
        (status = 'done' AND completed_at IS NOT NULL)
        OR (status != 'done')
    )
);

-- Indexes
CREATE INDEX idx_tasks_project ON tasks(project_id);
CREATE INDEX idx_tasks_assignee ON tasks(assignee_id) WHERE assignee_id IS NOT NULL;
CREATE INDEX idx_tasks_status ON tasks(status) WHERE status NOT IN ('done', 'cancelled');
CREATE INDEX idx_tasks_labels ON tasks USING GIN(labels);
CREATE INDEX idx_users_email_lower ON users(LOWER(email));
CREATE INDEX idx_projects_settings ON projects USING GIN(settings jsonb_path_ops);

-- Trigger: auto-update updated_at
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trg_tasks_updated
    BEFORE UPDATE ON tasks
    FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Views
CREATE OR REPLACE VIEW active_task_summary AS
SELECT
    p.name AS project_name,
    t.status,
    t.priority,
    COUNT(*) AS task_count,
    AVG(t.estimate_h) AS avg_estimate,
    MIN(t.due_date) AS earliest_due
FROM tasks t
JOIN projects p ON p.id = t.project_id
WHERE t.status NOT IN ('done', 'cancelled')
  AND p.archived = FALSE
GROUP BY p.name, t.status, t.priority
ORDER BY p.name, t.priority DESC;

COMMIT;

-- ============================================================================
-- Queries
-- ============================================================================

-- CTE: find overdue tasks with assignee info
WITH overdue AS (
    SELECT
        t.id,
        t.title,
        t.priority,
        t.due_date,
        t.due_date - CURRENT_DATE AS days_overdue,
        u.name AS assignee_name,
        u.email AS assignee_email
    FROM tasks t
    LEFT JOIN users u ON u.id = t.assignee_id
    WHERE t.due_date < CURRENT_DATE
      AND t.status NOT IN ('done', 'cancelled')
)
SELECT *
FROM overdue
WHERE days_overdue < -7
ORDER BY priority DESC, days_overdue ASC
LIMIT 50;

-- Window functions: rank users by task completion
SELECT
    u.name,
    COUNT(t.id) AS completed,
    SUM(t.estimate_h) AS total_hours,
    RANK() OVER (ORDER BY COUNT(t.id) DESC) AS completion_rank,
    ROUND(
        COUNT(t.id)::NUMERIC / NULLIF(
            SUM(COUNT(t.id)) OVER (), 0
        ) * 100, 1
    ) AS pct_of_total,
    LAG(COUNT(t.id)) OVER (ORDER BY COUNT(t.id) DESC) - COUNT(t.id) AS gap_to_prev
FROM users u
JOIN tasks t ON t.assignee_id = u.id AND t.status = 'done'
GROUP BY u.id, u.name
HAVING COUNT(t.id) >= 5
ORDER BY completion_rank;

-- Subquery with EXISTS and CASE
SELECT
    p.name,
    p.slug,
    CASE
        WHEN p.archived THEN 'archived'
        WHEN NOT EXISTS (
            SELECT 1 FROM tasks t
            WHERE t.project_id = p.id
              AND t.status NOT IN ('done', 'cancelled')
        ) THEN 'complete'
        ELSE 'active'
    END AS project_status,
    (SELECT COUNT(*) FROM tasks t WHERE t.project_id = p.id) AS total_tasks
FROM projects p
WHERE p.owner_id = '550e8400-e29b-41d4-a716-446655440000'
ORDER BY p.created_at DESC;

-- Insert with ON CONFLICT
INSERT INTO users (email, name, role, metadata)
VALUES
    ('alice@example.com', 'Alice', 'admin', '{"team": "platform"}'),
    ('bob@example.com', 'Bob', 'editor', '{"team": "frontend"}')
ON CONFLICT (email) DO UPDATE SET
    name = EXCLUDED.name,
    metadata = users.metadata || EXCLUDED.metadata,
    updated_at = NOW()
RETURNING id, email, role;

-- Update with FROM and subquery
UPDATE tasks
SET status = 'cancelled',
    updated_at = NOW()
FROM projects p
WHERE tasks.project_id = p.id
  AND p.archived = TRUE
  AND tasks.status IN ('pending', 'in_progress')
RETURNING tasks.id, tasks.title;

-- Delete with USING
DELETE FROM tasks t
USING projects p
WHERE t.project_id = p.id
  AND p.owner_id NOT IN (
      SELECT id FROM users WHERE active = TRUE
  );
