"""Domain models with dataclasses, protocols, enums, and type hints."""

from __future__ import annotations

import re
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum, auto
from typing import Generic, Protocol, Self, TypeVar, override, runtime_checkable

T = TypeVar("T")
K = TypeVar("K", bound=str | int)


class Priority(Enum):
    LOW = auto()
    MEDIUM = auto()
    HIGH = auto()
    CRITICAL = auto()


@runtime_checkable
class Serializable(Protocol):
    """Any object that can convert itself to a dictionary."""

    def to_dict(self) -> dict[str, object]: ...


class Validatable(ABC):
    """Base class requiring validation before persistence."""

    @abstractmethod
    def validate(self) -> list[str]:
        """Return a list of validation error messages, empty if valid."""
        ...

    def is_valid(self) -> bool:
        return len(self.validate()) == 0


EMAIL_PATTERN = re.compile(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")


@dataclass(frozen=True, slots=True)
class Email:
    address: str

    def __post_init__(self) -> None:
        if not EMAIL_PATTERN.match(self.address):
            raise ValueError(f"Invalid email: {self.address!r}")

    def __str__(self) -> str:
        return self.address

    @property
    def domain(self) -> str:
        return self.address.split("@")[1]


@dataclass
class User(Validatable):
    id: int
    name: str
    email: Email
    role: str = "viewer"
    active: bool = True
    tags: set[str] = field(default_factory=set)
    created_at: datetime = field(default_factory=datetime.now)

    @override
    def validate(self) -> list[str]:
        errors: list[str] = []
        if len(self.name) < 2:
            errors.append("Name must be at least 2 characters")
        if self.role not in ("admin", "editor", "viewer"):
            errors.append(f"Unknown role: {self.role!r}")
        return errors

    def to_dict(self) -> dict[str, object]:
        return {
            "id": self.id,
            "name": self.name,
            "email": str(self.email),
            "role": self.role,
            "active": self.active,
            "tags": sorted(self.tags),
        }

    def promote(self) -> Self:
        """Return a new User with elevated role."""
        promotion = {"viewer": "editor", "editor": "admin"}
        new_role = promotion.get(self.role, self.role)
        return type(self)(
            id=self.id, name=self.name, email=self.email,
            role=new_role, active=self.active, tags=self.tags,
        )


@dataclass
class Task(Validatable):
    title: str
    assignee: User | None = None
    priority: Priority = Priority.MEDIUM
    labels: list[str] = field(default_factory=list)
    completed: bool = False
    _watchers: list[User] = field(default_factory=list, repr=False)

    @override
    def validate(self) -> list[str]:
        errors: list[str] = []
        if not self.title.strip():
            errors.append("Title cannot be empty")
        if self.completed and self.priority == Priority.CRITICAL:
            errors.append("Critical tasks require review before completion")
        return errors

    def assign(self, user: User) -> None:
        self.assignee = user
        if user not in self._watchers:
            self._watchers.append(user)


class Registry(Generic[K, T]):
    """Generic registry mapping keys to items with lookup."""

    def __init__(self) -> None:
        self._items: dict[K, T] = {}

    def register(self, key: K, item: T) -> None:
        if key in self._items:
            raise KeyError(f"Key {key!r} already registered")
        self._items[key] = item

    def get(self, key: K) -> T | None:
        return self._items.get(key)

    def __contains__(self, key: K) -> bool:
        return key in self._items

    def __len__(self) -> int:
        return len(self._items)

    def __iter__(self):
        yield from self._items.values()
