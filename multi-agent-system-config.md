# OpenClaw 多智能体自主运营系统配置

基于 OpenClaw + Vercel + Supabase 的 AI 自主运营架构

---

## 1. 系统架构

```
┌─────────────────────────────────────────────────────────────┐
│                        VPS (OpenClaw)                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ 6个AI智能体 │  │  定时任务   │  │   任务执行引擎      │  │
│  │ (子代理)    │  │  (Cron)     │  │   (唯一执行者)      │  │
│  └──────┬──────┘  └─────────────┘  └─────────────────────┘  │
└─────────┼───────────────────────────────────────────────────┘
          │
          ▼ 读取/写入
┌─────────────────────────────────────────────────────────────┐
│                      Vercel (Next.js)                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  网站前端   │  │  API 路由   │  │   控制平面          │  │
│  │  仪表盘     │  │  (轻量)     │  │ (评估触发器/反应队列)│  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────┬───────────────────────────────────────────────────┘
          │
          ▼ 单一真实来源
┌─────────────────────────────────────────────────────────────┐
│                      Supabase (PostgreSQL)                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   提案表    │  │   任务表    │  │   事件/记忆表       │  │
│  │  proposals  │  │   tasks     │  │   events/memories   │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. 六个 AI 智能体角色配置

### 2.1 Minion - 决策智能体

```json
{
  "agent_id": "minion",
  "name": "Minion",
  "role": "decision_maker",
  "description": "最终决策者，负责提案审批和任务分配",
  "model": "claude-sonnet-4-20250514",
  "system_prompt": "你是 Minion，决策智能体。你的职责是：\n1. 评估所有提案的优先级和可行性\n2. 做出最终执行决策\n3. 解决智能体间的争议\n4. 分配任务给执行者\n\n决策原则：\n- 数据优先：基于 Scout 的情报和 Sage 的分析做决策\n- 效率优先：避免过度分析，快速推进\n- 风险控制：Observer 反馈质量问题时暂停相关任务",
  "tools": ["sessions_spawn", "memory_search", "web_search", "message"],
  "schedule": ["0 9 * * *"],
  "triggers": ["proposal_created", "conflict_detected"]
}
```

### 2.2 Sage - 策略分析智能体

```json
{
  "agent_id": "sage",
  "name": "Sage",
  "role": "strategist",
  "description": "策略分析师，负责深度研究和策略制定",
  "model": "gpt-4o",
  "system_prompt": "你是 Sage，策略分析智能体。你的职责是：\n1. 分析 Scout 收集的情报\n2. 制定内容策略和运营策略\n3. 评估执行效果并提出优化建议\n4. 与 Minion 协作确定优先级\n\n分析原则：\n- 客观性：必须找至少一个反向风险\n- 数据驱动：引用具体数据支撑观点\n- 一手源优先：财报、SEC filing、官方声明",
  "tools": ["web_search", "web_fetch", "sessions_spawn", "memory_search"],
  "schedule": ["0 10 * * *", "0 16 * * *"],
  "triggers": ["data_collected", "weekly_review"]
}
```

### 2.3 Scout - 情报收集智能体

```json
{
  "agent_id": "scout",
  "name": "Scout",
  "role": "intelligence_gatherer",
  "description": "情报收集员，负责监控信息源和数据采集",
  "model": "gemini-2.5-pro",
  "system_prompt": "你是 Scout，情报收集智能体。你的职责是：\n1. 监控 Twitter、RSS、HackerNews、GitHub Trending 等信息源\n2. 收集行业动态和热点话题\n3. 整理竞争对手动态\n4. 发现潜在的内容机会\n\n收集原则：\n- 速度 > 完美：发现热点立即上报\n- 一手源优先：直接抓取官方信息\n- 标注不确定信息：⚠️ 未经一手源证实",
  "tools": ["web_search", "web_fetch", "exec", "sessions_spawn"],
  "schedule": ["*/30 * * * *"],
  "triggers": ["trending_detected", "news_alert"],
  "sources": [
    "https://news.ycombinator.com",
    "https://github.com/trending",
    "https://reddit.com/r/programming",
    "https://techcrunch.com"
  ]
}
```

### 2.4 Quill - 内容创作智能体

```json
{
  "agent_id": "quill",
  "name": "Quill",
  "role": "content_creator",
  "description": "内容创作者，负责文章和文案撰写",
  "model": "deepseek/deepseek-chat",
  "system_prompt": "你是 Quill，内容创作智能体。你的职责是：\n1. 根据 Sage 的策略和 Scout 的情报创作内容\n2. 撰写博客文章、推文、文案\n3. 优化内容 SEO 和可读性\n4. 与 Xalt 协作准备社交媒体内容\n\n创作原则：\n- 能一句话说完就一句话说完\n- 数据支撑：引用 Scout 提供的数据\n- 明确观点：不模棱两可\n- 速度优先：先推初稿，再迭代优化",
  "tools": ["write", "edit", "sessions_spawn", "memory_search"],
  "schedule": ["0 11 * * *", "0 15 * * *"],
  "triggers": ["content_request", "topic_approved"],
  "content_types": ["blog_post", "tweet_thread", "newsletter", "social_post"]
}
```

### 2.5 Xalt - 社交媒体管理智能体

```json
{
  "agent_id": "xalt",
  "name": "Xalt",
  "role": "social_media_manager",
  "description": "社交媒体管理员，负责 Twitter 等平台运营",
  "model": "moonshot/kimi-k2.5",
  "system_prompt": "你是 Xalt，社交媒体管理智能体。你的职责是：\n1. 管理 Twitter/X 账号，发布推文\n2. 与社区互动，回复评论\n3. 监控推文表现数据\n4. 与 Quill 协作优化文案\n5. 与 Sage 讨论策略分歧（可能吵架）\n\n运营原则：\n- 频率控制：遵守配额限制\n- 互动优先：回复比发布更重要\n- 数据反馈：记录每篇推文的表现\n- 个性表达：展现智能体独特的"人格"",
  "tools": ["message", "web_fetch", "sessions_spawn", "exec"],
  "schedule": ["0 */4 * * *"],
  "triggers": ["content_ready", "engagement_spike", "mention_received"],
  "platforms": ["twitter/x", "telegram"],
  "daily_quota": {
    "tweets": 10,
    "replies": 50
  }
}
```

### 2.6 Observer - 质量检查智能体

```json
{
  "agent_id": "observer",
  "name": "Observer",
  "role": "quality_inspector",
  "description": "质量检查员，负责审核和监控",
  "model": "claude-sonnet-4-20250514",
  "system_prompt": "你是 Observer，质量检查智能体。你的职责是：\n1. 审核所有发布前的内容\n2. 监控已发布内容的表现\n3. 检查系统健康状态（卡住的任务）\n4. 执行自愈机制：recoverStaleSteps\n5. 向 Minion 报告质量问题\n\n检查原则：\n- 零容忍：事实错误、敏感信息必拦\n- 标准明确：制定并维护质量标准\n- 反馈及时：发现问题立即上报\n- 持续改进：分析错误模式，优化流程",
  "tools": ["sessions_spawn", "memory_search", "exec", "subagents"],
  "schedule": ["*/15 * * * *"],
  "triggers": ["content_pending", "task_stalled", "error_detected"],
  "recovery": {
    "stalled_threshold_minutes": 30,
    "auto_retry": true,
    "escalation_to_minion": true
  }
}
```

---

## 3. 数据库表结构 (Supabase)

### 3.1 提案表 (ops_mission_proposals)

```sql
CREATE TABLE ops_mission_proposals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    proposed_by VARCHAR(50) NOT NULL, -- agent_id
    proposal_type VARCHAR(50) NOT NULL, -- content, strategy, reaction
    priority INTEGER DEFAULT 5, -- 1-10
    status VARCHAR(20) DEFAULT 'pending', -- pending, approved, rejected
    auto_approved BOOLEAN DEFAULT false,
    requires_quota_check BOOLEAN DEFAULT true,
    quota_type VARCHAR(50), -- tweet, blog_post, etc.
    created_at TIMESTAMP DEFAULT NOW(),
    approved_at TIMESTAMP,
    approved_by VARCHAR(50),
    rejection_reason TEXT,
    metadata JSONB
);
```

### 3.2 任务表 (ops_tasks)

```sql
CREATE TABLE ops_tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proposal_id UUID REFERENCES ops_mission_proposals(id),
    title TEXT NOT NULL,
    assigned_to VARCHAR(50) NOT NULL, -- agent_id
    status VARCHAR(20) DEFAULT 'pending', -- pending, running, completed, failed
    steps JSONB DEFAULT '[]', -- 执行步骤
    current_step INTEGER DEFAULT 0,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    deadline TIMESTAMP,
    output TEXT,
    error_log TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
```

### 3.3 事件/记忆表 (ops_events)

```sql
CREATE TABLE ops_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type VARCHAR(50) NOT NULL, -- discussion, decision, conflict, achievement
    agent_id VARCHAR(50), -- 主要相关智能体
    content TEXT NOT NULL,
    related_agents VARCHAR(50)[],
    round_table_id UUID, -- 关联的圆桌讨论
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);
```

### 3.4 配额表 (ops_quotas)

```sql
CREATE TABLE ops_quotas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quota_type VARCHAR(50) UNIQUE NOT NULL,
    daily_limit INTEGER NOT NULL,
    used_today INTEGER DEFAULT 0,
    reset_at TIMESTAMP DEFAULT NOW(),
    last_updated TIMESTAMP DEFAULT NOW()
);

-- 初始化配额
INSERT INTO ops_quotas (quota_type, daily_limit) VALUES
    ('tweet', 10),
    ('blog_post', 2),
    ('reply', 50);
```

### 3.5 反应矩阵 (ops_policies)

```sql
CREATE TABLE ops_policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trigger_event VARCHAR(100) NOT NULL, -- 触发事件
    actor_agent VARCHAR(50) NOT NULL, -- 执行反应的智能体
    reaction_action VARCHAR(100) NOT NULL, -- 反应动作
    probability DECIMAL DEFAULT 1.0, -- 概率 (0-1)
    cooldown_minutes INTEGER DEFAULT 60, -- 冷却时间
    conditions JSONB, -- 附加条件
    enabled BOOLEAN DEFAULT true
);

-- 反应矩阵示例
INSERT INTO ops_policies (trigger_event, actor_agent, reaction_action, probability) VALUES
    ('xalt_tweet_posted', 'sage', 'analyze_performance', 0.3),
    ('conflict_detected', 'scout', 'mediate_discussion', 0.5),
    ('high_engagement', 'quill', 'create_follow_up', 0.7);
```

---

## 4. OpenClaw 配置文件

### 4.1 创建子代理配置

```json
// ~/.openclaw/agents.json
{
  "subagents": {
    "minion": {
      "model": "claude-sonnet-4-20250514",
      "system_prompt": "file:///root/.openclaw/workspace/agents/minion.md",
      "workspace": "/root/.openclaw/workspace/agents/minion"
    },
    "sage": {
      "model": "gpt-4o",
      "system_prompt": "file:///root/.openclaw/workspace/agents/sage.md",
      "workspace": "/root/.openclaw/workspace/agents/sage"
    },
    "scout": {
      "model": "gemini-2.5-pro",
      "system_prompt": "file:///root/.openclaw/workspace/agents/scout.md",
      "workspace": "/root/.openclaw/workspace/agents/scout"
    },
    "quill": {
      "model": "deepseek/deepseek-chat",
      "system_prompt": "file:///root/.openclaw/workspace/agents/quill.md",
      "workspace": "/root/.openclaw/workspace/agents/quill"
    },
    "xalt": {
      "model": "moonshot/kimi-k2.5",
      "system_prompt": "file:///root/.openclaw/workspace/agents/xalt.md",
      "workspace": "/root/.openclaw/workspace/agents/xalt"
    },
    "observer": {
      "model": "claude-sonnet-4-20250514",
      "system_prompt": "file:///root/.openclaw/workspace/agents/observer.md",
      "workspace": "/root/.openclaw/workspace/agents/observer"
    }
  }
}
```

### 4.2 HEARTBEAT.md - 协调任务

```markdown
# HEARTBEAT.md - 多智能体系统心跳

## 每 15 分钟检查

1. **Observer 检查任务状态**
   - 执行 recoverStaleSteps
   - 检查卡住的任务 (>30分钟)
   - 标记失败任务并上报 Minion

## 每 30 分钟 (Scout 工作)

2. **情报收集**
   - 检查 RSS/Twitter/GitHub 热点
   - 发现趋势 → 创建提案

## 每日 9:00 (圆桌会议)

3. **Minion 发起圆桌讨论**
   - 收集昨日数据
   - 讨论今日优先级
   - 投票决策

## 每 4 小时 (Xalt 工作)

4. **社交媒体发布**
   - 检查配额
   - 发布待发送内容
   - 监控互动
```

### 4.3 Cron 配置

```bash
# ~/.openclaw/crontab

# Scout - 情报收集 (每30分钟)
*/30 * * * * openclaw run --agent scout --task "collect_intelligence"

# Observer - 质量检查 (每15分钟)
*/15 * * * * openclaw run --agent observer --task "quality_check_and_recovery"

# Minion - 每日圆桌 (9:00 AM)
0 9 * * * openclaw run --agent minion --task "round_table_discussion"

# Sage - 策略分析 (10:00 AM, 4:00 PM)
0 10,16 * * * openclaw run --agent sage --task "strategy_analysis"

# Quill - 内容创作 (11:00 AM, 3:00 PM)
0 11,15 * * * openclaw run --agent quill --task "create_content"

# Xalt - 社交发布 (每4小时)
0 */4 * * * openclaw run --agent xalt --task "manage_social"
```

---

## 5. 核心函数实现

### 5.1 单一入口函数

```javascript
// lib/proposals.js - Vercel API 层

export async function createProposalAndMaybeAutoApprove(proposal) {
  // 1. 配额检查 (门禁机制)
  if (proposal.requires_quota_check) {
    const quota = await checkQuota(proposal.quota_type);
    if (quota.used_today >= quota.daily_limit) {
      return {
        status: 'rejected',
        reason: `Quota exceeded: ${proposal.quota_type} (${quota.used_today}/${quota.daily_limit})`
      };
    }
  }

  // 2. 创建提案
  const { data: created } = await supabase
    .from('ops_mission_proposals')
    .insert({
      ...proposal,
      status: 'pending'
    })
    .select()
    .single();

  // 3. 自动审批逻辑 (低优先级、无风险提案)
  if (shouldAutoApprove(proposal)) {
    await approveProposal(created.id, 'system', true);
    await createTaskFromProposal(created);
    return { status: 'approved', proposal_id: created.id };
  }

  // 4. 通知 Minion 人工审批
  await notifyAgent('minion', {
    type: 'proposal_pending',
    proposal_id: created.id
  });

  return { status: 'pending', proposal_id: created.id };
}

function shouldAutoApprove(proposal) {
  // 低风险、低优先级自动审批
  return proposal.priority <= 3 && !proposal.requires_quota_check;
}
```

### 5.2 自愈机制

```javascript
// lib/recovery.js

export async function recoverStaleSteps() {
  const threshold = new Date(Date.now() - 30 * 60 * 1000); // 30分钟前

  // 查找卡住的任务
  const { data: stalledTasks } = await supabase
    .from('ops_tasks')
    .select('*')
    .eq('status', 'running')
    .lt('started_at', threshold);

  for (const task of stalledTasks || []) {
    // 标记步骤失败
    await supabase
      .from('ops_tasks')
      .update({
        status: 'failed',
        error_log: `Task stalled for >30 minutes at step ${task.current_step}`,
        completed_at: new Date()
      })
      .eq('id', task.id);

    // 通知 Observer
    await notifyAgent('observer', {
      type: 'task_stalled',
      task_id: task.id,
      action_required: 'review_and_retry'
    });
  }

  return { recovered: stalledTasks?.length || 0 };
}
```

### 5.3 触发器系统

```javascript
// lib/triggers.js

const TRIGGERS = [
  {
    id: 'high_engagement',
    condition: async (event) => {
      return event.type === 'tweet_metrics' && 
             event.engagement_rate > 0.05; // 5%互动率
    },
    cooldown: 4 * 60 * 60 * 1000, // 4小时冷却
    action: async (event) => {
      return createProposalAndMaybeAutoApprove({
        title: `Analyze high-performing tweet: ${event.tweet_id}`,
        proposed_by: 'trigger_system',
        proposal_type: 'analysis',
        priority: 7
      });
    }
  },
  {
    id: 'task_failure',
    condition: async (event) => event.type === 'task_failed',
    cooldown: 0,
    action: async (event) => {
      return createProposalAndMaybeAutoApprove({
        title: `Diagnose task failure: ${event.task_id}`,
        proposed_by: 'trigger_system',
        proposal_type: 'diagnosis',
        priority: 9
      });
    }
  }
];

export async function evaluateTriggers(event) {
  for (const trigger of TRIGGERS) {
    if (await trigger.condition(event)) {
      // 检查冷却时间
      const lastTriggered = await getLastTriggerTime(trigger.id);
      if (Date.now() - lastTriggered > trigger.cooldown) {
        await trigger.action(event);
        await updateLastTriggerTime(trigger.id);
      }
    }
  }
}
```

### 5.4 反应矩阵

```javascript
// lib/reactions.js

export async function evaluateReactions(event) {
  // 从数据库加载启用的反应策略
  const { data: policies } = await supabase
    .from('ops_policies')
    .select('*')
    .eq('enabled', true)
    .eq('trigger_event', event.type);

  for (const policy of policies || []) {
    // 概率检查
    if (Math.random() > policy.probability) continue;

    // 冷却检查
    const lastReaction = await getLastReaction(policy.id);
    if (Date.now() - lastReaction < policy.cooldown_minutes * 60 * 1000) continue;

    // 条件检查
    if (policy.conditions && !evaluateConditions(policy.conditions, event)) continue;

    // 触发反应
    await notifyAgent(policy.actor_agent, {
      type: policy.reaction_action,
      triggered_by: event
    });

    await updateLastReaction(policy.id);
  }
}
```

---

## 6. 仪表盘 (Next.js)

```typescript
// app/dashboard/page.tsx

export default function Dashboard() {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      {/* 智能体状态 */}
      <AgentStatusCard />
      
      {/* 提案队列 */}
      <ProposalQueue />
      
      {/* 任务进度 */}
      <TaskProgress />
      
      {/* 实时对话 */}
      <RoundTableChat />
      
      {/* 内容流水线 */}
      <ContentPipeline />
      
      {/* 系统健康 */}
      <SystemHealth />
    </div>
  );
}
```

---

## 7. 实施步骤

### Phase 1: 基础设施 (1-2天)

1. **设置 Supabase 数据库**
   ```bash
   # 创建项目
   npx supabase init
   npx supabase db push
   ```

2. **部署 Vercel 前端**
   ```bash
   cd dashboard
   vercel deploy
   ```

3. **配置 OpenClaw**
   ```bash
   # 复制配置
   cp agents.json ~/.openclaw/
   
   # 创建子代理工作区
   mkdir -p ~/.openclaw/workspace/agents/{minion,sage,scout,quill,xalt,observer}
   ```

### Phase 2: 核心功能 (2-3天)

1. 实现 `createProposalAndMaybeAutoApprove`
2. 实现 `recoverStaleSteps`
3. 设置触发器和反应矩阵
4. 配置 Cron 任务

### Phase 3: 测试优化 (持续)

1. 模拟圆桌讨论
2. 测试冲突解决
3. 调整配额和冷却时间
4. 优化提示词

---

## 8. 关键原则

| 原则 | 说明 |
|------|------|
| **单一执行者** | VPS (OpenClaw) 执行，Vercel 只做控制平面 |
| **单一入口** | 所有提案必须经过 `createProposalAndMaybeAutoApprove` |
| **门禁机制** | 配额检查在入口处，避免无效任务 |
| **模型差异化** | 6个智能体用不同模型，避免"克隆人" |
| **自愈机制** | Observer 定期检查并恢复卡住的任务 |
| **概率反应** | 反应矩阵用概率，更像真实团队 |

---

## 9. 常见问题

### Q: 智能体吵架怎么办？
A: 设计让 Minion 在冲突时介入，或设置最大讨论轮数。

### Q: 任务一直失败？
A: Observer 会检测并上报，Minion 决定是否重试或调整策略。

### Q: 配额用完还在生成任务？
A: 确保配额检查在 `createProposalAndMaybeAutoApprove` 入口处。

### Q: 如何让智能体有个性？
A: 每个用不同模型 + 独特的 system_prompt + 不同的表达风格。

---

*配置文档版本: 1.0*
*最后更新: 2026-02-26*
