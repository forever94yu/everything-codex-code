#!/usr/bin/env bash
# install.sh - Install everything-codex-code assets into Codex directories.
#
# Usage:
#   ./install.sh [--target codex] <language> [<language> ...]
#
# Examples:
#   ./install.sh typescript
#   ./install.sh typescript python golang
#
# Installs:
#   - Rules into:  ${CODEX_RULES_DIR:-${CODEX_HOME:-$HOME/.codex}/rules}
#   - Skills into: ${CODEX_SKILLS_DIR:-${CODEX_HOME:-$HOME/.codex}/skills}
#   - Bundle into: ${CODEX_BUNDLE_DIR:-${CODEX_HOME:-$HOME/.codex}/everything-codex-code}
#
# NOTE: This installer is Codex-only by design.

set -euo pipefail

# Resolve symlinks (needed when invoked via npm/bun bin symlink)
SCRIPT_PATH="$0"
while [ -L "$SCRIPT_PATH" ]; do
    link_dir="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
    SCRIPT_PATH="$(readlink "$SCRIPT_PATH")"
    [[ "$SCRIPT_PATH" != /* ]] && SCRIPT_PATH="$link_dir/$SCRIPT_PATH"
done
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
RULES_DIR="$SCRIPT_DIR/rules"

# Optional --target codex (accepted for compatibility with previous CLI style)
if [[ "${1:-}" == "--target" ]]; then
    if [[ "${2:-}" != "codex" ]]; then
        echo "Error: only --target codex is supported." >&2
        exit 1
    fi
    shift 2
fi

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 [--target codex] <language> [<language> ...]"
    echo ""
    echo "Available languages:"
    for dir in "$RULES_DIR"/*/; do
        name="$(basename "$dir")"
        [[ "$name" == "common" ]] && continue
        echo "  - $name"
    done
    exit 1
fi

CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
RULES_DEST_DIR="${CODEX_RULES_DIR:-$CODEX_HOME_DIR/rules}"
SKILLS_DEST_DIR="${CODEX_SKILLS_DIR:-$CODEX_HOME_DIR/skills}"
BUNDLE_DEST_DIR="${CODEX_BUNDLE_DIR:-$CODEX_HOME_DIR/everything-codex-code}"

if [[ -d "$RULES_DEST_DIR" ]] && [[ "$(ls -A "$RULES_DEST_DIR" 2>/dev/null)" ]]; then
    echo "Note: $RULES_DEST_DIR already exists. Existing files may be overwritten."
fi

# Install common rules
echo "Installing common rules -> $RULES_DEST_DIR/common/"
mkdir -p "$RULES_DEST_DIR/common"
cp -r "$RULES_DIR/common/." "$RULES_DEST_DIR/common/"

# Install language-specific rules
for lang in "$@"; do
    if [[ ! "$lang" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "Error: invalid language name '$lang'. Only alphanumeric, dash, and underscore allowed." >&2
        continue
    fi

    lang_dir="$RULES_DIR/$lang"
    if [[ ! -d "$lang_dir" ]]; then
        echo "Warning: rules/$lang/ does not exist, skipping." >&2
        continue
    fi

    echo "Installing $lang rules -> $RULES_DEST_DIR/$lang/"
    mkdir -p "$RULES_DEST_DIR/$lang"
    cp -r "$lang_dir/." "$RULES_DEST_DIR/$lang/"
done

# Install skills
if [[ -d "$SCRIPT_DIR/skills" ]]; then
    echo "Installing skills -> $SKILLS_DEST_DIR/"
    mkdir -p "$SKILLS_DEST_DIR"
    cp -r "$SCRIPT_DIR/skills/." "$SKILLS_DEST_DIR/"
fi

# Install a local reference bundle (agents, commands, hooks, templates)
echo "Installing reference bundle -> $BUNDLE_DEST_DIR/"
mkdir -p "$BUNDLE_DEST_DIR"
for dir in agents commands contexts hooks mcp-configs rules examples schemas; do
    if [[ -d "$SCRIPT_DIR/$dir" ]]; then
        mkdir -p "$BUNDLE_DEST_DIR/$dir"
        cp -r "$SCRIPT_DIR/$dir/." "$BUNDLE_DEST_DIR/$dir/"
    fi
done
if [[ -f "$SCRIPT_DIR/AGENTS.md" ]]; then
    cp "$SCRIPT_DIR/AGENTS.md" "$BUNDLE_DEST_DIR/AGENTS.md"
fi

echo "Done. Codex assets installed to $CODEX_HOME_DIR/"
