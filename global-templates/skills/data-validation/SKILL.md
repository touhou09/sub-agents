---
name: data-validation
description: |
  This skill should be used when the user asks to "validate data", "check data quality",
  "data integrity", "schema validation", "data contracts", or mentions data quality
  frameworks like Great Expectations, dbt tests, or Pandera.
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
  - Bash(python:*)
---

# Data Validation Skill

Implement comprehensive data validation and quality checks.

## When to Use

Activate when:
- User needs to validate datasets
- User wants to set up data quality rules
- User mentions schema validation or data contracts

## Validation Approaches

### 1. Schema Validation

**JSON Schema**
```python
from jsonschema import validate

schema = {
    "type": "object",
    "properties": {
        "id": {"type": "integer"},
        "email": {"type": "string", "format": "email"},
        "created_at": {"type": "string", "format": "date-time"}
    },
    "required": ["id", "email"]
}

validate(instance=data, schema=schema)
```

**Pydantic**
```python
from pydantic import BaseModel, EmailStr, field_validator
from datetime import datetime

class User(BaseModel):
    id: int
    email: EmailStr
    created_at: datetime

    @field_validator('id')
    @classmethod
    def id_must_be_positive(cls, v):
        if v <= 0:
            raise ValueError('id must be positive')
        return v
```

### 2. Data Quality Checks

**Essential Checks**
- Null/missing values
- Data type conformity
- Value range validation
- Uniqueness constraints
- Referential integrity
- Format validation (dates, emails, etc.)

**Statistical Checks**
- Outlier detection
- Distribution analysis
- Trend monitoring

### 3. Frameworks

**Great Expectations**
```python
import great_expectations as gx

context = gx.get_context()

# Create expectation suite
suite = context.add_expectation_suite("user_data_suite")

# Add expectations
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToNotBeNull(column="id")
)
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToBeUnique(column="email")
)
suite.add_expectation(
    gx.expectations.ExpectColumnValuesToBeBetween(
        column="age", min_value=0, max_value=150
    )
)
```

**dbt Tests**
```yaml
# schema.yml
version: 2

models:
  - name: users
    columns:
      - name: id
        tests:
          - unique
          - not_null
      - name: email
        tests:
          - unique
          - not_null
      - name: status
        tests:
          - accepted_values:
              values: ['active', 'inactive', 'pending']
```

**Pandera**
```python
import pandera as pa
from pandera import Column, Check

schema = pa.DataFrameSchema({
    "id": Column(int, Check.gt(0), nullable=False),
    "email": Column(str, Check.str_matches(r"^[\w.-]+@[\w.-]+\.\w+$")),
    "age": Column(int, Check.in_range(0, 150), nullable=True),
    "status": Column(str, Check.isin(["active", "inactive", "pending"]))
})

# Validate
validated_df = schema.validate(df)
```

### 4. Custom Validation Functions

```python
from typing import List, Dict, Any
from dataclasses import dataclass

@dataclass
class ValidationResult:
    is_valid: bool
    errors: List[str]

def validate_record(record: Dict[str, Any]) -> ValidationResult:
    errors = []

    # Required fields
    required = ['id', 'email', 'name']
    for field in required:
        if field not in record or record[field] is None:
            errors.append(f"Missing required field: {field}")

    # Email format
    if 'email' in record and record['email']:
        import re
        if not re.match(r"^[\w.-]+@[\w.-]+\.\w+$", record['email']):
            errors.append(f"Invalid email format: {record['email']}")

    # Numeric ranges
    if 'age' in record and record['age'] is not None:
        if not (0 <= record['age'] <= 150):
            errors.append(f"Age out of range: {record['age']}")

    return ValidationResult(
        is_valid=len(errors) == 0,
        errors=errors
    )
```

## Output Format

Provide:
1. Validation rules configuration
2. Error handling strategy
3. Monitoring recommendations

```markdown
## Validation Report

### Summary
- Total records: X
- Valid records: Y
- Invalid records: Z
- Validation rate: XX%

### Issues Found
| Field | Issue | Count | Sample |
|-------|-------|-------|--------|
| email | Invalid format | 15 | bad@@ |
| age | Out of range | 3 | -5 |

### Recommendations
- ...
```
