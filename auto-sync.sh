#!/bin/bash
# OpenClaw 工作区自动同步脚本
# 用法: ./auto-sync.sh [提交信息]

WORKSPACE="/root/.openclaw/workspace"
COMMIT_MSG="${1:-自动同步: $(date '+%Y-%m-%d %H:%M')}"

cd "$WORKSPACE" || exit 1

# 检查是否有变更
if git diff --quiet && git diff --cached --quiet; then
    echo "✓ 无变更需要同步"
    exit 0
fi

# 添加所有变更
git add -A

# 提交
git commit -m "$COMMIT_MSG"

# 推送到GitHub
if git push origin master; then
    echo "✅ 同步成功: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "📦 提交信息: $COMMIT_MSG"
else
    echo "❌ 同步失败"
    exit 1
fi
