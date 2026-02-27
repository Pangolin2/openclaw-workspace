# Agent Skill 最佳实践报告

**报告日期**: 2026年2月26日  
**整理**: OpenClaw AI Assistant  
**收件人**: haozhiliang@huawei.com

---

## 执行摘要

本报告基于 OpenClaw 官方文档、Google Cloud 架构指南及业界最佳实践，系统梳理了 AI Agent Skill（智能体技能）的设计原则、实现方法和运营模式，为构建高效、安全、可扩展的 AI 智能体系统提供参考。

---

## 一、Agent Skill 核心概念

### 1.1 什么是 Skill？

Agent Skill 是赋予 AI 智能体特定能力的模块化组件，包含：
- **SKILL.md**: 技能的元数据和使用说明（YAML frontmatter + Markdown）
- **工具定义**: 智能体可使用的工具（bash、browser、API 等）
- **资源文件**: 脚本、配置文件等辅助资源

### 1.2 Skill 的加载优先级

OpenClaw 从三个层级加载技能（优先级从高到低）：

1. **Workspace skills**: `<workspace>/skills` — 当前工作区专属
2. **Managed/local skills**: `~/.openclaw/skills` — 全局共享
3. **Bundled skills**: 随 OpenClaw 安装包附带

**最佳实践**: 通用技能放 `~/.openclaw/skills`，特定 agent 专属技能放各自 workspace。

---

## 二、Skill 设计最佳实践

### 2.1 设计原则

#### ✅ DO（推荐）

| 原则 | 说明 |
|------|------|
| **简洁明确** | 告诉模型做什么，而不是如何成为一个 AI |
| **单一职责** | 每个 Skill 专注一个核心功能 |
| **安全优先** | 使用 bash 时避免命令注入风险 |
| **本地测试** | 使用 `openclaw agent --message` 测试新技能 |
| **YAML 规范** | 正确使用 frontmatter 定义元数据 |

#### ❌ DON'T（避免）

| 反模式 | 后果 |
|--------|------|
| 过度复杂 | 智能体理解困难，执行效率低 |
| 工具权限过大 | 安全风险，可能执行破坏性操作 |
| 模糊描述 | 智能体行为不可预测 |
| 重复造轮子 | 优先使用社区已有技能（ClawHub） |

### 2.2 SKILL.md 结构模板

```yaml
---
name: skill_name                    # 技能唯一标识
description: "简短描述"              # 一句话说明用途
allowed-tools:                      # 允许使用的工具
  - Bash(cmd1)
  - Bash(cmd2)
  - web_search
user-invocable: true                # 是否可被用户直接调用
---

# Skill 标题

## 适用场景
描述什么时候应该使用这个技能

## 使用步骤
1. 第一步做什么
2. 第二步做什么
3. 结果验证

## 示例
```
用户: "执行xxx操作"
AI: [使用本技能的步骤]
```

## 注意事项
- 重要限制条件
- 安全提醒
```

---

## 三、多 Agent 协作模式

### 3.1 设计模式选择（Google Cloud 推荐）

| 模式 | 适用场景 | 复杂度 | 延迟 |
|------|----------|--------|------|
| **单 Agent** | 简单任务、快速响应 | 低 | 低 |
| **多 Agent 协作** | 复杂工作流、需要专业分工 | 高 | 中-高 |
| **层级架构** | 需要审批和管控的企业场景 | 高 | 高 |
| **自主运营** | 24/7 无人值守系统 | 极高 | 中 |

### 3.2 多 Agent 最佳实践

#### 角色差异化
- **使用不同模型**: 避免所有 Agent 用同一模型（会变成"克隆人"）
- **个性区分**: 每个 Agent 有独特的 system prompt 和沟通风格
- **职责明确**: 决策、分析、执行、质检各司其职

#### 协作机制
```
┌────────────────────────────────────────┐
│  Minion (决策)  ← 审批/分配任务        │
│     ↑↓                                │
│  Sage (策略)   ← 深度分析              │
│     ↑↓                                │
│  Scout (情报)  ← 信息收集              │
│     ↑↓                                │
│  Quill (创作)  ← 内容生产              │
│     ↑↓                                │
│  Xalt (运营)   ← 社交发布              │
│     ↑↓                                │
│  Observer (质检) ← 审核/自愈          │
└────────────────────────────────────────┘
```

#### 避坑指南

| 坑点 | 解决方案 |
|------|----------|
| **任务争抢** | 单一执行者原则：VPS 执行，Vercel 只做控制平面 |
| **任务悬空** | 单一入口函数：`createProposalAndMaybeAutoApprove` |
| **队列溢出** | 门禁机制：入口处检查配额，满则立即拒绝 |
| **系统卡住** | 自愈机制：定时检查并恢复停滞任务（30分钟阈值） |

---

## 四、Prompt Engineering 最佳实践

### 4.1 提示词设计原则

1. **结构化**: 使用清晰的章节和步骤
2. **示例驱动**: 提供 input/output 示例
3. **抽象模式**: 给出多个示例时，提取通用格式而非重复全文
4. **迭代优化**: 基于真实表现数据持续优化

### 4.2 Agent System Prompt 模板

```markdown
你是 [角色名]，[职责描述]。

## 核心职责
1. 职责一
2. 职责二
3. 职责三

## 工作原则
- 原则一：具体说明
- 原则二：具体说明

## 个性特征
- 特征一
- 特征二

## 规则约束
- 速度 > 完美：先推重点，再补充
- 客观性：必须找至少一个反向风险
- 数据驱动：用数据说话，不依赖"公认"
- 一手源优先：财报、SEC filing、官方声明
- 不做预测：陈述事实和风险，不预测涨跌
```

---

## 五、安全与管控

### 5.1 安全原则

| 层级 | 措施 |
|------|------|
| **技能层面** | 限制工具权限，避免任意命令执行 |
| **Agent 层面** | 敏感操作需人工确认 |
| **系统层面** | 分级管控，核心决策需审批 |
| **监控层面** | 全程日志，异常实时告警 |

### 5.2 渐进式信任

> **"像对待新入职的人类助理一样监督 AI"**

- **初期**: 所有邮件草稿进待审核文件夹
- **中期**: 低风险操作自动执行，高风险需确认
- **后期**: 完全自主，定期审计

---

## 六、运营监控体系

### 6.1 关键指标

| 类别 | 指标 |
|------|------|
| **任务流** | 提案→任务→完成转化率 |
| **质量** | Observer 拦截率、人工复核率 |
| **效率** | 平均任务完成时间 |
| **成本** | Token 消耗、API 调用费用 |
| **协作** | 多 Agent 冲突次数 |

### 6.2 实时仪表盘

建议监控面板包含：
- Agent 在线状态
- 提案队列深度
- 任务执行进度
- 实时对话流（圆桌讨论）
- 系统健康度（卡住任务数）

---

## 七、实施路线图

### Phase 1: 基础搭建（1-2周）
- [ ] 设计 Agent 角色和职责
- [ ] 创建核心 Skill（每个 Agent 的专属技能）
- [ ] 搭建 Supabase 数据库
- [ ] 部署 Vercel 仪表盘

### Phase 2: 核心功能（2-3周）
- [ ] 实现提案→任务流转机制
- [ ] 配置定时任务和触发器
- [ ] 设置反应矩阵
- [ ] 实现自愈机制

### Phase 3: 优化迭代（持续）
- [ ] 基于数据优化提示词
- [ ] 调整配额和冷却时间
- [ ] 扩展触发规则
- [ ] 改进 Agent 协作逻辑

---

## 八、推荐资源

### 官方文档
- [OpenClaw Skills 文档](https://docs.openclaw.ai/tools/skills)
- [Creating Skills 指南](https://openclawlab.com/en/docs/tools/creating-skills/)
- [ClawHub 技能市场](https://clawhub.com)

### 架构参考
- [Google Cloud Agent Design Patterns](https://docs.cloud.google.com/architecture/choose-design-pattern-agentic-ai-system)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [Awesome OpenClaw Skills](https://github.com/VoltAgent/awesome-openclaw-skills)

### 学习资源
- [Prompt Engineering Guide](https://www.promptingguide.ai/)
- [AI Agent Prompt Engineering](https://www.mindstudio.ai/blog/prompt-engineering-ai-agents)

---

## 结语

构建高效的 AI Agent 系统不是一蹴而就的，需要：
1. **清晰的架构设计** — 角色、流程、管控
2. **持续的数据驱动优化** — 基于真实表现迭代
3. **安全与效率的平衡** — 信任但验证

记住：**"让系统活起来"** 的关键不是完美的代码，而是可持续的反馈闭环和进化机制。

---

**报告完**

*如有疑问或需要深入讨论某个具体方面，请随时联系。*
