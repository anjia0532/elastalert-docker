# elastalert-docker

elastalert docker images , this image include Wechat enterprise alerter plugin and Dingtalk alerter plugin
> elastalert docker 镜像 并且开箱既用的集成了 微信企业号报警插件 和 钉钉报警插件(基于钉钉群机器人的webhook,支持签名安全认证，支持text和markdown格式)


## Features(特性)

- Making everything available using environment variables. (通过环境变量进行构建和配置)

- Integration with the following external services via environment variables: (通过环境变量进行外部服务集成)
  * E-mail (General SMTP) (SMTP方式的email)
  * Exotel
  * Gitter
  * HipChat
  * JIRA
  * OpsGenie
  * PagerDuty
  * Slack
  * Telegram
  * Twilio
  * VictorOps
  * **Wechat** (微信企业号)
  * **Dingtalk** (钉钉群机器人)

- NTP syncrhonization and support change timezone. (同步NTP同步时间，并且支持修改时区)

- Startup check and install enhancement's and alerter's dependencies. (启动时检查和安装增强器和报警器的依赖pip包)

- Offset @timestamp to local time(Use timezone) (支持根据本地时区修改 @timestamp)

## Usage(使用)

```bash
docker run -e"ELASTICSEARCH_HOST=es-host" \
    -e"CONTAINER_TIMEZONE=Asia/Shanghai"  \
    -e"TZ=Asia/Shanghai" \
    -e"ELASTALERT_DINGTALK_ACCESS_TOKEN=xxx" \
    -e"ELASTALERT_DINGTALK_SECURITY_TYPE=sign" \
    -e"ELASTALERT_DINGTALK_SECRET=xxx" \
    anjia0532/elastalert-docker:v0.2.4
```

## demo rules(示例rules)
```yaml
name: log-error
type: frequency
index: logstash-*
num_events: 20
timeframe:
    minutes: 5
filter:
- query:
    query_string:
      query: "level:ERROR"
      
compare_key:
- app_name
query_key:
- app_name

# 告警抑制
# 5 分钟内相同的报警不会重复发送
realert:
  minutes: 5

exponential_realert:
# 指数级扩大 realert 时间，中间如果有报警，
# 则按照 5 -> 10 -> 20 -> 40 -> 60 不断增大报警时间到制定的最大时间，
# 如果之后报警减少，则会慢慢恢复原始 realert 时间
exponential_realert:
  hours: 1

alert:
- "elastalert_modules.dingtalk_alert.DingTalkAlerter"
#- "elastalert_modules.wechat_qiye_alert.WeChatAlerter"

match_enhancements:
- "elastalert_enhancements.TimeEnhancement.TimeEnhancement"

alert_text_type: alert_text_only
alert_text: |
  从 {} 到 {} 产生了 {} 次 错误日志

  时间: {}

  模块: {}

  内容: {}

  堆栈: `{}`

alert_text_args:
  - local_starttime
  - local_endtime
  - num_hits
  - local_time
  - app_name
  - message
  - stack_trace
```

## Environment Variables(环境变量)

### Set at buildtime(构建时设置的变量)

These variables are set during the Docker build, and are generally necessary for running core functionality of Elastalert.

> 在构建镜像时设置的环境变量，是运行Elastalert所必须的


| Env var | Elastalert config var | Default | Description |
| :--- | :--- | :--- | :--- |
| ELASTALERT_HOME | N/A | `/opt/elastalert` | Place Elastalert home here |
| SET_CONTAINER_TIMEZONE | N/A | `True` | Whether or not to set the container timezone to `${CONTAINER_TIMEZONE}` |
| CONTAINER_TIMEZONE | N/A | `Etc/UTC` | Container timezone value |
| ELASTALERT_RULES_DIRECTORY | N/A | `${ELASTALERT_HOME}/rules` | Folder where Elastalert scans for rules |
| ELASTALERT_PLUGIN_DIRECTORY | N/A | `${ELASTALERT_HOME}/elastalert_modules` | Folder where Elastalert scans for alerters |
| ELASTALERT_ENHANCEMENT_DIRECTORY | N/A | `${ELASTALERT_HOME}/elastalert_enhancements` | Folder where Elastalert scans for enhancements |
| ELASTALERT_CONFIG | N/A | `${ELASTALERT_HOME}/config.yaml` | Name and location of the config file referenced by `docker-entrypoint.sh` to start the Python daemon |
| ELASTALERT_INDEX | `writeback_index` | `elastalert_status` | Name of the Elastalert index in your Elasticsearch cluster |
| ELASTALERT_SYSTEM_GROUP | N/A | `elastalert` | Name of the user running Elastalert; used for the daemon and folder permissions |
| ELASTALERT_SYSTEM_USER | N/A | `elastalert` | Name of the group running Elastalert; used for the daemon and folder permissions |
| ELASTALERT_VERSION | N/A | `0.1.29` | Version of Elastalert to install from `pip` |
| ELASTICSEARCH_HOST | `es_host` | `elasticsearch` | Desc |
| ELASTICSEARCH_PORT | `es_port` | `9200` | Desc |
| ELASTICSEARCH_USE_SSL | `use_ssl` | `False` | Connect with TLS to Elasticsearch |
| ELASTICSEARCH_VERIFY_CERTS | `verify_certs` | `False` | Use SSL authentication with client certificates |

### Set at runtime(启动时设置)

These variables are settings available in the Elastalert configuration file. Most of these settings apply to third-party integrations (JIRA, OpsGenie, etc), or are things documented here: [Elastalert common configuration options](https://elastalert.readthedocs.io/en/latest/ruletypes.html#common-configuration-options)

> 这些环境变量都是Elastalert 配置文件所需的，主要是[通用配置](https://elastalert.readthedocs.io/en/latest/ruletypes.html#common-configuration-options)和三方集成配置(Wechat,dingtalk等)

#### common configuration options(常用配置)

| Env var | Elastalert config var | Default | Description |
| :--- | :--- | :--- | :--- |
| ELASTALERT_RUN_EVERY | `run_every: => minutes:` | `3` | Number of minutes to wait before re-checking Elastalert rules. Currently only available as values in minutes |
| ELASTALERT_BUFFER_TIME | `buffer_time: => minutes:` | `45` | ElastAlert will buffer results from the most recent period of time, in case some log sources are not in real time
| ELASTALERT_AWS_REGION | `aws_region`| No default set |  |
| ELASTICSEARCH_URL_PREFIX | `es_url_prefix`| No default set |  |
| ELASTICSEARCH_SEND_GET_BODY_AS | `es_send_get_body_as`| No default set |  |
| ELASTALERT_TIME_LIMIT | `alert_time_limit: => minutes:`| `5` | If an alert fails for some reason, ElastAlert will retry sending the alert until this time period has elapsed |
| ELASTALERT_DISABLE_RULES_ON_ERROR | `disable_rules_on_error: => Bool`| `True` | If true, ElastAlert will disable rules which throw uncaught (not EAException) exceptions |
| ELASTALERT_MATCH_ENHANCEMENTS | `match_enhancements: => array` | No Default set |  A list of enhancement modules to use with this rule | 
| ELASTALERT_RUN_ENHANCEMENTS_FIRST | `run_enhancements_first: => Bool` | False | If set to true, enhancements will be run as soon as a match is found |
| ELASTICSEARCH_CA_CERTS | `ca_certs`| No default set |  |
| ELASTICSEARCH_CLIENT_CERT | `client_cert`| No default set |  |
| ELASTICSEARCH_CLIENT_KEY | `client_key`| No default set |  |
| ELASTICSEARCH_PASSWORD | `es_password`| No default set |  |
| ELASTICSEARCH_USER | `es_username`| No default set |  |

#### third-party integrations(三方集成)

| Env var | Elastalert config var | Default | Description |
| :--- | :--- | :--- | :--- |
| wechat(微信企业号) | | | |
| ELASTALERT_WECHAT_CORP_ID | `wechat_corp_id`| No default set | corp id |
| ELASTALERT_WECHAT_SECRET | `wechat_secret`| No default set | corp secret |
| ELASTALERT_WECHAT_AGENT_ID | `wechat_agent_id`| No default set | agent id |
| ELASTALERT_WECHAT_PARTY_ID | `wechat_party_id`| No default set | party id (party1,party2...) |
| ELASTALERT_WECHAT_USER_ID | `wechat_user_id`| No default set | user id (user1,user2,user3...) |
| ELASTALERT_WECHAT_TAG_ID | `wechat_tag_id`| No default set | tag id(tag1,tag2,tag3...) |
| dingtalk(钉钉群机器人) | | | |
| ELASTALERT_DINGTALK_ACCESS_TOKEN | `dingtalk_access_token`| No default set | dingtalk access token |
| ELASTALERT_DINGTALK_SECURITY_TYPE | `dingtalk_security_type`| sign | sign/keyword/whitelist |
| ELASTALERT_DINGTALK_SECRET | `dingtalk_secret`| No default set | if ELASTALERT_DINGTALK_SECURITY_TYPE ==sign, must be not null |
| ELASTALERT_DINGTALK_AT_MOBILES | `dingtalk_at_mobiles`| No default set | phone's array to @someone |
| ELASTALERT_DINGTALK_AT_ALL | `dingtalk_at_all`| False | @all or not |
| ELASTALERT_DINGTALK_MSGTYPE | `dingtalk_msgtype`| text | text/markdown |
| E-mail| | | |
| ELASTALERT_EMAIL | `email`| No default set |  |
| ELASTALERT_EMAIL_REPLY_TO | `email_reply_to`| No default set |  |
| ELASTALERT_FROM_ADDR | `from_addr`| No default set |  |
| ELASTALERT_NOTIFY_EMAIL | `notify_email`| No default set |  |
| ELASTALERT_SMTP_HOST | `smtp_host`| No default set |  |
| exotel| | | |
| ELASTALERT_EXOTEL_ACCOUNT_SID | `exotel_account_sid`| No default set |  |
| ELASTALERT_EXOTEL_AUTH_TOKEN | `exotel_auth_token`| No default set |  |
| ELASTALERT_EXOTEL_FROM_NUMBER | `exotel_from_number`| No default set |  |
| ELASTALERT_EXOTEL_TO_NUMBER | `exotel_to_number`| No default set |  |
| gitter| | | |
| ELASTALERT_GITTER_MSG_LEVEL | `gitter_msg_level`| No default set |  |
| ELASTALERT_GITTER_PROXY | `gitter_proxy`| No default set |  |
| ELASTALERT_GITTER_WEBHOOK_URL | `gitter_webhook_url`| No default set |  |
| hipchat| | | |
| ELASTALERT_HIPCHAT_AUTH_TOKEN | `hipchat_auth_token`| No default set |  |
| ELASTALERT_HIPCHAT_DOMAIN | `hipchat_domain`| No default set |  |
| ELASTALERT_HIPCHAT_FROM | `hipchat_from`| No default set |  |
| ELASTALERT_HIPCHAT_IGNORE_SSL_ERRORS | `hipchat_ignore_ssl_errors`| No default set |  |
| ELASTALERT_HIPCHAT_NOTIFY | `hipchat_notify`| No default set |  |
| ELASTALERT_HIPCHAT_ROOM_ID | `hipchat_room_id`| No default set |  |
| jira| | | |
| ELASTALERT_JIRA_ACCOUNT_FILE | `jira_account_file`| No default set |  |
| ELASTALERT_JIRA_ASSIGNEE | `jira_assignee`| No default set |  |
| ELASTALERT_JIRA_BUMP_IN_STATUSES | `jira_bump_in_statuses`| No default set |  |
| ELASTALERT_JIRA_BUMP_NOT_IN_STATUSES | `jira_bump_not_in_statuses`| No default set |  |
| ELASTALERT_JIRA_BUMP_TICKETS | `jira_bump_tickets`| No default set |  |
| ELASTALERT_JIRA_COMPONENT | `jira_component`| No default set |  |
| ELASTALERT_JIRA_COMPONENTS | `jira_components`| No default set |  |
| ELASTALERT_JIRA_ISSUETYPE | `jira_issuetype`| No default set |  |
| ELASTALERT_JIRA_LABEL | `jira_label`| No default set |  |
| ELASTALERT_JIRA_LABELS | `jira_labels`| No default set |  |
| ELASTALERT_JIRA_MAX_AGE | `jira_max_age`| No default set |  |
| ELASTALERT_JIRA_PROJECT | `jira_project`| No default set |  |
| ELASTALERT_JIRA_SERVER | `jira_server`| No default set |  |
| ELASTALERT_JIRA_WATCHERS | `jira_watchers`| No default set |  |
| opsgenie| | | |
| ELASTALERT_OPSGENIE_ACCOUNT | `opsgenie_account`| No default set |  |
| ELASTALERT_OPSGENIE_ADDR | `opsgenie_addr`| No default set |  |
| ELASTALERT_OPSGENIE_ALIAS | `opsgenie_alias`| No default set |  |
| ELASTALERT_OPSGENIE_KEY | `opsgenie_key`| No default set |  |
| ELASTALERT_OPSGENIE_MESSAGE | `opsgenie_message`| No default set |  |
| ELASTALERT_OPSGENIE_PROXY | `opsgenie_proxy`| No default set |  |
| ELASTALERT_OPSGENIE_RECIPIENTS | `opsgenie_recipients`| No default set |  |
| ELASTALERT_OPSGENIE_TAGS | `opsgenie_tags`| No default set |  |
| ELASTALERT_OPSGENIE_TEAMS | `opsgenie_teams`| No default set |  |
| pagerduty| | | |
| ELASTALERT_PAGERDUTY_CLIENT_NAME | `pagerduty_client_name`| No default set |  |
| ELASTALERT_PAGERDUTY_EVENT_TYPE | `pagerduty_event_type`| No default set |  |
| ELASTALERT_PAGERDUTY_SERVICE_KEY | `pagerduty_service_key`| No default set |  |
| slack| | | |
| ELASTALERT_SLACK_EMOJI_OVERRIDE | `slack_emoji_override`| No default set |  |
| ELASTALERT_SLACK_ICON_URL_OVERRIDE | `slack_icon_url_override`| No default set |  |
| ELASTALERT_SLACK_MSG_COLOR | `slack_msg_color`| No default set |  |
| ELASTALERT_SLACK_PARSE_OVERRIDE | `slack_parse_override`| No default set |  |
| ELASTALERT_SLACK_TEXT_STRING | `slack_text_string`| No default set |  |
| ELASTALERT_SLACK_USERNAME_OVERRIDE | `slack_username_override`| No default set |  |
| ELASTALERT_SLACK_WEBHOOK_URL | `slack_webhook_url`| No default set |  |
| telegram| | | |
| ELASTALERT_TELEGRAM_API_URL | `telegram_api_url`| No default set |  |
| ELASTALERT_TELEGRAM_BOT_TOKEN | `telegram_bot_token`| No default set |  |
| ELASTALERT_TELEGRAM_ROOM_ID | `telegram_room_id`| No default set |  |
| twilio| | | |
| ELASTALERT_TWILIO_ACCOUNT_SID | `twilio_account_sid`| No default set |  |
| ELASTALERT_TWILIO_AUTH_TOKEN | `twilio_auth_token`| No default set |  |
| ELASTALERT_TWILIO_FROM_NUMBER | `twilio_from_number`| No default set |  |
| ELASTALERT_TWILIO_TO_NUMBER | `twilio_to_number`| No default set |  |
| victorops| | | |
| ELASTALERT_VICTOROPS_API_KEY | `victorops_api_key`| No default set |  |
| ELASTALERT_VICTOROPS_ENTITY_DISPLAY_NAME | `victorops_entity_display_name`| No default set |  |
| ELASTALERT_VICTOROPS_MESSAGE_TYPE | `victorops_message_type`| No default set |  |
| ELASTALERT_VICTOROPS_ROUTING_KEY | `victorops_routing_key`| No default set |  |

## Build(构建)

```bash
git clone https://github.com/anjia0532/elastalert-docker.git

cd elastalert-docker

docker build . -t anjia0532/elastalert-docker:v0.2.4 \ 
    [-t anjia0532/elastalert-docker:latest] [--build-arg ELASTALERT_VERSION=0.2.4] \
    [--build-arg MIRROR=true --build-arg ALPINE_HOST="mirrors.aliyun.com" --build-arg PIP_MIRROR="https://mirrors.aliyun.com/pypi/simple/"] 

```
**Note:**
- `[]`:  means optional
- ELASTALERT_VERSION: elastalert's version (ref https://github.com/Yelp/elastalert/releases) like `v0.2.4` , `v0.2.3` ...
- MIRROR: Whether to use alpine's  mirror and pip's mirror (True/False) , **when u switch true of this options, ALPINE_HOST(default mirrors.aliyun.com) and PIP_MIRROR(default is https://mirrors.aliyun.com/pypi/simple/) must be required**
- ALPINE_HOST: alpine's mirror default is mirrors.aliyun.com
- PIP_MIRROR: pip's mirror default is https://mirrors.aliyun.com/pypi/simple/

> **注意:**
> - `[]`:  意味着可选
> - ELASTALERT_VERSION: 是elastalert的版本，详见 https://github.com/Yelp/elastalert/releases ，一般是 v0.2.4 v0.2.3 这样子
> - MIRROR: 是bool值，构建时是否启用加速器，如果true则启用， **如果设置成true，ALPINE_HOST(默认mirrors.aliyun.com) 和 PIP_MIRROR(默认https://mirrors.aliyun.com/pypi/simple/) 必须不能为空，为空则使用默认值**
> - ALPINE_HOST: alpine 加速器地址，默认是阿里云 mirrors.aliyun.com
> - PIP_MIRROR: pip 加速器地址，默认是阿里云 https://mirrors.aliyun.com/pypi/simple/

## Thanks(鸣谢)

 - elastalert part : Much of this repositiory was based off of the [sc250024/docker-elastalert](https://github.com/sc250024/docker-elastalert)
 - alerter part :  Much of plugins(alerter and enhancements) was based off my repo [anjia0532/elastalert-wechat-plugin](https://github.com/anjia0532/elastalert-wechat-plugin)

 > - elastalert部分: 大多是基于 [sc250024/docker-elastalert](https://github.com/sc250024/docker-elastalert) 的项目，我从中学到了很多。
 > - 报警器部分: 报警器和增强器部分主要基于我另外一个项目 [anjia0532/elastalert-wechat-plugin](https://github.com/anjia0532/elastalert-wechat-plugin)


## Feedback(反馈)

welcome to [commit new issues](https://github.com/anjia0532/elastalert-docker/issues/new) 

> 有问题的话欢迎提交 [新的 issues](https://github.com/anjia0532/elastalert-docker/issues/new) 来向我反馈


## Copyright and License(版权和授权信息)

This module is licensed under the BSD license.

Copyright (C) 2020-, by AnJia anjia0532@gmail.com.

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
