# TOOLS.md - 工具使用说明

> 本地环境特定的工具配置和使用说明

---

## 核心理念

记录环境特定的信息：
- 服务器地址、账号
- API密钥（不记录敏感值，只记录位置和获取方式）
- 具体的使用场景和示例
- 注意事项和常见问题

---

## 🔧 开发工具

### Python 脚本执行

**使用场景**: 运行数据分析、自动化脚本

**示例**:
```bash
# 运行邮件发送脚本
python3 tools/send_email.py "收件人" "主题" "内容"

# 运行日志记录
./tools/memlog.sh "标题" "内容"
```

**注意事项**:
- 使用 `python3` 而非 `python`
- 脚本位于 `tools/` 目录
- 先 `chmod +x` 赋予执行权限

### Git 操作

**常用命令**:
```bash
# 快速同步
cd /root/.openclaw/workspace && ./auto-sync.sh "提交信息"

# 手动提交
git add . && git commit -m "xxx" && git push

# 查看状态
git status && git log --oneline -5
```

**GitHub 仓库**:
- URL: https://github.com/Pangolin2/openclaw-workspace
- 分支: master
- 权限: 通过PAT认证（已配置在.git/config）

---

## 🌐 网络工具

### Web 搜索 (Brave Search)

**使用场景**: 快速查找信息、调研

**示例**:
```python
# 搜索股票信息
web_search(query="紫金矿业 2024年报", count=5)

# 搜索行业分析
web_search(query="小金属板块 2025 供需", count=10)
```

**配置**:
- API Key: 已配置为环境变量 `BRAVE_API_KEY`
- 无需每次调用时传入

**限制**:
- 每次最多返回10条结果
- 支持中文搜索

### Web 抓取 (Web Fetch)

**使用场景**: 获取网页内容、读取文章

**示例**:
```python
# 获取公司公告
web_fetch(url="https://xxx.com/announcement")

# 读取研报
web_fetch(url="https://pdf.xxx.com/report.pdf")
```

**限制**:
- 部分网站有反爬虫（如X/Twitter）
- 动态加载内容可能无法获取

### 浏览器自动化

**使用场景**: 需要登录态、复杂交互

**当前状态**: ⚠️ 网关限制，暂不可用

**备用方案**:
- 使用 web_fetch 获取静态内容
- 用户手动复制内容给我分析

---

## 📧 通信工具

### 邮件发送

**配置**:
- SMTP服务器: smtp.qq.com:587
- 账号: 374354691@qq.com
- 授权码: 已配置（见EMAIL_CONFIG.md）

**使用示例**:
```bash
# 命令行发送
python3 tools/send_email.py "haozhiliang@huawei.com" "主题" "内容"
```

**使用场景**:
- 发送凭证备份
- 发送分析报告
- 定期通知

### Telegram

**当前状态**: ⚠️ 网络受限，连接不稳定

**备用方案**:
- 优先使用当前对话界面
- 邮件作为备用通知渠道

---

## 🤖 AI 模型

### 模型切换

**查看当前模型**:
```
/session_status
```

**可用模型**:
- `moonshot/kimi-k2.5` (默认) - 综合能力强
- `deepseek/deepseek-reasoner` - 深度推理（当前不可用）
- `qwen-portal/coder-model` - 代码专用

**切换模型**:
```
/model deepseek/deepseek-reasoner
```

### 推理模式

**开启深度推理**:
```
/reasoning on
```

**适用场景**:
- 复杂分析任务
- 需要多步推理
- Researcher Agent模式

**关闭**:
```
/reasoning off
```

---

## 📊 投资研究工具

### 股票分析框架

**模板位置**:
- 个股分析: `memory/investing/stock/个股分析清单.md`
- 行业分析: `memory/investing/industry/行业分析模板.md`
- 宏观分析: `memory/investing/macro/宏观分析框架.md`

**使用流程**:
1. 使用 `web_search` 收集数据
2. 按照模板逐项分析
3. 写入 `memory/investing/stock/examples/`
4. 更新 `观察清单.md`

### 数据记录

**日志记录**:
```bash
./tools/memlog.sh "买入紫金矿业" "价格12.5元，理由：xxx"
```

**自动同步**:
```bash
./auto-sync.sh "更新投资日志"
```

---

## 📝 文档工具

### Markdown 编辑

**规范**:
- 使用 YAML frontmatter
- 标签格式: `#tag`
- 双向链接: `[[文档名]]`

**Obsidian 集成**:
- Vault路径: `/root/.openclaw/workspace`
- 配置已预置在 `.obsidian/`
- 支持图谱视图、双向链接

### 模板使用

**模板位置**: `templates/`

**可用模板**:
- `concept.md` - 概念卡片
- `moc.md` - 内容地图
- `daily-note.md` - 每日笔记

**使用方法**:
- Obsidian: `Ctrl+N` 选择模板
- 手动: 复制模板文件，修改内容

---

## 🗄️ 记忆系统

### 三层记忆架构

```
短期: NOW.md (覆写式)
中期: memory/YYYY-MM-DD.md (追加式)
长期: memory/INDEX.md + 子目录
```

### 快速记录

**今日日志**:
```bash
# 自动创建并追加
./tools/memlog.sh "标题" "内容"
```

**概念卡片**:
- 位置: `02-concepts/分类/概念名.md`
- 模板: `templates/concept.md`

### 知识检索

**L1 - 扫INDEX.md**:
- 快速定位知识类别

**L2 - 直接读取**:
- 已知路径时直接读取文件

**L3 - 搜索**:
- 使用 `memory_search` 语义搜索

---

## 🔐 安全配置

### 敏感信息存储

**位置**:
- 环境变量: `~/.bashrc`, `~/.profile`
- 配置文件: `~/.openclaw/.env`
- 不要提交到Git: 已配置 `.gitignore`

**已配置凭证**:
- GitHub PAT: `~/.git-credentials`
- Brave API Key: 环境变量
- QQ邮箱授权码: 已记录在配置中

### 安全提醒

⚠️ **永远不要**:
- 在对话中发送完整API Key
- 将密钥硬编码在代码中
- 将敏感文件提交到GitHub

✅ **正确做法**:
- 使用环境变量
- 使用配置文件（已.gitignore）
- 定期轮换密钥

---

## ⚠️ 常见问题和解决

### 问题1: web_search 报错 missing_brave_api_key

**原因**: 环境变量未生效

**解决**:
```bash
export BRAVE_API_KEY="your-key"
# 或重启session
```

### 问题2: git push 失败 403

**原因**: Token权限不足或过期

**解决**:
1. 检查token: `cat ~/.git-credentials`
2. 重新生成GitHub PAT (classic版本，勾选repo权限)
3. 更新token

### 问题3: browser 工具不可用

**原因**: 网关限制

**解决**:
- 使用 `web_fetch` 替代
- 或手动复制网页内容

### 问题4: Telegram 连接失败

**原因**: 网络限制

**解决**:
- 当前对话界面可用
- 或使用邮件通知

---

## 📚 相关文档

- `SKILL.md` - 技能使用指南（通用）
- `EMAIL_CONFIG.md` - 邮件配置详情
- `BACKUP.md` - 备份策略
- `OBSIDIAN.md` - Obsidian使用指南

---

*维护者: Main Agent*  
*更新频率: 有新工具时更新*  
*最后更新: 2026-02-26*
