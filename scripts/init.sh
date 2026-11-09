#!/usr/bin/env bash
set -euo pipefail

# Resolve the scaffold repo root regardless of where this script is called from.
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
SCAFFOLD_ROOT="$(dirname "$SCRIPT_DIR")"

usage() {
  cat <<EOF
Usage: $(basename "$0") <project-type> [destination]

Scaffold a project with opinionated config files.

Arguments:
  project-type   One of: rust, go
  destination    Target directory (default: current directory)

Examples:
  $(basename "$0") rust
  $(basename "$0") go ./my-project
EOF
  exit 1
}

# --- helpers ---------------------------------------------------------------

# Copy a file, creating parent directories as needed.
# Usage: copy_file <src_relative_to_scaffold_root> <dst_relative_to_dest>
copy_file() {
  local src="$SCAFFOLD_ROOT/$1"
  local dst="$DEST/$2"

  if [[ ! -f "$src" ]]; then
    echo "  WARN: source file not found: $src"
    return
  fi

  mkdir -p "$(dirname "$dst")"

  if [[ -f "$dst" ]]; then
    echo "  SKIP (exists): $2"
  else
    cp "$src" "$dst"
    echo "  COPY: $2"
  fi
}

# Append unique lines from a source file into a destination file.
# Skips lines that already exist in the destination.
# Usage: append_file <src_relative_to_scaffold_root> <dst_relative_to_dest>
append_file() {
  local src="$SCAFFOLD_ROOT/$1"
  local dst="$2"
  [[ "$dst" = /* ]] || dst="$DEST/$dst"

  if [[ ! -f "$src" ]]; then
    echo "  WARN: source file not found: $src"
    return
  fi

  mkdir -p "$(dirname "$dst")"
  touch "$dst"

  local added=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments for matching purposes
    if [[ -z "$line" || "$line" =~ ^# ]]; then
      continue
    fi
    if ! grep -qF -- "$line" "$dst" 2>/dev/null; then
      echo "$line" >> "$dst"
      added=$((added + 1))
    fi
  done < "$src"

  if ((added > 0)); then
    echo "  APPEND ($added lines): $2"
  else
    echo "  SKIP (already present): $2"
  fi
}

# Append a TOML file's tables to a destination TOML file, skipping any table
# the destination already defines (TOML forbids duplicate tables, so blindly
# appending would break an existing Cargo.toml). Skipped tables are reported
# so they can be merged by hand.
# Usage: append_toml_tables <src_relative_to_scaffold_root> <dst_relative_to_dest>
append_toml_tables() {
  local src="$SCAFFOLD_ROOT/$1"
  local dst="$DEST/$2"

  if [[ ! -f "$src" ]]; then
    echo "  WARN: source file not found: $src"
    return
  fi

  if [[ ! -f "$dst" ]]; then
    echo "  WARN: destination file not found: $2 (run cargo init first?)"
    return
  fi

  local header="" chunk="" added=0 skipped=()
  flush() {
    [[ -z "$header" ]] && return
    if grep -qxF -- "$header" "$dst"; then
      skipped+=("$header")
    else
      printf '\n%s' "$chunk" >> "$dst"
      added=$((added + 1))
    fi
  }
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^\[[^]]+\]$ ]]; then
      flush
      header="$line"
      chunk="$line"$'\n'
    elif [[ -n "$header" ]]; then
      chunk+="$line"$'\n'
    fi
  done < "$src"
  flush

  if ((added > 0)); then
    echo "  APPEND ($added tables): $2"
  fi
  for h in "${skipped[@]}"; do
    echo "  SKIP (table already defined; diff against scaffold's $1 if needed): $2 $h"
  done
}

# Resolve a path inside the destination's git directory. Works for worktrees
# and submodules, where .git is a file rather than a directory.
# Usage: git_path <path-relative-to-git-dir>
git_path() {
  git -C "$DEST" rev-parse --path-format=absolute --git-path "$1" 2>/dev/null
}

is_git_repo() {
  git -C "$DEST" rev-parse --git-dir >/dev/null 2>&1
}

# Install a git pre-commit hook. Appends to existing hook if present.
install_hook() {
  local src="$SCAFFOLD_ROOT/$1"

  if ! is_git_repo; then
    echo "  SKIP (not a git repo): pre-commit hook"
    return
  fi

  local hook_dir
  hook_dir="$(git_path hooks)"
  local hook_file="$hook_dir/pre-commit"

  if [[ ! -f "$src" ]]; then
    echo "  WARN: hook source not found: $src"
    return
  fi

  mkdir -p "$hook_dir"

  if [[ -f "$hook_file" ]]; then
    # Append hook contents if not already present (skip shebang from source)
    local body
    body="$(tail -n +2 "$src")"
    if grep -qF -- "$(echo "$body" | head -1)" "$hook_file" 2>/dev/null; then
      echo "  SKIP (already installed): pre-commit hook"
    else
      echo "" >> "$hook_file"
      echo "$body" >> "$hook_file"
      echo "  APPEND: pre-commit hook"
    fi
  else
    cp "$src" "$hook_file"
    chmod +x "$hook_file"
    echo "  INSTALL: pre-commit hook"
  fi
}

append_git_exclude() {
  if is_git_repo; then
    append_file "git/exclude" "$(git_path info/exclude)"
  else
    echo "  SKIP (not a git repo): git exclude"
  fi
}

# --- project types ---------------------------------------------------------

setup_rust() {
  echo "Setting up Rust project in $DEST ..."
  append_toml_tables "Cargo.toml" "Cargo.toml"
  copy_file "github/rust-ci.yml" ".github/workflows/ci.yml"
  copy_file "github/rust-build.yml" ".github/workflows/build.yml"
  copy_file "github/zizmor-ci.yml" ".github/workflows/zizmor-ci.yml"
  copy_file "github/rust-release.yml" ".github/workflows/release.yml"
  install_hook "git/pre-commit-rust"
  append_git_exclude
  echo "Done."
}

setup_go() {
  echo "Setting up Go project in $DEST ..."

  copy_file ".golangci.yml" ".golangci.yml"

  # Only when the project has no go.mod yet; an existing file is never touched.
  copy_file "go.mod.template" "go.mod"
  copy_file "github/go-ci.yml" ".github/workflows/ci.yml"
  copy_file "github/go-build.yml" ".github/workflows/build.yml"
  copy_file "github/zizmor-ci.yml" ".github/workflows/zizmor-ci.yml"
  copy_file "github/go-release.yml" ".github/workflows/release.yml"
  append_git_exclude
  echo "Done."
}

# --- main ------------------------------------------------------------------

if [[ $# -lt 1 ]]; then
  usage
fi

PROJECT_TYPE="$1"
DEST="${2:-.}"

# Resolve destination to absolute path
DEST="$(realpath "$DEST")"

if [[ ! -d "$DEST" ]]; then
  echo "Error: destination directory does not exist: $DEST"
  exit 1
fi

echo "Scaffold root: $SCAFFOLD_ROOT"
echo "Destination:   $DEST"
echo ""

case "$PROJECT_TYPE" in
  rust)
    setup_rust
    ;;
  go)
    setup_go
    ;;
  *)
    echo "Error: unknown project type '$PROJECT_TYPE'"
    echo "Supported types: rust, go"
    exit 1
    ;;
esac
