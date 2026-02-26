#!/usr/bin/env python3
"""
邮件发送脚本 - OpenClaw 邮件工具
使用方法: python3 send_email.py "收件人" "主题" "内容"
"""

import smtplib
import sys
from email.mime.text import MIMEText
from email.header import Header

# QQ 邮箱配置
SMTP_SERVER = 'smtp.qq.com'
SMTP_PORT = 587
SENDER_EMAIL = '374354691@qq.com'
SENDER_PASSWORD = 'hpicybcmezeecbab'  # 授权码

def send_email(to_email, subject, content):
    """发送邮件"""
    try:
        # 创建邮件
        msg = MIMEText(content, 'plain', 'utf-8')
        msg['From'] = SENDER_EMAIL
        msg['To'] = to_email
        msg['Subject'] = Header(subject, 'utf-8')
        
        # 连接服务器并发送
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()  # 启用 TLS
        server.login(SENDER_EMAIL, SENDER_PASSWORD)
        server.sendmail(SENDER_EMAIL, [to_email], msg.as_string())
        server.quit()
        
        print(f"✅ 邮件发送成功！")
        print(f"   收件人: {to_email}")
        print(f"   主题: {subject}")
        return True
    except Exception as e:
        print(f"❌ 发送失败: {e}")
        return False

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print("用法: python3 send_email.py \"收件人邮箱\" \"邮件主题\" \"邮件内容\"")
        print("示例: python3 send_email.py \"xxx@qq.com\" \"测试\" \"这是一封测试邮件\"")
        sys.exit(1)
    
    to_email = sys.argv[1]
    subject = sys.argv[2]
    content = sys.argv[3]
    
    send_email(to_email, subject, content)
