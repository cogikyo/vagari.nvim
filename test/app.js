import EventEmitter from "node:events";

// Symbols for private fields
const _cache = Symbol("cache");
const _hooks = Symbol("hooks");

/**
 * Plugin-based application framework.
 * Demonstrates classes, async/await, iterators, proxy, regex, destructuring.
 */
class Application extends EventEmitter {
  #name;
  #version;
  [_cache] = new Map();
  [_hooks] = { before: [], after: [] };

  static defaults = {
    maxRetries: 3,
    timeout: 5_000,
    debug: false,
  };

  constructor(name, { version = "1.0.0", ...options } = {}) {
    super();
    this.#name = name;
    this.#version = version;
    this.options = { ...Application.defaults, ...options };
  }

  get info() {
    return `${this.#name}@${this.#version}`;
  }

  // Plugin system with lifecycle hooks
  use(plugin) {
    const { name, setup, teardown } = plugin;
    if (!name || typeof setup !== "function") {
      throw new TypeError(`Invalid plugin: expected {name, setup}, got ${typeof plugin}`);
    }

    this[_hooks].before.push(() => setup(this));
    if (teardown) {
      this[_hooks].after.push(() => teardown(this));
    }

    this.emit("plugin:registered", { name, timestamp: Date.now() });
    return this; // chainable
  }

  // Async initialization with error aggregation
  async start() {
    const errors = [];

    for (const hook of this[_hooks].before) {
      try {
        await hook();
      } catch (err) {
        errors.push(err);
      }
    }

    if (errors.length > 0) {
      throw new AggregateError(errors, `${errors.length} plugin(s) failed to start`);
    }

    this.emit("ready", { app: this.info });
  }

  // Generator for paginated data
  async *paginate(fetchPage, { pageSize = 20 } = {}) {
    let cursor = null;
    let hasMore = true;

    while (hasMore) {
      const { data, nextCursor } = await fetchPage({ cursor, limit: pageSize });
      yield* data;
      cursor = nextCursor;
      hasMore = cursor !== null && data.length === pageSize;
    }
  }

  // Memoized fetch with TTL
  async cached(key, fn, ttl = 60_000) {
    const entry = this[_cache].get(key);
    if (entry && Date.now() - entry.time < ttl) {
      return entry.value;
    }

    const value = await fn();
    this[_cache].set(key, { value, time: Date.now() });
    return value;
  }
}

// Proxy-based config with validation
function createConfig(defaults) {
  const validators = {
    port: (v) => Number.isInteger(v) && v > 0 && v < 65536,
    host: (v) => /^[\w.-]+$/.test(v),
    env: (v) => ["development", "staging", "production"].includes(v),
  };

  return new Proxy({ ...defaults }, {
    set(target, prop, value) {
      const validate = validators[prop];
      if (validate && !validate(value)) {
        throw new RangeError(`Invalid value for ${String(prop)}: ${value}`);
      }
      target[prop] = value;
      return true;
    },

    get(target, prop) {
      if (prop === "toJSON") {
        return () => ({ ...target });
      }
      return target[prop];
    },
  });
}

// Destructuring, template literals, regex
function parseConnectionString(connStr) {
  const pattern = /^(?<protocol>\w+):\/\/(?<user>[^:]+):(?<pass>[^@]+)@(?<host>[^:/]+):(?<port>\d+)\/(?<db>\w+)$/;
  const match = connStr.match(pattern);

  if (!match?.groups) {
    throw new SyntaxError(`Invalid connection string: "${connStr}"`);
  }

  const { protocol, user, host, port, db, ...rest } = match.groups;
  return {
    protocol,
    credentials: { user, password: rest.pass ?? match.groups.pass },
    endpoint: `${host}:${port}`,
    database: db,
    ssl: protocol === "https" || protocol === "mqtts",
  };
}

export { Application, createConfig, parseConnectionString };
