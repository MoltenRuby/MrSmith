#!/usr/bin/env bash
# sync.sh — Copy opencode artefacts from this repo into ~/.config/opencode/
#
# Behaviour: merge — files present in this repo are added/updated in the target.
#            Files already in ~/.config/opencode/ that are NOT in this repo are
#            left untouched.
#
# Usage: ./sync.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_DIR="${HOME}/.config/opencode"

copied=0
skipped=0

log_copied()  { echo "  [copied]  $1"; ((copied++))  || true; }
log_skipped() { echo "  [skip]    $1"; ((skipped++)) || true; }

sync_file() {
    local src="$1"
    local dst="$2"
    local dst_dir
    dst_dir="$(dirname "$dst")"

    mkdir -p "$dst_dir"

    if [[ -f "$dst" ]] && diff -q "$src" "$dst" &>/dev/null; then
        log_skipped "$dst"
    else
        cp "$src" "$dst"
        log_copied "$dst"
    fi
}

# ── Agents ────────────────────────────────────────────────────────────────────
if [[ -d "${REPO_DIR}/agents" ]]; then
    echo ""
    echo "Agents"
    while IFS= read -r -d '' file; do
        rel="${file#"${REPO_DIR}/agents/"}"
        sync_file "$file" "${OPENCODE_DIR}/agents/${rel}"
    done < <(find "${REPO_DIR}/agents" -name "*.md" -print0)
fi

# ── Skills ────────────────────────────────────────────────────────────────────
if [[ -d "${REPO_DIR}/skills" ]]; then
    echo ""
    echo "Skills"
    while IFS= read -r -d '' file; do
        rel="${file#"${REPO_DIR}/skills/"}"
        sync_file "$file" "${OPENCODE_DIR}/skills/${rel}"
    done < <(find "${REPO_DIR}/skills" -name "SKILL.md" -print0)
fi

# ── Commands ──────────────────────────────────────────────────────────────────
if [[ -d "${REPO_DIR}/commands" ]]; then
    echo ""
    echo "Commands"
    while IFS= read -r -d '' file; do
        rel="${file#"${REPO_DIR}/commands/"}"
        sync_file "$file" "${OPENCODE_DIR}/commands/${rel}"
    done < <(find "${REPO_DIR}/commands" -name "*.md" -print0)
fi

# ── Rules (AGENTS.md) ─────────────────────────────────────────────────────────
if [[ -f "${REPO_DIR}/AGENTS.md" ]]; then
    echo ""
    echo "Rules"
    sync_file "${REPO_DIR}/AGENTS.md" "${OPENCODE_DIR}/AGENTS.md"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────────────"
echo "Done. ${copied} file(s) copied, ${skipped} file(s) already up to date."
echo "────────────────────────────────────────"
