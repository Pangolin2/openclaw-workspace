# 🔄 自动备份配置

## 自动同步脚本

**位置**: `auto-sync.sh`

### 使用方法

```bash
# 手动执行同步
./auto-sync.sh

# 带自定义提交信息
./auto-sync.sh "更新了培训课件"
```

### 自动定时同步（Cron）

编辑 crontab:
```bash
crontab -e
```

添加以下行实现自动同步:

```bash
# 每30分钟自动同步
*/30 * * * * cd /root/.openclaw/workspace && ./auto-sync.sh "定时同步 $(date '+\%Y-\%m-\%d \%H:\%M')" >> /tmp/openclaw-sync.log 2>&1

# 或者每小时同步一次
0 * * * * cd /root/.openclaw/workspace && ./auto-sync.sh "每小时自动备份" >> /tmp/openclaw-sync.log 2>&1

# 每天23:00同步并推送
0 23 * * * cd /root/.openclaw/workspace && ./auto-sync.sh "每日备份 $(date '+\%Y-\%m-\%d')" >> /tmp/openclaw-sync.log 2>&1
```

---

## 当前备份策略

### 实时备份（推荐）
- **触发时机**: 每次完成重要任务后
- **执行者**: 主控Agent自动执行
- **提交信息**: 描述性文字，如 "生成递归算法课件"

### 定时备份（可选）
- **频率**: 每30分钟或每小时
- **用途**: 防止意外丢失
- **日志**: `/tmp/openclaw-sync.log`

---

## 备份内容清单

### 必须备份 ✅
- [x] memory/ - 所有领域知识库
- [x] tools/ - 自定义工具脚本
- [x] templates/ - 模板文件
- [x] *.md - 配置文档

### 可选备份
- [ ] .obsidian/ - Obsidian配置（较大）
- [ ] attachments/ - 附件文件

---

## 状态检查

### 检查未同步的变更
```bash
cd /root/.openclaw/workspace
git status
```

### 查看同步日志
```bash
# 查看Git日志
git log --oneline -10

# 查看定时同步日志
tail -f /tmp/openclaw-sync.log
```

### 验证远程同步
```bash
git remote -v
git log origin/master --oneline -5
```

---

## 恢复操作

如本地数据丢失，从GitHub恢复:
```bash
git clone https://github.com/Pangolin2/openclaw-workspace.git
```

---

*备份策略版本: v1.0*  
*最后更新: 2026-02-26*  
*状态: 已激活*
