# VS Code Copilot Customization Overview

Source: https://code.visualstudio.com/docs/copilot/copilot-customization
Fetched: 2026-04-27 (MrSmith-ayt)

## Customization types

| Type | Purpose | Location |
|---|---|---|
| Always-on instructions | Project-wide rules injected into every request | `.github/copilot-instructions.md`, `AGENTS.md`, `CLAUDE.md` |
| File-based instructions | Rules targeting specific file types or folders | `.github/instructions/*.instructions.md` |
| Prompt files | Repeatable task templates, runnable via `/command` | `.github/prompts/*.prompt.md` |
| Custom agents | Specialized personas with tool restrictions and model preferences | `.github/agents/*.agent.md`, `.claude/agents/*.md` |
| Agent skills | Reusable capabilities with scripts and resources | `.github/skills/`, `.claude/skills/`, `.agents/skills/` |
| MCP servers | External tools and data sources | `opencode.json` / VS Code settings |
| Hooks | Shell commands at lifecycle points | Hook config files |
| Agent plugins (preview) | Pre-packaged bundles of customizations | Plugin marketplace |

## Get started (incremental)

1. `/init` in chat → generates `.github/copilot-instructions.md`
2. Add `*.instructions.md` for specific file types
3. Create prompt files for common workflows
4. Build custom agents for specialized roles
5. Package reusable capabilities as agent skills

## Parent repository discovery

Setting: `chat.useCustomizationsInParentRepositories`

When enabled, VS Code walks up from the workspace folder to the `.git` root and collects
customizations from all folders in between. Applies to all customization types.

## Always-on instructions — file precedence

VS Code reads these files (first match wins per category):

1. `AGENTS.md` (project root) — recognized by **both OpenCode and VS Code**
2. `CLAUDE.md` (project root) — Claude Code compatibility fallback
3. `.github/copilot-instructions.md` — VS Code-specific always-on instructions
4. `~/.copilot/instructions.md` — user-level always-on instructions
