## alerter's Folder 

ref https://elastalert.readthedocs.io/en/latest/recipes/adding_alerts.html

## Install dependencies (安装依赖pip包)

- touch requirements.txt (在本目录创建 requirements.txt 文件)
- write packagename to requirements.txt (录入需要安装的应用名)
- restart elastalert (然后重启Elastalert即可)

## dingtalk_alert.py: 钉钉群机器人

xxx_rule.yaml

```yaml
## ...
alert:
- "elastalert_modules.dingtalk_alert.DingTalkAlerter"

dingtalk_access_token: 钉钉access_token
dingtalk_secret: 如果安全验证是签名模式需要带上 secret
dingtalk_at_mobiles: @的手机号
dingtalk_at_all: 是否@全部
dingtalk_msgtype: 仅支持text和markdown两种格式，默认是text
dingtalk_security_type: 如果是sign需要传入 secret

alert_text_type: alert_text_only
alert_text: |
  发生了 {} 次告警 
  时间: {}
  模块: {}
  内容: {}

alert_text_args:
  - num_matches
  - "@timestamp"
  - app_name
  - message
# ...
```

## wechat_qiye_alert.py: 微信企业号应用

xxx_rule.yaml

```yaml
## ...
alert:
- "elastalert_modules.wechat_qiye_alert.WeChatAlerter"
wechat_corp_id: #企业号id
wechat_secret: #secret
wechat_agent_id: #应用id
wechat_party_id: #部门id
wechat_user_id: #用户id，多人用 | 分割，全部用 @all
wechat_tag_id: #标签id

alert_text_type: alert_text_only
alert_text: |
  发生了 {} 次告警 
  时间: {}
  模块: {}
  内容: {}

alert_text_args:
  - num_matches
  - "@timestamp"
  - app_name
  - message
# ...
# ...
```