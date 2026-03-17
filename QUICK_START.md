# 🎯 Copilot Commit Hook 快速开始指南

## ✅ 已完成的修复

从 `pre-commit` hook 改为 `prepare-commit-msg` hook，完全解决了消息文件写入问题。

## 🚀 3步快速开始

### 1️⃣ 安装 Hook
```powershell
.\setup-copilot-hook.ps1
```
✅ 输出：`✅ Copilot prepare-commit-msg hook installed successfully!`

### 2️⃣ 提交代码
```bash
git add .
git commit
```

### 3️⃣ 选择消息
```
🤖 Generating commit message with Copilot...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 Generated Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Add authentication module with token validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Use this message? (y/n) [y=yes, n=abort]: y
```

## 📋 选项说明

| 选项 | 效果 |
|------|------|
| **y** | ✅ 使用生成的消息并提交 |
| **n** | 📝 git打开编辑器让你输入消息 |

## 🔧 高级用法

### 跳过Hook
```bash
git commit --no-verify
```

### 禁用Hook
```powershell
Remove-Item .git/hooks/prepare-commit-msg
```

### 重新安装
```powershell
.\setup-copilot-hook.ps1 -Force
```

## ⚙️ 配置

Hook使用：
- **模型**：GPT-5 mini（免费）
- **风格**：简洁（1-2句）
- **获取diff**：`git diff --cached`
- **文件**：`.git/hooks/prepare-commit-msg`

要更改模型或风格，编辑 `.git/hooks/prepare-commit-msg` 文件。

## 🆘 常见问题

**Q: Hook没有触发？**
- A: 确保运行了 `setup-copilot-hook.ps1`
- 检查文件是否存在：`.git/hooks/prepare-commit-msg`

**Q: 错误 "copilot not found"？**
- A: 安装 GitHub Copilot CLI
- 验证：`copilot --version`

**Q: 消息生成失败？**
- A: Hook会允许你手动输入消息
- 检查网络连接

**Q: 在CI/CD中使用？**
- A: Hook在非交互模式下会自动接受生成的消息

## 📚 文件说明

- **setup-copilot-hook.ps1** - 安装脚本
- **.git/hooks/prepare-commit-msg** - 主要Hook脚本
- **COPILOT_COMMIT_GUIDE.md** - 完整文档

## 🎉 就这样！

现在每次提交都会自动生成AI消息。选择接受或自己输入 - 完全由你控制！
