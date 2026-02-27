#!/bin/bash
# memlog.sh — 自动时间戳的日志追加工具
# 用法: memlog.sh "Title" "Content body"

set -euo pipefail

WORKSPACE="${WORKSPACE:-/root/.openclaw/workspace}"
MEMORY_DIR="${WORKSPACE}/memory"
TODAY=$(TZ=Asia/Shanghai date +%Y-%m-%d)
NOW=$(TZ=Asia/Shanghai date +%H:%M)
FILE="$MEMORY_DIR/$TODAY.md"

TITLE="${1:?Usage: memlog.sh \"Title\" \"Body\"}"
BODY="${2:-}"

# 如果文件不存在，创建带日期标题的文件
if [[ ! -f "$FILE" ]]; then
    printf "# %s\n\n" "$TODAY" > "$FILE"
fi

# 追加带时间戳的条目
{
    printf "### %s — %s\n\n" "$NOW" "$TITLE"
    [[ -n "$BODY" ]] && printf "%s\n\n" "$BODY"
} >> "$FILE"

echo "✓ Logged to $TODAY.md at $NOW"
