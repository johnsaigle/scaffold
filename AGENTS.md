# AGENTS.md - OpenCode Project Configuration

## Opencode AGENTS instructions
If the `/init` command was invoked and you arrived here,
use the current file contents. You can only remove
content from this file that is not relevant for the project,
e.g. the Python guidance can be removed if there is no Python code.

## Project Overview
This file contains essential configuration and commands for opencode to work effectively with this codebase. It serves as a reference for automated agents and human developers.

## Security Framework
This project follows ultra-secure coding practices with bounded resource management and explicit validation at all boundaries.

### Core Security Constraints
- **Function Limits**: Max 60 lines per function, cyclomatic complexity ≤10, max 3 levels of nesting
- **Resource Bounds**: Pre-allocated collections with fixed capacity, explicit bounds on all operations
- **Banned Patterns**: Unbounded recursion, global mutable state, unbounded loops, dynamic dispatch in hot paths
- **Input Validation**: Multi-layer validation (type → format → business → security)

## Build & Development Commands

### Go Projects
```bash
# Lint and security check
golangci-lint run

# Build
go build ./...

# Test with coverage
go test -v -race -coverprofile=coverage.out ./...

# Security scan
gosec ./...

# Dependency check
go mod verify && go mod tidy
```

### Node.js/TypeScript Projects
```bash
# Install dependencies
npm ci

# Lint
npm run lint

# Type check
npm run typecheck

# Test
npm test

# Build
npm run build

# Security audit
npm audit --audit-level=moderate
```

### Python Projects
```bash
# Install dependencies
pip install -r requirements.txt

# Lint and format
ruff check . && ruff format .

# Type check
mypy .

# Test
pytest --cov=. --cov-report=term-missing

# Security scan
bandit -r .
```

### Rust Projects
```bash
# Check
cargo check

# Lint
cargo clippy -- -D warnings

# Test
cargo test

# Build
cargo build --release

# Security audit
cargo audit
```

## Code Quality Standards

### Mandatory Patterns
1. **Error Handling**: All functions must handle errors explicitly
2. **Input Validation**: Validate all inputs at function boundaries
3. **Resource Management**: Explicit bounds on all collections and operations
4. **Type Safety**: Use strong typing with semantic meaning

### Security Requirements
- Never hardcode secrets, tokens, passwords, or API keys
- Use parameterized queries for database operations
- Sanitize and validate all user inputs
- Implement proper authentication and authorization
- Use HTTPS for all external communications

### Code Structure Template
```
function functionName(params: ExplicitTypes): ReturnType {
    // Parameter validation with early return
    validateInputs(params) || return Error("Invalid parameters")
    
    // Local variables with explicit initialization
    let result: ResultType = defaultValue
    let counter: int = 0
    
    // Core logic with bounds checking
    for item in collection.take(FIXED_UPPER_BOUND) {
        validateInvariant(counter < MAX_ITERATIONS)
        // processing with explicit bounds
        counter += 1
    }
    
    // Postcondition verification
    validateOutput(result) || return Error("Invalid result state")
    return Success(result)
}
```

## Testing Requirements

### Test Categories
1. **Unit Tests**: Test individual functions with boundary conditions
2. **Integration Tests**: Test component interactions
3. **Property-Based Tests**: Verify invariants hold for all valid inputs
4. **Security Tests**: Test input validation and error handling

### Test Commands by Language
```bash
# Go
go test -v -race ./...

# Node.js
npm test

# Python
pytest -v --cov=.

# Rust
cargo test
```

## Dependency Management

### Approved Dependencies
- Prefer standard library implementations
- Use well-maintained, security-audited packages
- Avoid packages with known vulnerabilities

### Dependency Commands
```bash
# Go
go mod tidy && go mod verify

# Node.js
npm audit fix

# Python
pip-audit

# Rust
cargo audit
```

## Pre-commit Hooks

### Required Checks
- [ ] Linting passes
- [ ] Type checking passes
- [ ] Tests pass
- [ ] Security scans pass
- [ ] No hardcoded secrets
- [ ] Documentation updated

## Environment Configuration

### Required Environment Variables
```bash
# Development
NODE_ENV=development
LOG_LEVEL=debug

# Production
NODE_ENV=production
LOG_LEVEL=info
```

### Secret Management
- Use environment variables for secrets
- Never commit secrets to version control
- Use secret management services in production

## Documentation Standards

### Code Documentation
- Document all public APIs
- Include security considerations
- Provide usage examples
- Document error conditions

### Security Documentation
- Document threat model
- Include security assumptions
- Document validation rules
- Include incident response procedures

## Monitoring & Observability

### Logging Standards
- Use structured logging (JSON)
- Include correlation IDs
- Log security events
- Never log sensitive data

### Metrics
- Track resource usage
- Monitor error rates
- Track security events
- Monitor performance

## Deployment

### Security Checklist
- [ ] All secrets in environment variables
- [ ] HTTPS enabled
- [ ] Security headers configured
- [ ] Input validation enabled
- [ ] Rate limiting configured
- [ ] Monitoring enabled

### Deployment Commands
```bash
# Build for production
npm run build:prod

# Deploy (example)
docker build -t app:latest .
docker run -p 3000:3000 app:latest
```

## Emergency Procedures

### Security Incident Response
1. **Immediate containment**: Disable affected components
2. **Safe mode fallback**: Minimal functionality continues
3. **Clear error reporting**: Machine-readable error codes
4. **Recovery procedures**: Automated restart with clean state

### Rollback Procedures
```bash
# Git rollback
git revert <commit-hash>

# Container rollback
docker rollback <service-name>
```

## Agent Instructions

### For OpenCode Agents
1. Always run linting and type checking before committing
2. Validate all inputs at function boundaries
3. Use explicit error handling patterns
4. Implement resource bounds on all operations
5. Follow the security constraints defined above
6. Run tests after making changes
7. Update documentation when changing APIs

### Code Review Checklist
- [ ] All functions ≤60 lines
- [ ] All error conditions handled explicitly
- [ ] All collections have explicit size bounds
- [ ] All loops have fixed termination conditions
- [ ] All inputs validated at function entry
- [ ] All outputs validated before return
- [ ] All resources explicitly managed
- [ ] All invariants documented and enforced

## Project-Specific Notes

### Architecture Decisions
- Security-first design with explicit bounds
- Fail-fast error handling
- Immutable data structures where possible
- Explicit resource management

### Performance Considerations
- Batch operations for efficiency
- Cache-friendly access patterns
- Pre-allocated collections
- Bounded resource usage

---

**Remember**: Security is language-agnostic. Predictable, bounded, validated code prevents vulnerabilities regardless of syntax. Choose explicit over implicit, bounded over unbounded, validated over assumed. Boring code saves lives. Clever code kills systems.
