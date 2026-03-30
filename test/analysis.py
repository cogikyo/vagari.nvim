"""Data analysis patterns: comprehensions, generators, numpy/pandas style."""

from __future__ import annotations

import csv
import math
import statistics
from collections import Counter, defaultdict
from dataclasses import dataclass
from itertools import groupby, islice
from operator import attrgetter
from pathlib import Path
from typing import Iterator, NamedTuple


class DataPoint(NamedTuple):
    timestamp: float
    value: float
    label: str
    quality: int


@dataclass
class Summary:
    count: int
    mean: float
    median: float
    std_dev: float
    min_val: float
    max_val: float
    p95: float

    @property
    def range(self) -> float:
        return self.max_val - self.min_val

    def __repr__(self) -> str:
        return (
            f"Summary(n={self.count}, μ={self.mean:.2f}, "
            f"σ={self.std_dev:.2f}, range=[{self.min_val:.2f}, {self.max_val:.2f}])"
        )


# --- Generators and iterators ------------------------------------------------

def read_csv_lazy(path: Path) -> Iterator[DataPoint]:
    """Lazily read data points from CSV without loading the entire file."""
    with open(path, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            yield DataPoint(
                timestamp=float(row["ts"]),
                value=float(row["value"]),
                label=row.get("label", "unknown"),
                quality=int(row.get("quality", 0)),
            )


def sliding_window(data: Iterator[float], size: int) -> Iterator[list[float]]:
    """Generate overlapping windows of fixed size."""
    buffer: list[float] = []
    for item in data:
        buffer.append(item)
        if len(buffer) == size:
            yield list(buffer)
            buffer.pop(0)


def exponential_smoothing(values: list[float], alpha: float = 0.3) -> list[float]:
    """Apply simple exponential smoothing to a time series."""
    if not values:
        return []

    smoothed = [values[0]]
    for val in values[1:]:
        smoothed.append(alpha * val + (1 - alpha) * smoothed[-1])
    return smoothed


# --- Analysis functions ------------------------------------------------------

def summarize(values: list[float]) -> Summary:
    """Compute descriptive statistics for a list of values."""
    sorted_vals = sorted(values)
    n = len(sorted_vals)
    p95_idx = int(math.ceil(0.95 * n)) - 1

    return Summary(
        count=n,
        mean=statistics.mean(sorted_vals),
        median=statistics.median(sorted_vals),
        std_dev=statistics.stdev(sorted_vals) if n > 1 else 0.0,
        min_val=sorted_vals[0],
        max_val=sorted_vals[-1],
        p95=sorted_vals[p95_idx],
    )


def detect_anomalies(
    values: list[float],
    threshold: float = 2.0,
) -> list[tuple[int, float, float]]:
    """Find values that deviate more than `threshold` standard deviations."""
    mean = statistics.mean(values)
    std = statistics.stdev(values) if len(values) > 1 else 0.0

    return [
        (i, val, (val - mean) / std)
        for i, val in enumerate(values)
        if std > 0 and abs(val - mean) > threshold * std
    ]


def group_and_aggregate(
    data: list[DataPoint],
) -> dict[str, Summary]:
    """Group data points by label and compute per-group summaries."""
    sorted_data = sorted(data, key=attrgetter("label"))

    return {
        label: summarize([dp.value for dp in group])
        for label, group in groupby(sorted_data, key=attrgetter("label"))
    }


def frequency_table(labels: list[str], top_n: int = 10) -> list[tuple[str, int, float]]:
    """Build a frequency table with counts and percentages."""
    counts = Counter(labels)
    total = sum(counts.values())

    return [
        (label, count, count / total * 100)
        for label, count in counts.most_common(top_n)
    ]


def bucket_histogram(
    values: list[float],
    n_buckets: int = 10,
) -> dict[str, int]:
    """Bin values into equal-width buckets and count frequencies."""
    lo, hi = min(values), max(values)
    width = (hi - lo) / n_buckets if hi != lo else 1.0

    buckets: dict[str, int] = defaultdict(int)
    for val in values:
        idx = min(int((val - lo) / width), n_buckets - 1)
        lower = lo + idx * width
        upper = lower + width
        key = f"[{lower:.1f}, {upper:.1f})"
        buckets[key] += 1

    return dict(buckets)


# --- Pipeline composition ---------------------------------------------------

def pipeline(path: Path, quality_min: int = 3) -> dict[str, Summary]:
    """End-to-end analysis pipeline: read → filter → group → summarize."""
    raw = read_csv_lazy(path)

    # Filter low-quality readings, take first 10k
    clean = (dp for dp in raw if dp.quality >= quality_min and not math.isnan(dp.value))
    sample = islice(clean, 10_000)

    return group_and_aggregate(list(sample))
