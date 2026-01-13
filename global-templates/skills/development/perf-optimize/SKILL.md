---
name: perf-optimize
description: |
  Performance optimization focused on speed and resource efficiency.
  Profile first, then optimize. Measure before and after.
  Trigger: "optimize", "slow", "performance", "memory", "CPU", "resource"
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
  - Bash(python:*)
  - Bash(cargo:*)
  - Bash(pytest:*)
---

# Performance Optimization Workflow

## Principle: Measure → Analyze → Optimize → Verify

### Step 1: Measure (Profile First)

#### Python Profiling
```python
# Time profiling
import cProfile
import pstats

profiler = cProfile.Profile()
profiler.enable()
# ... code to profile ...
profiler.disable()
stats = pstats.Stats(profiler).sort_stats('cumtime')
stats.print_stats(10)

# Memory profiling
from memory_profiler import profile

@profile
def process_data():
    ...
```

#### Polars Query Plan
```python
# Analyze lazy query plan
df = pl.scan_parquet("data.parquet")
query = df.filter(...).group_by(...).agg(...)
print(query.explain(optimized=True))
```

#### Rust Profiling
```bash
# Flamegraph
cargo flamegraph --bin myapp

# Benchmark
cargo bench
```

### Step 2: Analyze Bottlenecks

#### Common Issues
| Issue | Symptom | Solution |
|-------|---------|----------|
| Full table scan | Slow filter | Add predicate pushdown |
| Memory spike | OOM errors | Use streaming/chunks |
| CPU bound | High CPU, slow | Parallelize |
| I/O bound | Low CPU, slow | Async I/O, batching |

### Step 3: Optimize

#### Polars Optimizations
```python
# Bad: Eager evaluation
df = pl.read_parquet("large.parquet")
result = df.filter(...).select(...)

# Good: Lazy evaluation with predicate pushdown
result = (
    pl.scan_parquet("large.parquet")
    .filter(pl.col("date") >= "2024-01-01")  # Pushdown
    .select(["id", "amount"])  # Column pruning
    .collect()
)
```

#### Memory Optimization
```python
# Streaming for large datasets
result = (
    pl.scan_parquet("huge.parquet")
    .filter(...)
    .collect(streaming=True)
)

# Process in chunks
for chunk in pl.read_parquet_batched("huge.parquet", batch_size=100_000):
    process(chunk)
```

#### Arrow Zero-Copy
```python
# Zero-copy conversion
arrow_table = df.to_arrow()

# Share memory between processes
import pyarrow.plasma as plasma
```

#### Rust Optimizations
```rust
// Use iterators instead of loops
let sum: i64 = data.iter().filter(|x| **x > 0).sum();

// Avoid allocations
let mut buffer = Vec::with_capacity(expected_size);

// Use SIMD via Arrow
use arrow::compute::sum;
let total = sum(&array)?;
```

### Step 4: Verify Improvement

```python
# Before/After comparison
import time

start = time.perf_counter()
result = process()
elapsed = time.perf_counter() - start

print(f"Time: {elapsed:.2f}s")
print(f"Memory: {result.estimated_size() / 1e6:.1f}MB")
```

## Optimization Checklist

### Data Loading
- [ ] Use lazy evaluation (scan vs read)
- [ ] Enable predicate pushdown
- [ ] Enable column pruning
- [ ] Use appropriate file format (Parquet > CSV)

### Processing
- [ ] Prefer columnar operations
- [ ] Avoid row-by-row iteration
- [ ] Use appropriate data types (Int32 vs Int64)
- [ ] Minimize data copies

### Memory
- [ ] Stream large datasets
- [ ] Release unused DataFrames
- [ ] Use chunked processing
- [ ] Monitor peak memory

### I/O
- [ ] Batch writes
- [ ] Use compression (zstd, lz4)
- [ ] Partition by access pattern
- [ ] Parallel I/O when possible

## Output Format

When optimizing:
```
## Performance Analysis

### Before
- Time: 45.2s
- Memory: 2.3GB
- Bottleneck: Full table scan in filter

### Optimization Applied
- Added predicate pushdown
- Enabled streaming mode
- Reduced column selection

### After
- Time: 3.8s (11.9x faster)
- Memory: 450MB (5.1x reduction)
```
