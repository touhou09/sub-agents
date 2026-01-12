---
name: sql-optimize
description: |
  This skill should be used when the user asks to "optimize SQL", "slow query",
  "query performance", "execution plan", "index optimization",
  or analyzes database query performance.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(psql:*)
  - Bash(mysql:*)
---

# SQL Optimization Skill

Database query analysis and optimization.

## Optimization Process

### 1. Query Analysis

**Get Execution Plan**
```sql
-- PostgreSQL
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT * FROM orders WHERE user_id = 123;

-- PostgreSQL with timing
EXPLAIN (ANALYZE, BUFFERS, TIMING, FORMAT TEXT)
SELECT * FROM orders WHERE user_id = 123;

-- MySQL
EXPLAIN ANALYZE
SELECT * FROM orders WHERE user_id = 123;

-- Show actual execution stats
EXPLAIN (ANALYZE, VERBOSE, BUFFERS)
SELECT * FROM orders WHERE user_id = 123;
```

**Key Metrics to Check**
- Execution time
- Rows examined vs returned
- Index usage (Index Scan vs Seq Scan)
- Join types (Nested Loop, Hash Join, Merge Join)
- Sort operations
- Buffer hits vs reads

### 2. Common Issues & Solutions

**Full Table Scans**
```sql
-- Problem: No index on frequently queried column
SELECT * FROM users WHERE email = 'user@example.com';
-- Shows: Seq Scan on users

-- Solution: Add index
CREATE INDEX idx_users_email ON users(email);
-- Now shows: Index Scan using idx_users_email
```

**N+1 Query Pattern**
```sql
-- Problem: Separate query for each user's orders
SELECT * FROM users WHERE active = true;
-- Then for each user:
SELECT * FROM orders WHERE user_id = ?;

-- Solution: Use JOIN
SELECT u.*, o.*
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.active = true;

-- Or use IN clause for batch fetch
SELECT * FROM orders
WHERE user_id IN (SELECT id FROM users WHERE active = true);
```

**Missing Composite Index**
```sql
-- Problem: Query filters on multiple columns
SELECT * FROM orders
WHERE user_id = 123 AND status = 'pending'
ORDER BY created_at DESC;

-- Solution: Composite index matching query pattern
CREATE INDEX idx_orders_user_status_created
ON orders(user_id, status, created_at DESC);
```

**Inefficient JOIN**
```sql
-- Problem: Joining large tables without proper indexes
SELECT o.*, p.name
FROM orders o
JOIN products p ON o.product_id = p.id
WHERE o.created_at > '2024-01-01';

-- Solution: Ensure foreign keys are indexed
CREATE INDEX idx_orders_product_id ON orders(product_id);
CREATE INDEX idx_orders_created_at ON orders(created_at);
```

### 3. Index Guidelines

**When to Create Indexes**
- WHERE clause columns
- JOIN columns (foreign keys)
- ORDER BY columns
- Columns in GROUP BY
- Columns with high selectivity

**When to Avoid Indexes**
- Small tables (< 1000 rows)
- Frequently updated columns
- Low cardinality columns (boolean, status with few values)
- Columns rarely used in queries
- Tables with heavy write load

**Index Types**
```sql
-- B-tree (default, most common)
CREATE INDEX idx_name ON table(column);

-- Hash (equality only)
CREATE INDEX idx_name ON table USING hash(column);

-- GIN (arrays, full-text search)
CREATE INDEX idx_name ON table USING gin(column);

-- GiST (geometric, full-text)
CREATE INDEX idx_name ON table USING gist(column);

-- Partial index (subset of rows)
CREATE INDEX idx_active_users ON users(email) WHERE active = true;

-- Expression index
CREATE INDEX idx_lower_email ON users(lower(email));
```

### 4. Query Rewrite Patterns

**Use EXISTS Instead of IN for Large Sets**
```sql
-- Slower for large subqueries
SELECT * FROM orders
WHERE user_id IN (SELECT id FROM users WHERE active = true);

-- Faster with EXISTS
SELECT * FROM orders o
WHERE EXISTS (
    SELECT 1 FROM users u
    WHERE u.id = o.user_id AND u.active = true
);
```

**Avoid SELECT ***
```sql
-- Bad: Fetches unnecessary data
SELECT * FROM users WHERE id = 123;

-- Good: Only select needed columns
SELECT id, name, email FROM users WHERE id = 123;
```

**Efficient Pagination**
```sql
-- Slow for deep pages (OFFSET scans all skipped rows)
SELECT * FROM orders ORDER BY id LIMIT 20 OFFSET 10000;

-- Fast: Keyset pagination
SELECT * FROM orders
WHERE id > :last_seen_id
ORDER BY id
LIMIT 20;
```

**Batch Operations**
```sql
-- Slow: Individual inserts
INSERT INTO logs (message) VALUES ('msg1');
INSERT INTO logs (message) VALUES ('msg2');

-- Fast: Batch insert
INSERT INTO logs (message) VALUES
    ('msg1'),
    ('msg2'),
    ('msg3');
```

### 5. Monitoring Queries

**PostgreSQL**
```sql
-- Enable slow query logging
-- In postgresql.conf:
-- log_min_duration_statement = 1000  -- Log queries > 1s

-- Find slow queries
SELECT query, calls, mean_exec_time, total_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;

-- Find missing indexes
SELECT relname, seq_scan, idx_scan,
       seq_scan - idx_scan AS diff
FROM pg_stat_user_tables
WHERE seq_scan > idx_scan
ORDER BY diff DESC;

-- Table bloat
SELECT schemaname, tablename,
       pg_size_pretty(pg_total_relation_size(schemaname || '.' || tablename))
FROM pg_tables
ORDER BY pg_total_relation_size(schemaname || '.' || tablename) DESC
LIMIT 10;
```

**MySQL**
```sql
-- Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;

-- Find queries not using indexes
SHOW GLOBAL STATUS LIKE 'Select_full_join';
SHOW GLOBAL STATUS LIKE 'Select_scan';
```

## Output Format

```markdown
## Query Optimization Report

### Original Query
```sql
[Original SQL]
```

### Execution Plan Analysis
- **Scan Type**: Sequential Scan / Index Scan
- **Rows Estimated**: X
- **Rows Actual**: Y
- **Execution Time**: Z ms

### Issues Found
1. **Missing Index**: Column `user_id` lacks index
2. **Full Table Scan**: No filter pushdown
3. **N+1 Pattern**: Multiple queries in loop

### Optimized Query
```sql
[Optimized SQL]
```

### Recommended Indexes
```sql
CREATE INDEX idx_name ON table(column);
```

### Expected Improvement
- Before: X ms
- After: Y ms (estimated Z% improvement)
```
