# AGENTS.md

This file provides guidance to Codex when working with code in this repository.

## Project Overview

This is a **Codex configuration pack** containing production-ready agents, skills, hooks, commands, rules, and MCP templates.

## Running Tests

```bash
# Run all tests
node tests/run-all.js

# Run individual test files
node tests/lib/utils.test.js
node tests/lib/package-manager.test.js
node tests/hooks/hooks.test.js
```

## Architecture

- `agents/` - specialized subagents for delegation (planner, code-reviewer, tdd-guide, etc.)
- `skills/` - workflow definitions and domain knowledge (coding standards, patterns, testing)
- `commands/` - slash-command prompt templates (`/tdd`, `/plan`, `/e2e`, etc.)
- `hooks/` - trigger-based automation scripts (session persistence, pre/post tool hooks)
- `rules/` - always-follow guidelines (security, coding style, testing requirements)
- `mcp-configs/` - MCP server templates for integrations
- `scripts/` - cross-platform Node.js utilities for hooks and setup
- `tests/` - test suite for scripts and utilities

## Key Commands

- `/tdd` - test-driven development workflow
- `/plan` - implementation planning
- `/e2e` - generate and run E2E tests
- `/code-review` - quality review
- `/build-fix` - fix build errors
- `/learn` - extract patterns from sessions
- `/skill-create` - generate skills from git history

## Development Notes

- Package manager detection: npm, pnpm, yarn, bun (configured via `CODEX_PACKAGE_MANAGER`, `.codex/package-manager.json`, or lock files)
- Cross-platform scripts support: Windows, macOS, Linux
- Agent format: Markdown with YAML frontmatter (`name`, `description`, `tools`, `model`)
- Skill format: Markdown with sections for when to use, workflow, and examples
- Hook format: JSON with matcher conditions and command/notification hooks

## Contributing

Follow `CONTRIBUTING.md` formats:

- Agents: Markdown with frontmatter (`name`, `description`, `tools`, `model`)
- Skills: sections (`When to Use`, `How It Works`, `Examples`)
- Commands: Markdown with description frontmatter
- Hooks: JSON with matcher and hooks array

File naming: lowercase with hyphens (for example, `python-reviewer.md`, `tdd-workflow.md`).
