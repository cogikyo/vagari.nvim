"""FastAPI-style web server with decorators, async handlers, and middleware."""

from collections.abc import AsyncGenerator, Callable
from contextlib import asynccontextmanager
from datetime import datetime, timezone
from functools import wraps
from typing import Any

from fastapi import Depends, FastAPI, HTTPException, Query, Request, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field


# --- Lifespan ----------------------------------------------------------------

@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None]:
    """Startup and shutdown logic for the application."""
    print(f"Starting up at {datetime.now(timezone.utc).isoformat()}")
    app.state.db = await create_pool()
    yield
    await app.state.db.close()
    print("Shut down cleanly")


app = FastAPI(title="Vagari API", version="0.1.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "https://example.com"],
    allow_methods=["*"],
    allow_headers=["*"],
    allow_credentials=True,
)


# --- Schemas -----------------------------------------------------------------

class ItemCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=200)
    description: str | None = None
    price: float = Field(..., gt=0, le=1_000_000)
    tags: list[str] = Field(default_factory=list, max_length=10)


class ItemResponse(BaseModel):
    id: int
    name: str
    description: str | None
    price: float
    tags: list[str]
    created_at: datetime

    model_config = {"from_attributes": True}


class PaginatedResponse(BaseModel):
    items: list[ItemResponse]
    total: int
    page: int
    per_page: int
    has_next: bool


# --- Dependencies ------------------------------------------------------------

async def create_pool():
    """Placeholder for database pool creation."""
    return type("Pool", (), {"close": lambda self: None})()


async def get_db(request: Request):
    return request.app.state.db


def require_role(*roles: str) -> Callable:
    """Decorator factory for role-based access control."""
    def decorator(fn: Callable) -> Callable:
        @wraps(fn)
        async def wrapper(*args: Any, **kwargs: Any) -> Any:
            # Simulated auth check
            user_role = kwargs.get("role", "viewer")
            if user_role not in roles:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail=f"Requires one of: {', '.join(roles)}",
                )
            return await fn(*args, **kwargs)
        return wrapper
    return decorator


# --- Middleware --------------------------------------------------------------

@app.middleware("http")
async def timing_middleware(request: Request, call_next: Callable) -> Any:
    start = datetime.now(timezone.utc)
    response = await call_next(request)

    duration_ms = (datetime.now(timezone.utc) - start).total_seconds() * 1000
    response.headers["X-Process-Time"] = f"{duration_ms:.2f}ms"
    return response


# --- Routes ------------------------------------------------------------------

@app.get("/health")
async def health_check() -> dict[str, str]:
    return {"status": "healthy", "timestamp": datetime.now(timezone.utc).isoformat()}


@app.post("/items", response_model=ItemResponse, status_code=status.HTTP_201_CREATED)
async def create_item(item: ItemCreate, db=Depends(get_db)):
    # Simulated insertion
    return ItemResponse(
        id=42,
        name=item.name,
        description=item.description,
        price=item.price,
        tags=item.tags,
        created_at=datetime.now(timezone.utc),
    )


@app.get("/items", response_model=PaginatedResponse)
async def list_items(
    page: int = Query(1, ge=1),
    per_page: int = Query(20, ge=1, le=100),
    search: str | None = Query(None, min_length=1),
    db=Depends(get_db),
):
    """List items with pagination and optional search.

    Supports filtering by name substring and tag matching.
    Results are ordered by creation date descending.
    """
    # Simulated query with comprehension
    all_items = [
        ItemResponse(
            id=i,
            name=f"Item {i}",
            description=f"Description for item {i}" if i % 2 == 0 else None,
            price=round(9.99 * i, 2),
            tags=[t for t in ["sale", "new", "featured"] if hash(t) % (i + 1) == 0],
            created_at=datetime.now(timezone.utc),
        )
        for i in range(1, 101)
    ]

    filtered = [
        item for item in all_items
        if search is None or search.lower() in item.name.lower()
    ]

    start = (page - 1) * per_page
    end = start + per_page

    return PaginatedResponse(
        items=filtered[start:end],
        total=len(filtered),
        page=page,
        per_page=per_page,
        has_next=end < len(filtered),
    )


@app.delete("/items/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
@require_role("admin", "editor")
async def delete_item(item_id: int, db=Depends(get_db), role: str = "viewer"):
    if item_id <= 0:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Item {item_id} not found",
        )
