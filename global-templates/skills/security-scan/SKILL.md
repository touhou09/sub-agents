---
name: security-scan
description: |
  This skill should be used when the user asks to "check security", "security audit",
  "vulnerability scan", "secure this code", "OWASP", "penetration testing",
  or reviews code for security issues.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(npm audit:*)
  - Bash(pip-audit:*)
  - Bash(trivy:*)
  - Bash(semgrep:*)
  - Bash(gitleaks:*)
---

# Security Scan Skill

Comprehensive security analysis and vulnerability detection.

## Security Checklist

### 1. Input Validation
- [ ] All user inputs validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (output encoding)
- [ ] Command injection prevention
- [ ] Path traversal prevention

### 2. Authentication & Authorization
- [ ] Strong password policy
- [ ] Secure session management
- [ ] JWT properly validated
- [ ] Role-based access control
- [ ] Rate limiting implemented

### 3. Data Protection
- [ ] Sensitive data encrypted at rest
- [ ] TLS for data in transit
- [ ] PII properly handled
- [ ] Secrets not in code
- [ ] Logging excludes sensitive data

### 4. Dependencies
- [ ] No known vulnerabilities
- [ ] Dependencies up to date
- [ ] Lock files committed

## Automated Scanning

### Dependency Auditing
```bash
# npm
npm audit
npm audit --production
npm audit fix

# Python
pip-audit
safety check

# Go
go list -json -m all | nancy sleuth

# Ruby
bundle audit check --update
```

### Container Scanning
```bash
# Trivy
trivy image myapp:latest
trivy image --severity HIGH,CRITICAL myapp:latest

# Grype
grype myapp:latest
```

### Static Analysis (SAST)
```bash
# Semgrep
semgrep --config auto .
semgrep --config p/security-audit .
semgrep --config p/owasp-top-ten .

# Bandit (Python)
bandit -r src/

# ESLint Security
npx eslint --ext .js,.ts src/ --plugin security
```

### Secret Detection
```bash
# Gitleaks
gitleaks detect
gitleaks detect --source . --verbose

# truffleHog
trufflehog git file://. --only-verified
```

## OWASP Top 10 Review

### 1. Injection
```python
# BAD: SQL Injection vulnerable
query = f"SELECT * FROM users WHERE id = {user_id}"

# GOOD: Parameterized query
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
```

### 2. Broken Authentication
```python
# BAD: Weak session
session_id = str(random.randint(1, 1000))

# GOOD: Secure session
session_id = secrets.token_urlsafe(32)
```

### 3. Sensitive Data Exposure
```python
# BAD: Logging sensitive data
logger.info(f"User login: {username}, password: {password}")

# GOOD: Redact sensitive data
logger.info(f"User login: {username}")
```

### 4. XML External Entities (XXE)
```python
# BAD: XXE vulnerable
from xml.etree import ElementTree
tree = ElementTree.parse(untrusted_xml)

# GOOD: Disable external entities
from defusedxml import ElementTree
tree = ElementTree.parse(untrusted_xml)
```

### 5. Broken Access Control
```python
# BAD: No authorization check
@app.get("/users/{user_id}")
def get_user(user_id: int):
    return db.get_user(user_id)

# GOOD: Check authorization
@app.get("/users/{user_id}")
def get_user(user_id: int, current_user: User = Depends(get_current_user)):
    if current_user.id != user_id and not current_user.is_admin:
        raise HTTPException(403, "Forbidden")
    return db.get_user(user_id)
```

### 6. Security Misconfiguration
```yaml
# BAD: Debug mode in production
DEBUG=true
ALLOWED_HOSTS=*

# GOOD: Secure configuration
DEBUG=false
ALLOWED_HOSTS=example.com,www.example.com
```

### 7. Cross-Site Scripting (XSS)
```javascript
// BAD: XSS vulnerable
element.innerHTML = userInput;

// GOOD: Sanitize or use textContent
element.textContent = userInput;
// Or use DOMPurify
element.innerHTML = DOMPurify.sanitize(userInput);
```

### 8. Insecure Deserialization
```python
# BAD: Pickle with untrusted data
import pickle
data = pickle.loads(untrusted_data)

# GOOD: Use safe formats
import json
data = json.loads(untrusted_data)
```

### 9. Using Components with Known Vulnerabilities
```bash
# Regular dependency updates
npm update
pip install --upgrade -r requirements.txt

# Monitor for vulnerabilities
npm audit
pip-audit
```

### 10. Insufficient Logging & Monitoring
```python
# GOOD: Log security events
logger.warning(f"Failed login attempt for user: {username}")
logger.info(f"User {user_id} accessed sensitive resource")
logger.error(f"Unauthorized access attempt to {resource}")
```

## Output Format

```markdown
## Security Scan Report

### Summary
- **Risk Level**: [Critical/High/Medium/Low]
- **Issues Found**: X
- **Dependencies Scanned**: Y

### Critical Issues
| ID | Type | Location | Description |
|----|------|----------|-------------|
| 1 | SQL Injection | src/db.py:45 | User input directly in query |

### High Priority
- ...

### Medium Priority
- ...

### Low Priority
- ...

### Recommendations
1. [Specific fix for each issue]
2. ...

### Dependencies with Vulnerabilities
| Package | Version | Vulnerability | Severity | Fix Version |
|---------|---------|---------------|----------|-------------|
| lodash | 4.17.15 | CVE-2021-23337 | High | 4.17.21 |
```
