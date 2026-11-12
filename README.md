# scaffold

Opinionated scaffolding for Rust and Go projects.

## Usage

Run the scaffold script from this repository and point it at an existing project directory:

```bash
./scripts/init.sh rust /path/to/project
./scripts/init.sh go /path/to/project
```

The script is idempotent: existing files are skipped, and shared ignore patterns are appended only when missing.

## Templates

- `github/` contains GitHub Actions workflow templates copied into scaffolded projects as `.github/workflows/*`.
- `git/` contains git hook and exclude templates.
- `make/` contains example Makefile templates copied into scaffolded projects as `Makefile`.
- `cargo/` contains a `.cargo/config.toml` template with a dependency cooldown for supply-chain safety.
- `docker/` contains optional Dockerfile templates.
- `Cargo.toml` contains Rust Cargo profile and lint settings appended to target projects.
- `.golangci.yml` contains the Go linter configuration copied to target projects.
- `go.mod.template` is copied as `go.mod` when the target project has none; it tracks the latest stable Go release.

This repository should not contain `.github/workflows` copies of the Rust project templates; those workflows are meant to run in generated projects, not in the scaffold repository itself. The exception is `.github/workflows/lint.yml`, which lints the templates in this repository with yamllint, actionlint, and shellcheck on every push and pull request.

## Rust Scaffold

The Rust scaffold adds:

- Cargo profile and Clippy lint defaults.
- Cargo lint table with unused-dependency detection.
- CI, build, release, and zizmor workflow templates.
- A locked-in supply-chain lint workflow.
- A `.cargo/config.toml` with a dependency cooldown.
- An example `Makefile` wrapping common cargo workflows.
- A pre-commit hook template.
- Shared git exclude patterns.

Rust CI/build/release templates use `--locked` so generated projects build against their committed `Cargo.lock`.

## Go Scaffold

The Go scaffold adds:

- `.golangci.yml`.
- `go.mod` pinned to the latest stable Go (only when the project has none).
- An example `Makefile` wrapping common Go tooling workflows.
- Shared git exclude patterns.
