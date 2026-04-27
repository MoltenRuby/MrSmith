# VS Code Copilot — Agents Overview

Source: https://code.visualstudio.com/docs/copilot/agents/overview
Fetched: 2026-04-27 (MrSmith-ayt supplement)

## Agent types (where they run)

| Type | Where | How |
|---|---|---|
| **Local** | Your machine, VS Code editor loop | Interactive, full workspace access |
| **Copilot CLI** | Your machine, background | Autonomous, Git worktrees for isolation |
| **Cloud** | GitHub remote | Autonomous, integrates with PRs |
| **Third-party** | Anthropic / OpenAI harness | Local or cloud |

## Built-in local agents

| Agent | Role |
|---|---|
| **Agent** | Default — plans and implements changes, runs terminal commands, invokes tools |
| **Plan** | Creates structured implementation plan; hands off to Agent when approved |
| **Ask** | Answers questions without making file changes |

## Permission levels (per session)

| Level | Behaviour |
|---|---|
| **Default Approvals** | Uses VS Code settings; read-only/safe tools auto-approved |
| **Bypass Approvals** | Auto-approves all tool calls; may still ask clarifying questions |
| **Autopilot** (Preview) | Auto-approves all tool calls AND auto-responds to questions; fully autonomous |

Persist preference: `chat.permissions.default`

## Agent handoffs

You can hand off a session from one agent type to another (e.g. local → Copilot CLI → cloud).
VS Code carries over full conversation history and context. Original session is archived.

In Copilot CLI: `/delegate` command hands off to cloud agent.

## Key setting

`chat.agent.enabled` — must be `true` to use agents (may be org-managed).
