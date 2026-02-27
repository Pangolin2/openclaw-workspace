# 子代理使用指南

三个专业子代理配置完成，可通过主代理调用。

---

## 📋 子代理概览

| 子代理 | 模型 | 专长 | 工作区 |
|--------|------|------|--------|
| **coder** | DeepSeek Chat | 编码、技术方案 | `workspace-coding/` |
| **researcher** | Kimi K2.5 | 深度研究、分析 | `workspace-research/` |
| **writer** | Kimi K2.5 | 内容创作、文案 | `workspace-writing/` |

---

## 🚀 调用方式

### 方式 1：主代理直接 spawn

```javascript
// 编码任务
await sessions_spawn({
  task: "用 Python 写一个爬虫抓取新闻标题",
  agentId: "coder",
  mode: "run"
});

// 研究任务
await sessions_spawn({
  task: "分析 OpenAI 最新发布的模型能力对比",
  agentId: "researcher",
  mode: "run"
});

// 写作任务
await sessions_spawn({
  task: "写一篇关于 AI Agent 的推文",
  agentId: "writer",
  mode: "run"
});
```

### 方式 2：指定模型快速调用

```javascript
// 不通过配置，直接指定模型
await sessions_spawn({
  task: "优化这段代码的性能",
  model: "deepseek/deepseek-chat",
  workspace: "/root/.openclaw/workspace-coding",
  mode: "run"
});
```

---

## 🔄 典型工作流

### 场景：写一篇技术分析文章

```
用户: "写一篇关于 React 19 新特性的技术文章"

主代理 (Minion) 分析任务：
├── 需要研究 React 19 新特性
├── 需要撰写技术文章
└── 分配任务：

    Step 1: Researcher 收集资料
    └── sessions_spawn({
        task: "研究 React 19 的新特性、改进点、 breaking changes",
        agentId: "researcher"
    })

    Step 2: Writer 撰写文章
    └── sessions_spawn({
        task: "基于研究资料，写一篇 React 19 技术文章",
        agentId: "writer"
    })

    Step 3: Coder 提供代码示例
    └── sessions_spawn({
        task: "为 React 19 新特性提供可运行的代码示例",
        agentId: "coder"
    })

    Step 4: Writer 整合发布
    └── 整合代码示例到文章，输出最终版本
```

---

## 📁 文件结构

```
~/.openclaw/
├── openclaw.json          # 子代理配置
├── workspace/             # 主代理工作区
├── workspace-coding/      # 编码子代理
│   ├── SOUL.md
│   └── skills/
├── workspace-research/    # 研究子代理
│   ├── SOUL.md
│   └── skills/
└── workspace-writing/     # 写作子代理
    ├── SOUL.md
    └── skills/
```

---

## ⚙️ 配置文件关键项

`~/.openclaw/openclaw.json`:

```json
{
  "agents": {
    "profiles": {
      "coder": {
        "model": "deepseek/deepseek-chat",
        "workspace": "/root/.openclaw/workspace-coding",
        "systemPrompt": "file:///root/.openclaw/workspace-coding/SOUL.md",
        "maxConcurrent": 2
      },
      "researcher": {
        "model": "moonshot/kimi-k2.5",
        "workspace": "/root/.openclaw/workspace-research",
        "systemPrompt": "file:///root/.openclaw/workspace-research/SOUL.md",
        "maxConcurrent": 3
      },
      "writer": {
        "model": "moonshot/kimi-k2.5",
        "workspace": "/root/.openclaw/workspace-writing",
        "systemPrompt": "file:///root/.openclaw/workspace-writing/SOUL.md",
        "maxConcurrent": 2
      }
    }
  }
}
```

---

## 🔧 扩展方法

### 添加新的子代理

1. 创建新工作区：
```bash
mkdir -p /root/.openclaw/workspace-designer/skills
```

2. 创建 SOUL.md：
```bash
echo "# Designer - 设计专家" > /root/.openclaw/workspace-designer/SOUL.md
```

3. 在 `openclaw.json` 中添加配置：
```json
"designer": {
  "model": "claude-sonnet-4-20250514",
  "workspace": "/root/.openclaw/workspace-designer",
  "systemPrompt": "file:///root/.openclaw/workspace-designer/SOUL.md",
  "maxConcurrent": 2
}
```

4. 重启 gateway：
```bash
openclaw gateway restart
```

---

## 💡 使用建议

1. **任务匹配**：根据任务类型选择正确子代理
2. **并行执行**：独立任务可同时 spawn 多个子代理
3. **结果复用**：子代理输出可传递给其他子代理继续处理
4. **监控状态**：使用 `subagents list` 查看运行中的子代理

---

## 📚 相关文档

- `workspace-coding/SOUL.md` - 编码专家配置
- `workspace-research/SOUL.md` - 研究分析师配置
- `workspace-writing/SOUL.md` - 内容创作者配置
