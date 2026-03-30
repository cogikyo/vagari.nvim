// Type-heavy TypeScript: utility types, generics, type guards, mapped types.

type Primitive = string | number | boolean | null | undefined;

type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
};

type DeepReadonly<T> = {
  readonly [P in keyof T]: T[P] extends object ? DeepReadonly<T[P]> : T[P];
};

type PickByType<T, U> = {
  [K in keyof T as T[K] extends U ? K : never]: T[K];
};

// Conditional types with infer
type UnwrapPromise<T> = T extends Promise<infer U> ? UnwrapPromise<U> : T;
type ReturnTypeAsync<T extends (...args: any[]) => any> = UnwrapPromise<ReturnType<T>>;

type EventMap = {
  click: { x: number; y: number; button: number };
  keydown: { key: string; code: string; ctrlKey: boolean };
  resize: { width: number; height: number };
  custom: { detail: unknown };
};

type EventName = keyof EventMap;

// Discriminated union
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E };

// Type guard functions
function isString(value: unknown): value is string {
  return typeof value === "string";
}

function isResult<T>(value: unknown): value is Result<T> {
  return (
    typeof value === "object" &&
    value !== null &&
    "ok" in value &&
    typeof (value as Record<string, unknown>).ok === "boolean"
  );
}

function assertDefined<T>(value: T | null | undefined, name: string): asserts value is T {
  if (value === null || value === undefined) {
    throw new Error(`Expected ${name} to be defined, got ${value}`);
  }
}

// Generic class with constraints
class TypedEventEmitter<Events extends Record<string, any>> {
  private listeners = new Map<keyof Events, Set<(data: any) => void>>();

  on<K extends keyof Events>(event: K, handler: (data: Events[K]) => void): () => void {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, new Set());
    }
    this.listeners.get(event)!.add(handler);

    return () => this.listeners.get(event)?.delete(handler);
  }

  emit<K extends keyof Events>(event: K, data: Events[K]): void {
    this.listeners.get(event)?.forEach((handler) => handler(data));
  }
}

// Builder pattern with fluent types
interface QueryBuilder<T> {
  where<K extends keyof T>(field: K, op: "=" | "!=" | ">" | "<", value: T[K]): QueryBuilder<T>;
  orderBy<K extends keyof T>(field: K, dir?: "asc" | "desc"): QueryBuilder<T>;
  limit(n: number): QueryBuilder<T>;
  execute(): Promise<T[]>;
}

// Template literal types
type HTTPMethod = "GET" | "POST" | "PUT" | "DELETE" | "PATCH";
type APIRoute = `/api/${string}`;
type TypedRoute<M extends HTTPMethod> = `${M} ${APIRoute}`;

// Async utility
async function retry<T>(
  fn: () => Promise<T>,
  opts: { attempts?: number; delay?: number; backoff?: number } = {},
): Promise<T> {
  const { attempts = 3, delay = 1000, backoff = 2 } = opts;

  for (let i = 0; i < attempts; i++) {
    try {
      return await fn();
    } catch (err) {
      if (i === attempts - 1) throw err;
      await new Promise((r) => setTimeout(r, delay * Math.pow(backoff, i)));
    }
  }

  throw new Error("unreachable");
}

// Mapped type with template literal keys
type Getters<T> = {
  [K in keyof T as `get${Capitalize<string & K>}`]: () => T[K];
};

type Setters<T> = {
  [K in keyof T as `set${Capitalize<string & K>}`]: (value: T[K]) => void;
};

type Accessors<T> = Getters<T> & Setters<T>;

export type {
  DeepPartial,
  DeepReadonly,
  PickByType,
  Result,
  EventMap,
  QueryBuilder,
  TypedRoute,
  Accessors,
};

export { TypedEventEmitter, isString, isResult, assertDefined, retry };
