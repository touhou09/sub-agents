---
name: deploy-check
description: |
  This skill should be used when the user asks to "check deployment readiness",
  "pre-deploy validation", "deployment checklist", "release validation",
  or before deploying to production environments.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(npm:*)
  - Bash(pytest:*)
  - Bash(docker:*)
  - Bash(kubectl:*)
  - Bash(terraform:*)
  - Bash(git:*)
---

# Deploy Check Skill

Systematic deployment readiness validation.

## Pre-Deployment Checklist

### 1. Code Quality
- [ ] All tests passing
- [ ] No linting errors
- [ ] Type checks pass
- [ ] Code review approved
- [ ] No TODO/FIXME in critical paths

### 2. Configuration
- [ ] Environment variables documented
- [ ] Secrets properly managed (not in code)
- [ ] Feature flags configured
- [ ] Database migrations ready

### 3. Infrastructure
- [ ] Resources scaled appropriately
- [ ] Health checks configured
- [ ] Load balancer settings verified
- [ ] DNS/routing configured

### 4. Monitoring
- [ ] Logging enabled
- [ ] Error tracking configured (Sentry)
- [ ] Metrics collection active (Datadog)
- [ ] Alerts configured

### 5. Rollback Plan
- [ ] Previous version tagged
- [ ] Rollback procedure documented
- [ ] Database rollback scripts ready
- [ ] Feature flag killswitch available

## Validation Commands

### Run Tests
```bash
# JavaScript/TypeScript
npm test
npm run test:coverage

# Python
pytest --cov=src tests/
python -m pytest -v

# Go
go test ./...
```

### Check Build
```bash
# JavaScript/TypeScript
npm run build
npm run type-check

# Python
python -m build
python -m mypy src/

# Docker
docker build -t app:test .
docker run --rm app:test health-check
```

### Infrastructure Validation
```bash
# Kubernetes dry-run
kubectl apply --dry-run=client -f manifests/

# Terraform plan
terraform plan

# Docker Compose validation
docker-compose config
```

### Security Checks
```bash
# npm audit
npm audit --production

# Python dependencies
pip-audit

# Container scan
trivy image myapp:latest

# Secret detection
gitleaks detect
```

## Post-Deployment Verification

### 1. Smoke Tests
Run critical path tests against production:
```bash
# Health check
curl -f https://api.example.com/health

# Basic functionality
npm run test:smoke -- --env=production
```

### 2. Health Checks
Verify all endpoints respond:
```bash
# Kubernetes pods
kubectl get pods -l app=myapp

# Check readiness
kubectl describe deployment myapp
```

### 3. Logs
Check for errors in first 5 minutes:
```bash
# Kubernetes logs
kubectl logs -l app=myapp --since=5m

# Docker logs
docker logs --since=5m container_name
```

### 4. Metrics
Verify baseline metrics stable:
- Response time within SLA
- Error rate below threshold
- CPU/Memory within limits

### 5. User Impact
Monitor:
- Error rates and types
- Latency percentiles (p50, p95, p99)
- User-facing error pages

## Deployment Stages

```
1. Build & Test    -> CI passes
2. Staging Deploy  -> Smoke tests pass
3. Canary Deploy   -> 5% traffic, monitor
4. Gradual Rollout -> 25% -> 50% -> 100%
5. Post-Deploy     -> Full monitoring
```

## Rollback Procedure

```bash
# Kubernetes
kubectl rollout undo deployment/myapp

# Docker Compose
docker-compose pull previous-tag
docker-compose up -d

# Feature flag
# Disable flag in feature flag service

# Database
# Run rollback migration (if safe)
```

## Output Format

```markdown
## Deployment Readiness Report

### Status: [READY / NOT READY / WARNINGS]

### Checks Passed
- [x] Tests passing (coverage: 85%)
- [x] Build successful
- [x] No security vulnerabilities
- [x] Health checks configured

### Checks Failed
- [ ] Missing environment variable: API_KEY
- [ ] Database migration not tested

### Warnings
- npm audit found 2 low severity issues
- Test coverage below 90% threshold

### Recommendations
1. Set API_KEY in production secrets
2. Run migration in staging first
```
