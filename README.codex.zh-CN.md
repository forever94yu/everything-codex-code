# Everything Codex Code（中文）

这是 `everything-codex-code` 的 **Codex 专用版本**。

包含内容：

- `agents/`：子代理模板
- `skills/`：技能库
- `commands/`：命令模板
- `hooks/` 与 `scripts/hooks/`：自动化钩子
- `rules/`：工程规范
- `mcp-configs/`：MCP 配置模板

## 快速开始

```bash
git clone <你的仓库地址> everything-codex-code
cd everything-codex-code
npm install
npx eccx-install typescript
```

多语言安装：

```bash
npx eccx-install typescript python golang
```

显式指定目标（效果相同）：

```bash
npx eccx-install --target codex typescript
```

可选（类 Unix 环境）：

```bash
./install.sh typescript
```

## 安装路径

- Rules：`${CODEX_RULES_DIR:-${CODEX_HOME:-~/.codex}/rules}`
- Skills：`${CODEX_SKILLS_DIR:-${CODEX_HOME:-~/.codex}/skills}`
- 参考包：`${CODEX_BUNDLE_DIR:-${CODEX_HOME:-~/.codex}/everything-codex-code}`

## Codex 关键文件

- 项目指令入口：`AGENTS.md`
- 包管理器配置：`.codex/package-manager.json`
- 环境变量：`CODEX_PACKAGE_MANAGER`

## 说明

- 本仓库为 **Codex-only**。
- 已移除 Claude 插件兼容逻辑。
