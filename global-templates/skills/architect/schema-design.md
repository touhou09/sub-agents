---
name: schema-design
description: |
  Data schema design and validation for robust data pipelines.
  Define schemas, handle evolution, ensure compatibility.
  Trigger: "schema", "data model", "table design", "column", "type"
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
---

# Schema Design Workflow

## Principles

1. **Explicit over implicit**: Always define schemas explicitly
2. **Evolution ready**: Design for future changes
3. **Validation at boundaries**: Validate at ingestion points
4. **Document intent**: Schema is documentation

## Schema Definition

### Polars Schema
```python
import polars as pl

SCHEMA = {
    "id": pl.Utf8,
    "timestamp": pl.Datetime("us"),
    "amount": pl.Float64,
    "status": pl.Categorical,
    "metadata": pl.Struct({
        "source": pl.Utf8,
        "version": pl.Int32,
    }),
}

df = pl.read_parquet("data.parquet", schema=SCHEMA)
```

### Arrow Schema
```python
import pyarrow as pa

SCHEMA = pa.schema([
    pa.field("id", pa.string(), nullable=False),
    pa.field("timestamp", pa.timestamp("us")),
    pa.field("amount", pa.float64()),
    pa.field("tags", pa.list_(pa.string())),
])
```

### Delta Lake Schema
```python
from deltalake import DeltaTable

schema = pa.schema([
    ("id", pa.string()),
    ("value", pa.int64()),
    ("updated_at", pa.timestamp("us")),
])

DeltaTable.create(
    table_uri="delta/table",
    schema=schema,
    partition_by=["date"],
)
```

## Schema Evolution

### Compatible Changes (Safe)
| Change | Backward | Forward |
|--------|----------|---------|
| Add nullable column | ✓ | ✓ |
| Add column with default | ✓ | ✓ |
| Widen type (int32→int64) | ✓ | ✗ |

### Incompatible Changes (Dangerous)
| Change | Risk |
|--------|------|
| Remove column | Breaks readers |
| Rename column | Breaks readers |
| Change type (string→int) | Data loss |
| Make nullable→required | Breaks writers |

### Evolution Strategy
```python
# Version 1
schema_v1 = {"id": pl.Utf8, "value": pl.Int64}

# Version 2: Add nullable column (safe)
schema_v2 = {
    "id": pl.Utf8,
    "value": pl.Int64,
    "category": pl.Utf8,  # New, nullable
}

# Migration function
def migrate_v1_to_v2(df: pl.DataFrame) -> pl.DataFrame:
    return df.with_columns(
        pl.lit(None).cast(pl.Utf8).alias("category")
    )
```

## Validation

### Schema Validation
```python
def validate_schema(df: pl.DataFrame, expected: dict) -> bool:
    """Validate DataFrame schema matches expected."""
    for col, dtype in expected.items():
        if col not in df.columns:
            raise ValueError(f"Missing column: {col}")
        if df[col].dtype != dtype:
            raise TypeError(f"Column {col}: expected {dtype}, got {df[col].dtype}")
    return True
```

### Data Validation Rules
```python
import pandera.polars as pa

class UserSchema(pa.DataFrameModel):
    id: str = pa.Field(unique=True)
    email: str = pa.Field(str_matches=r"^[\w.-]+@[\w.-]+\.\w+$")
    age: int = pa.Field(ge=0, le=150)
    created_at: datetime

    class Config:
        strict = True
```

### Null Handling Policy
```python
# Define null policy per column
NULL_POLICY = {
    "id": "reject",      # Never allow nulls
    "email": "reject",   # Never allow nulls
    "phone": "allow",    # Optional field
    "metadata": "default",  # Use default value
}

def apply_null_policy(df: pl.DataFrame) -> pl.DataFrame:
    for col, policy in NULL_POLICY.items():
        if policy == "reject":
            null_count = df[col].null_count()
            if null_count > 0:
                raise ValueError(f"Column {col} has {null_count} nulls")
        elif policy == "default":
            df = df.with_columns(pl.col(col).fill_null(DEFAULTS[col]))
    return df
```

## Medallion Architecture Schemas

### Bronze (Raw)
```python
BRONZE_SCHEMA = {
    "_ingestion_ts": pl.Datetime("us"),
    "_source": pl.Utf8,
    "_raw_payload": pl.Utf8,  # JSON string
}
```

### Silver (Cleaned)
```python
SILVER_SCHEMA = {
    "id": pl.Utf8,
    "timestamp": pl.Datetime("us"),
    "amount": pl.Float64,
    "status": pl.Categorical,
    "_bronze_id": pl.Utf8,  # Lineage
    "_processed_at": pl.Datetime("us"),
}
```

### Gold (Business)
```python
GOLD_SCHEMA = {
    "date": pl.Date,
    "category": pl.Categorical,
    "total_amount": pl.Float64,
    "transaction_count": pl.UInt32,
    "_updated_at": pl.Datetime("us"),
}
```

## Output Format

When designing schemas:
```
## Schema Design: <table_name>

### Purpose
<description>

### Columns
| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | string | No | Primary identifier |
| ... | ... | ... | ... |

### Partitioning
- Partition by: date
- Expected partition size: ~100MB

### Evolution Notes
- v1 → v2: Added `category` column (nullable)
```
