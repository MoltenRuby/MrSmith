# VS Code Copilot — Custom Agents

Source: https://code.visualstudio.com/docs/copilot/customization/custom-agents
Fetched: 2026-04-27 (MrSmith-ayt)

## What are custom agents?

Custom agents are `.agent.md` Markdown files that define a specialized AI persona with its own
instructions, tool restrictions, model preferences, and optional handoffs between agents.

## File locations

| Scope | Default location |
|---|---|
| Workspace | `.github/agents/*.agent.md` |
| Workspace (Claude format) | `.claude/agents/*.md` |
| User profile | `~/.copilot/agents/` |

> **Note**: VS Code also detects any `.md` files in `.github/agents/` as custom agents (not just
> `.agent.md`). And `.md` files in `.claude/agents/` follow the Claude sub-agents format.

Additional locations configurable via: `chat.agentFilesLocations`

## Frontmatter fields (VS Code `.agent.md` format)

```yaml
---
description: Brief description shown as placeholder in chat input
name: Agent Name                    # optional; file name used if omitted
argument-hint: "[optional hint]"    # optional hint text in chat input
tools: ['search', 'edit', 'web']    # list of allowed tools
agents: ['Researcher', 'Implementer'] # allowed subagents; '*' = all; [] = none
model: 'Claude Sonnet 4.5 (copilot)' # or array for fallback list
user-invocable: true                # show in agents dropdown (default true)
disable-model-invocation: false     # prevent auto-invocation as subagent
handoffs:
  - label: Start Implementation
    agent: implementation
    prompt: Now implement the plan outlined above.
    send: false
    model: GPT-5.2 (copilot)
---
```

## Frontmatter fields (Claude `.claude/agents/` format)

```yaml
---
name: Agent Name          # required
description: What it does
tools: "Read, Grep, Glob, Bash"   # comma-separated string
disallowedTools: "Bash"           # comma-separated string
---
```

VS Code maps Claude tool names to VS Code tools automatically.

## Key differences from OpenCode agents

| Aspect | OpenCode (`agents/*.md`) | VS Code (`.github/agents/*.agent.md`) |
|---|---|---|
| File extension | `.md` | `.agent.md` (or `.md` in `.github/agents/`) |
| `tools` format | `tools: { write: false }` (map) | `tools: ['edit', 'search']` (array of strings) |
| `mode` field | `primary` / `subagent` / `all` | `user-invocable` + `disable-model-invocation` |
| `permission` field | Bash glob patterns | Not supported |
| `temperature` | Supported | Not supported |
| `model` format | `provider/model-id` | `Model Name (vendor)` |
| Handoffs | Not supported | Supported |

## Handoffs

Handoff buttons appear after a chat response. Each handoff specifies:
- `label` — button text
- `agent` — target agent identifier
- `prompt` — pre-filled prompt for the target agent
- `send: false` — do not auto-submit (default)
- `model` — optional model override for the handoff

## Tool names (VS Code)

Built-in tools include: `search/codebase`, `search/usages`, `web/fetch`, `edit`, `read`,
`read/terminalLastCommand`, `agent` (for subagent invocation).

MCP tools: `<server name>/*` to include all tools from an MCP server.
