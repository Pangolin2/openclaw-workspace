---
title: "6551 MCP + SKILL 使用指南"
date: 2026-02-26
category: tools
priority: 🔴
status: active
tags: [6551, MCP, SKILL, X, Twitter, news, openclaw]
---

# 6551 MCP + SKILL 使用指南

> 学习使用6551的X+全网新闻源MCP+SKILL，实现24小时新闻监控

**项目地址**:
- GitHub: https://github.com/6551Team/opentwitter-mcp
- 官网: https://6551.io/mcp
- SKILL: https://clawhub.com/infra403/opentwitter

---

## 一、什么是6551 MCP？

### 1.1 项目介绍

6551Team开源了**X(Twitter)数据 + 全网50+实时新闻源 + 链上数据**的MCP Server，无需配置X API密钥即可使用。

**核心能力**:
- ✅ 直接连接X数据（用户资料、推文搜索、关注事件）
- ✅ 全网50+实时新闻源监控
- ✅ 链上数据分析
- ✅ 24小时自动监控、分析、触发提醒
- ✅ 无需X API密钥

### 1.2 MCP是什么？

**MCP (Model Context Protocol)** 是Anthropic推出的开放协议，用于标准化AI助手与外部数据源的连接。

**简单说**: MCP让AI助手可以"插件化"地接入各种数据源和工具。

---

## 二、功能特性

### 2.1 X/Twitter数据功能

| 功能 | 说明 | 使用场景 |
|------|------|---------|
| **用户资料查询** | 获取任意X用户资料 | KOL分析、竞品监控 |
| **推文搜索** | 关键词、hashtag搜索 | 热点追踪、舆情监控 |
| **用户推文** | 获取指定用户最近推文 | 内容分析、趋势判断 |
| **关注事件** | 新增/取消关注监控 | KOL动向追踪 |
| **删推监控** | 监控删除的推文 | 舆情分析、危机预警 |
| **KOL追踪** | 关键意见领袖关注分析 | 影响力分析 |

### 2.2 新闻源功能

- 全网50+实时新闻源
- AI自动评级和分类
- 加密货币新闻专项
- 自定义关键词监控

### 2.3 8个核心工具

| 工具名 | 功能 |
|--------|------|
| `get_twitter_user` | 通过用户名获取用户资料 |
| `get_twitter_user_by_id` | 通过ID获取用户资料 |
| `get_twitter_user_tweets` | 获取用户最近推文 |
| `search_twitter` | 基础推文搜索 |
| `search_twitter_advanced` | 高级搜索（多条件筛选） |
| `get_twitter_follower_events` | 获取关注/取关事件 |
| `get_twitter_deleted_tweets` | 获取已删除推文 |
| `get_twitter_kol_followers` | 获取KOL关注者分析 |

---

## 三、安装部署

### 3.1 前置要求

- Python 3.10+
- uv (Python包管理器)
- Git

### 3.2 安装步骤

#### 步骤1: 获取API Token

1. 访问 https://6551.io/mcp
2. 注册/登录账号
3. 获取你的API Token

#### 步骤2: 克隆项目

```bash
git clone https://github.com/6551Team/opentwitter-mcp.git
cd opentwitter-mcp
```

#### 步骤3: 安装依赖

```bash
# 使用uv安装
uv sync

# 或使用pip
pip install -e .
```

#### 步骤4: 配置Token

**方式1: 环境变量（推荐）**

```bash
# macOS/Linux
export TWITTER_TOKEN="your-token-here"

# Windows PowerShell
$env:TWITTER_TOKEN="your-token-here"
```

**方式2: 配置文件**

创建 `config.json`:
```json
{
  "api_base_url": "https://ai.6551.io",
  "api_token": "your-token-here",
  "max_rows": 100
}
```

#### 步骤5: 运行测试

```bash
uv run twitter-mcp
```

---

## 四、OpenClaw SKILL安装

### 4.1 安装方法

```bash
# 复制SKILL到OpenClaw技能目录
export TWITTER_TOKEN="your-token-here"
cp -r openclaw-skill/opentwitter ~/.openclaw/skills/
```

### 4.2 使用方法

安装后，你可以直接对我说：

```
"查看@elonmusk的Twitter资料"
→ 获取用户详细信息

"Vitalik最近发了什么推文"
→ 获取用户最近推文

"搜索Bitcoin相关的推文"
→ 关键词搜索

"找一下#crypto标签的热门推文"
→ Hashtag搜索

"查看点赞超过1000的ETH相关推文"
→ 高级搜索带互动筛选

"谁最近关注了@elonmusk"
→ 新增关注者

"@elonmusk删了哪些推文"
→ 删除推文监控
```

---

## 五、与其他MCP客户端集成

### 5.1 Claude Desktop

编辑配置文件：
- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "twitter": {
      "command": "uv",
      "args": ["--directory", "/path/to/opentwitter-mcp", "run", "twitter-mcp"],
      "env": {
        "TWITTER_TOKEN": "your-token-here"
      }
    }
  }
}
```

### 5.2 Cursor

编辑 `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "twitter": {
      "command": "uv",
      "args": ["--directory", "/path/to/opentwitter-mcp", "run", "twitter-mcp"],
      "env": {
        "TWITTER_TOKEN": "your-token-here"
      }
    }
  }
}
```

### 5.3 Claude Code

```bash
claude mcp add twitter \
  -e TWITTER_TOKEN=your-token-here \
  -- uv --directory /path/to/opentwitter-mcp run twitter-mcp
```

### 5.4 Windsurf

编辑 `~/.codeium/windsurf/mcp_config.json`:

```json
{
  "mcpServers": {
    "twitter": {
      "command": "uv",
      "args": ["--directory", "/path/to/opentwitter-mcp", "run", "twitter-mcp"],
      "env": {
        "TWITTER_TOKEN": "your-token-here"
      }
    }
  }
}
```

### 5.5 Cline (VS Code)

编辑 `cline_mcp_settings.json`:

```json
{
  "mcpServers": {
    "twitter": {
      "command": "uv",
      "args": ["--directory", "/path/to/opentwitter-mcp", "run", "twitter-mcp"],
      "env": {
        "TWITTER_TOKEN": "your-token-here"
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

---

## 六、使用示例

### 6.1 查询用户资料

```python
# 获取Elon Musk的资料
get_twitter_user(screenName="elonmusk")

# 返回示例
{
  "userId": "44196397",
  "screenName": "elonmusk",
  "name": "Elon Musk",
  "description": "...",
  "followersCount": 170000000,
  "friendsCount": 500,
  "statusesCount": 30000,
  "verified": true
}
```

### 6.2 搜索推文

```python
# 基础搜索
search_twitter(query="Bitcoin", maxResults=20)

# 高级搜索
search_twitter_advanced(
  query="ETH",
  minLikes=1000,
  lang="en",
  maxResults=50
)
```

### 6.3 获取用户推文

```python
get_twitter_user_tweets(
  screenName="VitalikButerin",
  count=10
)
```

### 6.4 监控关注事件

```python
# 获取新增关注者
get_twitter_follower_events(
  screenName="elonmusk",
  eventType="follower",
  hours=24
)

# 获取取消关注者
get_twitter_follower_events(
  screenName="elonmusk",
  eventType="unfollower",
  hours=24
)
```

### 6.5 KOL分析

```python
# 分析哪些KOL关注了某用户
get_twitter_kol_followers(
  screenName="elonmusk",
  minFollowers=100000
)
```

---

## 七、24小时监控方案

### 7.1 监控配置

创建监控脚本 `monitor.py`:

```python
import schedule
import time
from twitter_mcp.tools import search_twitter_advanced

def check_hot_topics():
    """每小时检查热点"""
    results = search_twitter_advanced(
        query="Bitcoin OR Ethereum OR Crypto",
        minLikes=500,
        hours=1
    )
    # 分析并发送通知
    analyze_and_notify(results)

def track_kol():
    """追踪KOL动态"""
    # 监控指定KOL的新推文
    pass

# 设置定时任务
schedule.every(1).hours.do(check_hot_topics)
schedule.every(30).minutes.do(track_kol)

while True:
    schedule.run_pending()
    time.sleep(60)
```

### 7.2 Telegram提醒集成

```python
import requests

BOT_TOKEN = "your-bot-token"
CHAT_ID = "your-chat-id"

def send_telegram_alert(message):
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    payload = {
        "chat_id": CHAT_ID,
        "text": message,
        "parse_mode": "Markdown"
    }
    requests.post(url, json=payload)
```

### 7.3 关键词预警

```python
ALERT_KEYWORDS = ["监管", "禁令", "黑客", "漏洞", "暴跌"]

def monitor_alerts():
    tweets = search_twitter_advanced(
        query=" OR ".join(ALERT_KEYWORDS),
        minLikes=100,
        hours=1
    )
    
    for tweet in tweets:
        alert_msg = f"🚨 预警: {tweet['text'][:100]}..."
        send_telegram_alert(alert_msg)
```

---

## 八、实际应用场景

### 8.1 投资研究

- 监控加密货币KOL动态
- 追踪项目方官方账号
- 分析市场情绪
- 发现早期 Alpha 信息

### 8.2 品牌监控

- 监控品牌提及
- 追踪竞品动态
- 分析用户反馈
- 危机预警

### 8.3 舆情分析

- 热点事件追踪
- 情感分析
- 传播路径分析
- KOL影响力评估

### 8.4 内容创作

- 发现热门话题
- 追踪行业趋势
- 收集创作灵感
- 分析爆款内容

---

## 九、注意事项

### 9.1 使用限制

- API调用频率限制（根据Token等级）
- 单次查询最大返回条数（默认100）
- 部分功能可能需要高级Token

### 9.2 数据隐私

- 仅查询公开数据
- 不存储用户隐私信息
- 遵守X平台使用政策

### 9.3 合规使用

- 不用于垃圾信息发送
- 不用于恶意监控
- 遵守当地法律法规

---

## 十、故障排查

### 10.1 常见问题

**Q: Token失效怎么办？**
A: 访问 https://6551.io/mcp 重新获取

**Q: 查询返回空结果？**
A: 检查关键词是否正确，尝试扩大时间范围

**Q: 连接超时？**
A: 检查网络连接，确认6551服务状态

**Q: 权限不足？**
A: 确认Token等级，部分功能需要高级Token

### 10.2 安全建议

- 不要将Token硬编码在代码中
- 使用环境变量或配置文件
- 定期轮换Token
- 不要将Token提交到Git

---

## 十一、相关项目

- **opennews-mcp**: 加密货币新闻MCP Server
  - GitHub: https://github.com/6551-io/opennews-mcp
  - AI自动评级和分类

- **awesome-mcp-servers**: MCP Server合集
  - https://github.com/appcypher/awesome-mcp-servers

---

## 十二、总结

6551 MCP让AI助手轻松接入X数据和新闻源，**无需配置复杂的X API**，几分钟即可部署24小时监控系统。

**核心价值**:
- ✅ 零配置接入X数据
- ✅ 50+新闻源实时监控
- ✅ 8个强大分析工具
- ✅ 支持多种MCP客户端
- ✅ 开源免费

**下一步**: 获取Token，克隆项目，开始你的24小时监控！

---

*最后更新: 2026-02-26*  
*6551官网: https://6551.io*  
*GitHub: https://github.com/6551Team/opentwitter-mcp*
