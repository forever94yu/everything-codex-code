# Everything Codex Code

Codex-first configuration pack converted from `everything-claude-code`.

Includes:

- Reusable `agents/`
- Practical `skills/`
- Command templates in `commands/`
- Automation scripts in `hooks/` and `scripts/hooks/`
- Engineering rule sets in `rules/`
- MCP server templates in `mcp-configs/`

## Quick Start

```bash
git clone <your-repo-url> everything-codex-code
cd everything-codex-code
./install.sh typescript
```

Common options:

```bash
# Multi-language install
./install.sh typescript python golang

# Explicit Codex target (same behavior)
./install.sh --target codex typescript
```

## Install Locations

- Rules: `${CODEX_RULES_DIR:-${CODEX_HOME:-~/.codex}/rules}`
- Skills: `${CODEX_SKILLS_DIR:-${CODEX_HOME:-~/.codex}/skills}`
- Full reference bundle: `${CODEX_BUNDLE_DIR:-${CODEX_HOME:-~/.codex}/everything-codex-code}`

## Codex Config

- Project instructions: `AGENTS.md`
- Package manager preference: `.codex/package-manager.json`
- Environment variable override: `CODEX_PACKAGE_MANAGER`

## Development

```bash
npm install
npm test
```

## Notes

- This fork is **Codex-only**.
- Claude plugin compatibility was intentionally removed.
