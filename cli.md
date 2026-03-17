# 入门
```npm install -g @github/copilot```

```
copilot 
> What does samples/book-app-project/book_app.py do?
```

# 交互方式使用Copilot CLI

- copilot /modle 选取大语言模型
- /Agent 自定义agent/选取Agent 本质上是一个prompt文件
- quit -> copilot --continue  退出之后可以使用copilot --continue回到上一个回话, 或者copilot /resume 选择哪些会话
- /session checkpoints 查看当前会话中的历史检查点（Checkpoints）。
- /context 查看上下文用了多少
- /fleet 多线程多模型执行多个可并行任务 ,执行过程中可以用/task查看

进程挂起：在 Linux/Mac 环境下，可使用 Ctrl + Z 将 Copilot CLI 进程挂起，执行其他系统命令后再通过 fg 恢复[1]。

## AutpCopilot模式
- autopilot更适合“可自动执行的任务”
- AI 会阅读任务要求 -> 自己编写代码 -> 运行结果 -> 检查自己输出是否出错 -> 如果出错则自动进入下一轮修复。直到它对自己的输出结果有足够的置信度，才会停止工作。
  - copilot /allow-all  默认允许copilot的任何操作
    "create a new ASP.NET Core Web API project"
输入 /tasks 查看后台正在跑什么分析和编译任务

## PLAN模式
- plan模式与openspec类似, 会生成一个plan.md文档. 适合在执行前审查方法的复杂任务
- 在执行完成后会询问你是否应用这个plan
    copilot 
    >/plan "add a login API to an ASP.NET Core project"
    /research 类似 /opsx-explore

## CLI和IDE可以搭配使用
- IDE中选择的代码可以在CLI中直接看到, 利用本地mcp实现
- 在CLI中执行过的会话可以在CLI中看见

# 非交互方式使用copilot cli

## 适合自动化、脚本、CI/CD、单次命令。

- copilot -p "解释一下这个命令出现的错误$(npm run build 2>&1)"
- copilot -p "解释一下这个项目都干了什么$(ChatBot.sln)"
- copilot -p "Generate a conventional commit message for: $(git diff --staged)"
- copilot -p --allow-all -silent --model Claude-opus-4.5
或者在系统终端 .zshrc 中配置一个别名 (Alias)：alias poolCopilot="copilot -silent --allow --model xxxx"
- cat OrderService.cs | copilot --plan -p "重构这个Service方法以提高可读性"

### 在脚本中使用
```
# Generate commit messages automatically
COMMIT_MSG=$(copilot -p "Generate a commit message for: $(git diff --staged)")
git commit -m "$COMMIT_MSG"
```

# Agent





