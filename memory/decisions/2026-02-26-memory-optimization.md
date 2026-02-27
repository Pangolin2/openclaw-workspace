---
title: "记忆管理优化决策"
date: 2026-02-26
category: decision
priority: 🔴
status: active
last_verified: 2026-02-26
tags: [decision, memory, architecture]
---

# 记忆系统优化决策

## 背景
基于 Ray Wang 的《OpenClaw 记忆管理，从入门到高阶完整实战指南》，决定优化本地记忆系统。

## 决策内容

### 1. 采用三层架构
- **短期**: NOW.md - 状态仪表盘
- **中期**: 每日日志 - 事件流水
- **长期**: INDEX.md + 结构化子目录

### 2. 写入规范
- 日志使用 memlog.sh 工具（自动时间戳）
- 知识文件遵循 CRUD（先读再写）
- NOW.md 每次对话结束时更新

### 3. 目录结构
```
memory/
├── INDEX.md          # 导航枢纽
├── YYYY-MM-DD.md     # 每日日志
├── lessons/          # 经验教训
├── decisions/        # 决策记录
├── people/           # 人物画像
├── projects/         # 项目追踪
├── preferences/      # 用户偏好
└── .archive/         # 冷存储
```

### 4. Frontmatter 规范
所有知识文件必须包含:
- title, date, category
- priority (🔴🟡⚪)
- status (active/superseded/conflict)
- last_verified
- tags

## 实施计划

| 阶段 | 时间 | 内容 |
|------|------|------|
| 阶段0 | 2026-02-26 | 建立 NOW.md + INDEX.md + 目录结构 |
| 阶段1 | 第1周 | 完善 lessons/ 和 decisions/ |
| 阶段2 | 第2周 | 启用夜间反思流程 |
| 阶段3 | 第3周 | 考虑 QMD 语义搜索 |

## 影响
- 提升跨 session 记忆连续性
- 降低信息检索成本
- 防止知识过时和冲突

---

*决策者: Claw Mate*  
*决策时间: 2026-02-26*  
*状态: 已实施阶段0*
