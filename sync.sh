#!/usr/bin/env bash
# sync.sh — Deploy artefacts from this repo to OpenCode and VS Code.
#
# OpenCode: copies agents/opencode/, skills/, commands/, AGENTS.md
#           → ~/.config/opencode/
#
# VS Code:  copies agents/vscode/*.agent.md → ~/.copilot/agents/ (global, all workspaces)
#           symlinks skills/<name> → .agents/skills/<name>  (read natively by VS Code)
#
# Behaviour: merge — existing files not tracked here are left untouched.
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

# ── OpenCode Agents (agents/opencode/ → ~/.config/opencode/agents/) ───────────
if [[ -d "${REPO_DIR}/agents/opencode" ]]; then
    echo ""
    echo "OpenCode Agents"
    while IFS= read -r -d '' file; do
        rel="${file#"${REPO_DIR}/agents/opencode/"}"
        sync_file "$file" "${OPENCODE_DIR}/agents/${rel}"
    done < <(find "${REPO_DIR}/agents/opencode" -name "*.md" -print0)
fi

# ── Skills ────────────────────────────────────────────────────────────────────
if [[ -d "${REPO_DIR}/skills" ]]; then
    echo ""
    echo "Skills"
    while IFS= read -r -d '' file; do
        rel="${file#"${REPO_DIR}/skills/"}"
        sync_file "$file" "${OPENCODE_DIR}/skills/${rel}"
    done < <(find "${REPO_DIR}/skills" \( -name "SKILL.md" -o -name "*.sh" \) -print0)
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

# ── VS Code Agents (agents/vscode/ → ~/.copilot/agents/) ─────────────────────
# VS Code Copilot reads user-profile agents from ~/.copilot/agents/ — available
# globally across all workspaces.
# Guard: only copy *.agent.md — never copy plain .md files here.
if [[ -d "${REPO_DIR}/agents/vscode" ]]; then
    echo ""
    echo "VS Code Agents (~/.copilot/agents/)"
    mkdir -p "${HOME}/.copilot/agents"
    while IFS= read -r -d '' file; do
        rel="${file#"${REPO_DIR}/agents/vscode/"}"
        sync_file "$file" "${HOME}/.copilot/agents/${rel}"
    done < <(find "${REPO_DIR}/agents/vscode" -name "*.agent.md" -print0)
fi

# ── VS Code skill symlinks (.agents/skills/) ──────────────────────────────────
# VS Code Copilot reads skills from .agents/skills/<name>/SKILL.md natively.
# We symlink each skills/<name> directory there so skills are shared with zero
# duplication. See doc/agent-coexistence-design.md for rationale.
if [[ -d "${REPO_DIR}/skills" ]]; then
    echo ""
    echo "VS Code skill symlinks (.agents/skills/)"
    VSCODE_SKILLS_DIR="${REPO_DIR}/.agents/skills"
    mkdir -p "$VSCODE_SKILLS_DIR"
    while IFS= read -r -d '' skill_dir; do
        skill_name="$(basename "$skill_dir")"
        link="${VSCODE_SKILLS_DIR}/${skill_name}"
        # Relative target: ../../skills/<name>
        target="../../skills/${skill_name}"
        if [[ -L "$link" ]] && [[ "$(readlink "$link")" == "$target" ]]; then
            log_skipped "$link -> $target"
        else
            ln -sf "$target" "$link"
            log_copied "$link -> $target"
        fi
    done < <(find "${REPO_DIR}/skills" -mindepth 1 -maxdepth 1 -type d -print0)
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────────────"
echo "Done. ${copied} file(s) copied, ${skipped} file(s) already up to date."
echo "────────────────────────────────────────"
