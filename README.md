# scaffold

Opinionated scaffolding for Rust and Go projects.

## Usage

Run the scaffold script from this repository and point it at an existing project directory:

```bash
./scripts/init.sh rust /path/to/project
./scripts/init.sh go /path/to/project
```

The script is idempotent: existing files are skipped, Cargo.toml tables (`[profile.*]`, `[lints.clippy]`) are appended only when the project does not already define them, and shared ignore patterns are appended only when missing. Git worktrees and submodules are supported.

## Templates

- `github/` contains GitHub Actions workflow templates copied into scaffolded projects as `.github/workflows/*`.
- `git/` contains git hook and exclude templates.
- `docker/` contains optional Dockerfile templates.
- `Cargo.toml` contains Rust Cargo profile and lint settings appended to target projects.
- `.golangci.yml` contains the Go linter configuration copied to target projects.
- `go.mod.template` is copied as `go.mod` when the target project has none; it tracks the latest stable Go release.

This repository should not contain `.github/workflows` copies of the Rust project templates; those workflows are meant to run in generated projects, not in the scaffold repository itself.

## Rust Scaffold

The Rust scaffold adds:

- Cargo profile and Clippy lint defaults.
- CI, build, release, and zizmor workflow templates.
- A pre-commit hook template.
- Shared git exclude patterns.

Rust CI/build/release templates use `--locked` so generated projects build against their committed `Cargo.lock`.

## Go Scaffold

The Go scaffold adds:

- `.golangci.yml`.
- `go.mod` pinned to the latest stable Go (only when the project has none).
- Shared git exclude patterns.
