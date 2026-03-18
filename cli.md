# Copilot CLI 技术分享

# 入门

先安装 Copilot CLI：

```bash
npm install -g @github/copilot
```

一个最简单的体验方式：

```text
copilot
> What does samples/book-app-project/book_app.py do?
```

如果要用一句话介绍 Copilot CLI

- 它是一个运行在终端里的 Copilot，可以直接读代码、理解命令输出、帮你生成修改方案，甚至在授权后替你执行一些操作。

# 交互方式使用 Copilot CLI

交互方式适合“边问边改”的工作流，尤其适合探索代码、拆解任务、逐步修复问题。
- `@`符号指定上下文
- `/model`：切换大语言模型。
- `/agent`：选择或自定义 agent，本质上可以理解成一套更聚焦的提示词和行为模式.
- `/context`：查看上下文使用情况。
- `/fleet`：把可并行的任务交给多个线程或模型一起处理，执行过程中可以用 `/tasks` 查看后台任务。
- `/delegate`：提交当前的修改并且创建PR，适合在 GitHub 上协作的项目。
- `/share`: 分享当前session为一个md文档.
- `/research` 利用 GitHub 搜索及网络资源，开展深入调研。
- `quit` 后可以用 `copilot --continue` 回到上一个会话，也可以用 `/resume` 选择历史会话继续。

示例：

- 带上下文提问（@ 指定文件）:
```text
@autopilot/AutopilotApi/Program.cs
请用 3 句话解释这个文件的职责，并指出后续最适合扩展 Login API 的位置。
```

- 使用自定义 agent 做讲解
```
/agent
（选择 architectural-explainer）
请用新手能听懂的方式解释这段依赖注入代码。@Program.cs:46-89
```

- 调研/探索模式
```
/research
调研 ASP.NET Core 中实现 JWT 登录的最小实践，并输出 5 条可落地建议。
```

## Autopilot 模式

Autopilot 更适合“可以自动执行”,"可闭环执行"的任务。

它的典型工作流程是：

- 读取任务要求。
- 分析当前项目结构。
- 编写或修改代码。
- 运行命令验证结果。
- 发现错误后自动进入下一轮修复。
- 循环往复, 直到它对结果有足够信心才结束。

- 普通模式像“你在驾驶，Copilot 给建议”。
- Autopilot 像“你先给目标，Copilot 代你完成一段相对闭环的执行流程”。

例如：

```text
copilot
> 创建一个目录autopilot\ 并在该目录下创建一个 ASP.NET的api项目模板
```

如果你已经明确接受它执行命令、创建文件、修改代码，可以先开启更高权限模式，例如：

- `/allow-all`：默认允许 Copilot 执行它需要的操作。

在 Autopilot 执行过程中，可以输入 `/tasks` 查看后台正在运行的分析、生成、编译或测试任务。

这里也建议补一句风险提示：

- Autopilot 很省事，但前提是任务边界要清晰。
- 越是“目标明确、验证标准明确”的任务，Autopilot 的效果越好。

## PLAN 模式

Plan 模式更适合复杂任务，尤其是“先想清楚，再动手”。

- 它会先分析需求和现有代码，再生成一个结构化计划。
- 适合执行前需要审查方案的任务。
- 在计划生成后，通常会询问你是否应用这个 plan。

示例：

```text
copilot
> /plan add a login API to an ASP.NET Core project
```

如果从分享视角来讲，Plan 模式最适合下面几类任务：

- 问题不明确,需求比较模糊，需要先澄清设计决策。
- 改动范围比较大，不想让 AI 直接开改。
- 需要团队一起评审方案，而不是马上落代码。

你也可以把它类比成：

- 不是“直接写代码”，而是“先让 AI 出施工图”。

`/research` 适合在写 plan 之前先做信息探索。

## CLI 和 IDE 可以搭配使用

CLI 并不是孤立工具，而是 IDE 工作流的一部分。

- IDE 中选中的代码，CLI 可以直接感知和引用，这通常依赖本地上下文集成能力。
- CLI中的会话也能直接在CLI中显示

分享时可以给听众一个很实用的结论：

- IDE 适合“看代码、写代码、点选定位”。
- CLI 适合“串联命令、消费日志、快速发起任务”。
- 两者结合后，AI 不再只是在编辑器里补全代码，而是开始参与整个开发链路。

# 非交互方式使用 Copilot CLI

非交互方式更适合自动化、脚本、CI/CD、单次命令。想嵌入脚本或工作流水线，用 `-p` 非交互模式。

它的优势是：

- 调用简单。
- 容易集成进已有脚本。
- 很适合把“解释、总结、生成文本”这类工作流程嵌入命令行。

例如：

```bash
copilot -p "解释一下这个命令出现的错误：$(npm run build 2>&1)"
copilot -p "解释一下这个项目都干了什么：$(type ChatBot.sln)"
copilot -p "为以下内容生成一条规范化提交信息： $(git diff --staged)"
```

如果你希望它在单次命令里具备更多执行权限，也可以组合参数使用，例如：

```bash
copilot -p --allow-all --silent --model Claude-opus-4.5 "analyze the current change set and refactor the code to improve readability"
```

如果你经常使用固定参数，可以在终端配置别名，例如：

```bash
alias poolCopilot="copilot --silent --allow-all --model xxxx"
```

还可以把文件内容通过管道交给 Copilot：

```bash
cat OrderService.cs | copilot -p "重构这个 Service 方法以提高可读性"
```

经验:
- 单次命令非常适合“小而确定”的任务。
- 如果任务需要多轮反馈，还是回到交互模式更高效。

### 在脚本中使用

比如利用git的hooks，在提交前自动生成提交信息

价值点：
- 把原本靠人手工总结的动作自动化。
- 把原本零散的信息压缩成可读结论。

### 在 CI/CD 中使用

CI/CD 里更适合把 Copilot CLI 用在“解释和汇总”上，而不是直接让它做高风险变更。

例如可以考虑这些场景：

- 总结构建失败原因。
- 分析测试失败日志。
- 给 PR 或流水线生成简要说明。
- 自动整理部署结果并输出可读摘要。

示例思路：

```bash
copilot -p "请总结本次构建失败的原因，并按优先级列出修复建议：$(npm run build 2>&1)"
```
- 在 CI/CD 中使用时，重点不是“让 AI 代替流水线决策”，而是“让 AI 帮人更快理解流水线结果”。

# CLI vs IDE 对比

一句话概括：

- Copilot IDE 是把 AI 放进编辑器。
- Copilot CLI 是把 AI 放进终端工作流。

两者不是替代关系，而是分工不同。

Copilot IDE 更擅长：

- 围绕当前文件和当前代码上下文进行补全、解释、修改和重构。
- 配合编辑器完成跳转、定位、边看边改。
- 在开发者写代码的过程中提供即时辅助。

Copilot CLI 更擅长：

- 面向命令行任务进行分析、规划和执行。
- 直接理解终端输出、日志、构建结果和脚本内容。
- 串联 shell、Git、测试、构建等开发链路。

如果从使用场景来区分，可以这样理解：

- 当你正在编辑代码、关注某个函数或某个文件时，用 IDE 更顺手。
- 当你正在终端里处理报错、执行命令、分析输出、组织任务时，用 CLI 更自然。

也就是说：

- IDE 偏“代码编辑现场”。
- CLI 偏“终端任务现场”。

在实际工作中，两者结合起来效果最好：

- 在 IDE 中理解和修改代码。
- 在 CLI 中分析日志、生成计划、处理脚本化任务。
- 再回到 IDE 中审查结果和细化改动。

- Copilot IDE 提升的是写代码的效率，Copilot CLI 提升的是整个开发工作流的效率。







