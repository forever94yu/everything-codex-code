# Everything Codex Code（中文）

这是从 `everything-claude-code` 改造出的 **Codex 专用版本**。

主要内容：

- `agents/`：可复用的子代理模板
- `skills/`：结构化技能库
- `commands/`：命令/流程提示模板
- `hooks/` 与 `scripts/hooks/`：自动化钩子脚本
- `rules/`：工程规范（通用 + 多语言）
- `mcp-configs/`：MCP 配置模板

## 快速开始

```bash
git clone <你的仓库地址> everything-codex-code
cd everything-codex-code
./install.sh typescript
```

多语言安装：

```bash
./install.sh typescript python golang
```

## 安装路径

- Rules：`${CODEX_RULES_DIR:-${CODEX_HOME:-~/.codex}/rules}`
- Skills：`${CODEX_SKILLS_DIR:-${CODEX_HOME:-~/.codex}/skills}`
- 完整参考包：`${CODEX_BUNDLE_DIR:-${CODEX_HOME:-~/.codex}/everything-codex-code}`

## Codex 关键文件

- 项目指令入口：`AGENTS.md`
- 包管理器配置：`.codex/package-manager.json`
- 包管理器环境变量：`CODEX_PACKAGE_MANAGER`

## 说明

- 本仓库是 **Codex-only** 版本。
- 已移除 Claude 插件兼容逻辑。
