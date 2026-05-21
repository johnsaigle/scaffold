# AGENTS.md - Agent Guidelines for Scaffold Repository

This repository provides opinionated scaffolding for Rust and Go projects.

## Repository Structure

```
/home/psychopomp/coding/scaffold/
├── scripts/init.sh          # Main scaffold script (entry point)
├── Cargo.toml               # Rust project template
├── .golangci.yml           # Go linter configuration template
├── github/rust-ci.yml      # GitHub Actions CI template for Rust
├── github/rust-build.yml   # GitHub Actions build template for Rust
├── github/rust-zizmor.yml  # GitHub Actions zizmor audit template for Rust
├── git/pre-commit-rust     # Pre-commit hook for Rust projects
└── git/exclude             # Git exclude patterns
```

## Build / Lint / Test Commands

### For This Repository (Scaffold Tool)

This repo contains bash scripts and config templates only - no build step required.

```bash
# Validate scripts
shellcheck scripts/init.sh

# Test init script (dry run)
bash scripts/init.sh rust /tmp/test-rust
bash scripts/init.sh go /tmp/test-go
```

### For Scaffolded Rust Projects

```bash
# Build
cargo build
cargo build --release

# Test
cargo test
cargo test <test_name>           # Run single test
cargo test <module>::<test>      # Run specific module test
cargo test --verbose

# Lint
cargo clippy
cargo clippy -- -D warnings      # Treat warnings as errors

# Format
cargo fmt
cargo fmt -- --check             # Check formatting without writing

# Security audit (requires zizmor)
zizmor .
```

### For Scaffolded Go Projects

```bash
# Build
go build ./...
go build -o <binary> ./cmd/<main>

# Test
go test ./...
go test -v ./...                 # Verbose output
go test -run <TestName> ./...    # Run single test
go test -race ./...              # Race detector

# Lint (requires golangci-lint)
golangci-lint run
golangci-lint run --fix          # Auto-fix issues

# Format
gofmt -w .
go fmt ./...
```

## Code Style Guidelines

### Rust Projects

**Profiles (from Cargo.toml):**
- Debug: `overflow-checks = true`, `lto = "fat"`
- Release: `overflow-checks = true`, `lto = "fat"`, `opt-level = 3`
- Always strip debuginfo in release

**Clippy Lints (all enabled as warn):**
- `complexity`, `correctness`, `nursery`, `pedantic`, `perf`, `suspicious`
- Run clippy before commits: `cargo clippy -- -D warnings`

**Formatting:**
- Use `cargo fmt` with default settings
- Never check in unformatted code

### Go Projects

**Linting Rules (.golangci.yml):**
- All enabled linters: bidichk, bodyclose, contextcheck, depguard, dupword, errcheck, errorlint, exhaustive, exhaustruct, forbidigo, forcetypeassert, gocritic, gosec, govet, ineffassign, loggercheck, misspell, mnd, noctx, nolintlint, prealloc, predeclared, staticcheck, unparam, unused

**Key Rules:**
- No `io.ReadAll` - use `io.LimitReader` or streaming
- No `github.com/pkg/errors` - use standard `errors` package
- No `github.com/davecgh/go-spew/spew` - use JSON formatting
- Require explanations for all `//nolint` comments
- Check exported functions with unparam

**Formatting:**
- Use `gofmt` or `go fmt`
- No line length limits enforced

## Import Guidelines

### Rust
- Group imports: std, external crates, local modules
- Use `use crate::` for local modules
- Prefer explicit imports over glob imports

### Go
- Group imports: stdlib, third-party, local
- Use `goimports` for automatic import management
- No blank imports except for side-effect packages (e.g., `_ "image/png"`)

## Naming Conventions

### Rust
- `snake_case` for functions, variables, modules
- `CamelCase` for types, traits, enums
- `SCREAMING_SNAKE_CASE` for constants
- `PascalCase` for enum variants

### Go
- `camelCase` for unexported identifiers
- `PascalCase` for exported identifiers
- `snake_case` for file names
- Avoid stuttering: `http.HTTPClient` → `http.Client`

## Error Handling

### Rust
- Use `Result<T, E>` for recoverable errors
- Use `thiserror` for error types, `anyhow` for applications
- Never unwrap/expect in production code without comments
- Use `?` operator for error propagation

### Go
- Always check errors: `if err != nil { return err }`
- Wrap errors with context: `fmt.Errorf("doing thing: %w", err)`
- Never use `panic` in library code
- Use sentinel errors for specific error types

## Git Workflow

### Pre-commit Hooks
Install hooks when scaffolding:
```bash
# Rust projects get pre-commit hook that runs:
cargo clippy
cargo t
zizmor .
```

### CI/CD (GitHub Actions)
Scaffolded Rust projects include:
- `ci.yml`: test (`cargo test --verbose`) and clippy (`cargo clippy -- -D warnings`)
- `build.yml`: `cargo build --release` + artifact upload
- `zizmor.yml`: CI security audit with zizmor

## Security

- Pin all GitHub Actions to SHA commits (not tags)
- Use `permissions: {}` at workflow level, grant minimal per-job
- Run `zizmor` to audit CI security
- Never persist credentials unnecessarily

## Testing Guidelines

### Rust
- Place unit tests in `src/` files: `#[cfg(test)] mod tests { ... }`
- Place integration tests in `tests/` directory
- Use `cargo test <name>` to run single tests
- Use `cargo test -- --nocapture` to see println! output

### Go
- Test files: `*_test.go`
- Table-driven tests preferred
- Use `t.Parallel()` for parallel test execution
- Benchmarks: `func BenchmarkXxx(b *testing.B)`

## Using the Scaffold Tool

```bash
# From repo root
./scripts/init.sh rust [destination]     # Scaffold Rust project
./scripts/init.sh go [destination]       # Scaffold Go project

# Examples
./scripts/init.sh rust ./my-rust-app
./scripts/init.sh go ./my-go-service
```

The script is idempotent - safe to run multiple times.
