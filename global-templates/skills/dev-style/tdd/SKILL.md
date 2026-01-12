---
name: tdd
description: |
  TDD-based development workflow for data pipelines.
  Write tests first, then implement. Ensures reliability and maintainability.
  Trigger: "TDD", "test first", "write tests", "test-driven"
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
  - Bash(pytest:*)
  - Bash(cargo test:*)
---

# TDD Development Workflow

## Cycle: Red → Green → Refactor

### Step 1: Red (Write Failing Test)
Write a test that defines expected behavior before implementation.

```python
# tests/test_pipeline.py
import pytest
import polars as pl

def test_transform_filters_inactive_records():
    # Arrange
    input_df = pl.DataFrame({
        "id": [1, 2, 3],
        "status": ["active", "inactive", "active"],
        "amount": [100, 200, 300]
    })

    # Act
    result = transform(input_df)

    # Assert
    assert result.shape[0] == 2
    assert "inactive" not in result["status"].to_list()
```

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_valid_record() {
        let raw = b"valid,record,data";
        let result = parse_record(raw);
        assert!(result.is_ok());
    }
}
```

### Step 2: Green (Minimal Implementation)
Write just enough code to pass the test.

```python
# src/pipeline.py
import polars as pl

def transform(df: pl.DataFrame) -> pl.DataFrame:
    return df.filter(pl.col("status") == "active")
```

### Step 3: Refactor (Improve)
Clean up while keeping tests green.

- Remove duplication
- Improve naming
- Optimize performance

## Test Categories

### Unit Tests
- Individual function behavior
- Edge cases
- Error handling

### Integration Tests
- Pipeline end-to-end
- Database interactions
- External service mocks

### Property-Based Tests
```python
from hypothesis import given, strategies as st

@given(st.lists(st.integers()))
def test_transform_preserves_count_or_reduces(data):
    df = pl.DataFrame({"value": data})
    result = transform(df)
    assert result.shape[0] <= df.shape[0]
```

## Data Pipeline Test Patterns

### Test Fixtures
```python
@pytest.fixture
def sample_bronze_data():
    return pl.DataFrame({
        "raw_id": ["a", "b", "c"],
        "payload": ['{"x":1}', '{"x":2}', '{"x":3}']
    })

@pytest.fixture
def expected_silver_data():
    return pl.DataFrame({
        "id": ["a", "b", "c"],
        "x": [1, 2, 3]
    })
```

### Schema Validation Tests
```python
def test_output_schema_matches_expected():
    result = transform(input_df)
    assert result.schema == expected_schema
```

### Idempotency Tests
```python
def test_transform_is_idempotent():
    first_run = transform(input_df)
    second_run = transform(input_df)
    assert first_run.equals(second_run)
```

## Output

When applying TDD:
1. Show the test being written first
2. Show test failure output
3. Show minimal implementation
4. Show test passing
5. Show any refactoring
