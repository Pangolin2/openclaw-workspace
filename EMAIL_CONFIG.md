# 📧 邮件功能配置

## QQ 邮箱 SMTP 配置

| 配置项 | 值 |
|--------|-----|
| SMTP服务器 | smtp.qq.com |
| 端口 | 587 (STARTTLS) |
| 用户名 | 374354691@qq.com |
| 授权码 | hpicybcmezeecbab |

## 使用方法

### 1. Python 脚本
```bash
cd /root/.openclaw/workspace/tools
python3 send_email.py "收件人邮箱" "主题" "内容"
```

### 2. 在 Agent 中直接调用
我已经掌握了发送邮件的方法，可以直接帮你发送。

## 测试记录
- ✅ 2026-02-26 - 首次测试成功
- 服务器响应: 250 OK: queued as.

## 注意事项
- 每日发送限制：约 100-200 封
- 单次发送限制：最多 50 个收件人
- 建议间隔：每次发送间隔 3-5 秒

---
*配置时间: 2026-02-26*
