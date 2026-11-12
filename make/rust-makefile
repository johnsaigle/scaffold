# Example Makefile for a Rust project.
# Phony targets wrapping common cargo workflows.

CARGO ?= cargo

.PHONY: help build build-release test fmt fmt-check clippy audit clean

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-14s %s\n", $$1, $$2}'

build: ## Build in debug mode
	$(CARGO) build

build-release: ## Build in release mode
	$(CARGO) build --release

test: ## Run all tests
	$(CARGO) test

fmt: ## Format all code
	$(CARGO) fmt

fmt-check: ## Check formatting without writing
	$(CARGO) fmt -- --check

clippy: ## Lint with clippy (warnings are errors)
	$(CARGO) clippy -- -D warnings

audit: ## Check dependencies for known vulnerabilities
	$(CARGO) audit

clean: ## Remove build artifacts
	$(CARGO) clean
