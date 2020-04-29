# This is the folder that contains the rule yaml files
# Any .yaml file will be loaded as a rule
rules_folder: {{ default .Env.ELASTALERT_RULES_DIRECTORY "/opt/rules" }}

# How often ElastAlert will query Elasticsearch
# The unit can be anything from weeks to seconds
run_every:
  minutes: {{ default .Env.ELASTALERT_RUN_EVERY "3" }}

# ElastAlert will buffer results from the most recent
# period of time, in case some log sources are not in real time
buffer_time:
  minutes: {{ default .Env.ELASTALERT_BUFFER_TIME "45" }}

# The Elasticsearch hostname for metadata writeback
# Note that every rule can have its own Elasticsearch host
es_host: {{ .Env.ELASTICSEARCH_HOST }}

# The Elasticsearch port
es_port: {{ .Env.ELASTICSEARCH_PORT }}

{{ if .Env.ELASTALERT_AWS_REGION }}
# The AWS region to use. Set this when using AWS-managed elasticsearch
aws_region: {{ .Env.ELASTALERT_AWS_REGION }}
{{ end }}

{{ if .Env.ELASTICSEARCH_URL_PREFIX }}
# Optional URL prefix for Elasticsearch
es_url_prefix: {{ .Env.ELASTICSEARCH_URL_PREFIX }}
{{ end }}

# Connect with TLS to Elasticsearch
use_ssl: {{ default .Env.ELASTICSEARCH_USE_SSL "False" }}

{{ if .Env.ELASTICSEARCH_SEND_GET_BODY_AS }}
# GET request with body is the default option for Elasticsearch.
# If it fails for some reason, you can pass 'GET', 'POST' or 'source'.
# See http://elasticsearch-py.readthedocs.io/en/master/connection.html?highlight=send_get_body_as#transport
# for details
es_send_get_body_as: {{ .Env.ELASTICSEARCH_SEND_GET_BODY_AS }}
{{ end }}

# Option basic-auth username and password for Elasticsearch
{{ if .Env.ELASTICSEARCH_USER }}
es_username: {{ .Env.ELASTICSEARCH_USER }}
{{ end }}
{{ if .Env.ELASTICSEARCH_PASSWORD }}
es_password: {{ .Env.ELASTICSEARCH_PASSWORD }}
{{ end }}


# Use SSL authentication with client certificates client_cert must be
# a pem file containing both cert and key for client
verify_certs: {{ default .Env.ELASTICSEARCH_VERIFY_CERTS "False" }}
{{ if .Env.ELASTICSEARCH_CA_CERTS }}
ca_certs: {{ .Env.ELASTICSEARCH_CA_CERTS }}
{{ end }}
{{ if .Env.ELASTICSEARCH_CLIENT_CERT }}
client_cert: {{ .Env.ELASTICSEARCH_CLIENT_CERT }}
{{ end }}
{{ if .Env.ELASTICSEARCH_CLIENT_KEY }}
client_key: {{ .Env.ELASTICSEARCH_CLIENT_KEY }}
{{ end }}

# The index on es_host which is used for metadata storage
# This can be a unmapped index, but it is recommended that you run
# elastalert-create-index to set a mapping
writeback_index: {{ default .Env.ELASTALERT_INDEX "elastalert_status" }}

# If an alert fails for some reason, ElastAlert will retry
# sending the alert until this time period has elapsed
alert_time_limit:
  minutes: {{ default .Env.ELASTALERT_TIME_LIMIT "5" }}

disable_rules_on_error: {{ default .Env.ELASTALERT_DISABLE_RULES_ON_ERROR "True" }}


{{ if .Env.ELASTALERT_EMAIL }}
# Email config
email: {{ .Env.ELASTALERT_EMAIL }}
{{ end }}
{{ if .Env.ELASTALERT_EMAIL_REPLY_TO }}
email_reply_to: {{ .Env.ELASTALERT_EMAIL_REPLY_TO }}
{{ end }}
{{ if .Env.ELASTALERT_FROM_ADDR }}
from_addr: {{ .Env.ELASTALERT_FROM_ADDR }}
{{ end }}
{{ if .Env.ELASTALERT_NOTIFY_EMAIL }}
notify_email: {{ .Env.ELASTALERT_NOTIFY_EMAIL }}
{{ end }}
{{ if .Env.ELASTALERT_SMTP_HOST }}
smtp_host: {{ .Env.ELASTALERT_SMTP_HOST }}
{{ end }}

{{ if .Env.ELASTALERT_EXOTEL_ACCOUNT_SID }}
# Exotel config
exotel_account_sid: {{ .Env.ELASTALERT_EXOTEL_ACCOUNT_SID }}
{{ end }}
{{ if .Env.ELASTALERT_EXOTEL_AUTH_TOKEN }}
exotel_auth_token: {{ .Env.ELASTALERT_EXOTEL_AUTH_TOKEN }}
{{ end }}
{{ if .Env.ELASTALERT_EXOTEL_FROM_NUMBER }}
exotel_from_number: {{ .Env.ELASTALERT_EXOTEL_FROM_NUMBER }}
{{ end }}
{{ if .Env.ELASTALERT_EXOTEL_TO_NUMBER }}
exotel_to_number: {{ .Env.ELASTALERT_EXOTEL_TO_NUMBER }}
{{ end }}

{{ if .Env.ELASTALERT_GITTER_WEBHOOK_URL }}
# Gitter config
gitter_webhook_url: {{ .Env.ELASTALERT_GITTER_WEBHOOK_URL }}
{{ end }}
{{ if .Env.ELASTALERT_GITTER_PROXY }}
gitter_proxy: {{ .Env.ELASTALERT_GITTER_PROXY }}
{{ end }}
{{ if .Env.ELASTALERT_GITTER_MSG_LEVEL }}
gitter_msg_level: {{ .Env.ELASTALERT_GITTER_MSG_LEVEL }}
{{ end }}

{{ if .Env.ELASTALERT_HIPCHAT_AUTH_TOKEN }}
# Hipchat config
hipchat_auth_token: {{ .Env.ELASTALERT_HIPCHAT_AUTH_TOKEN }}
{{ end }}
{{ if .Env.ELASTALERT_HIPCHAT_DOMAIN }}
hipchat_domain: {{ .Env.ELASTALERT_HIPCHAT_DOMAIN }}
{{ end }}
{{ if .Env.ELASTALERT_HIPCHAT_FROM }}
hipchat_from: {{ .Env.ELASTALERT_HIPCHAT_FROM }}
{{ end }}
{{ if .Env.ELASTALERT_HIPCHAT_IGNORE_SSL_ERRORS }}
hipchat_ignore_ssl_errors: {{ .Env.ELASTALERT_HIPCHAT_IGNORE_SSL_ERRORS }}
{{ end }}
{{ if .Env.ELASTALERT_HIPCHAT_NOTIFY }}
hipchat_notify: {{ .Env.ELASTALERT_HIPCHAT_NOTIFY }}
{{ end }}
{{ if .Env.ELASTALERT_HIPCHAT_ROOM_ID }}
hipchat_room_id: {{ .Env.ELASTALERT_HIPCHAT_ROOM_ID }}
{{ end }}

{{ if .Env.ELASTALERT_JIRA_ACCOUNT_FILE }}
# Jira config
jira_account_file: {{ .Env.ELASTALERT_JIRA_ACCOUNT_FILE }}
{{ end }}
{{ if .Env.ELASTALERT_JIRA_ASSIGNEE }}
jira_assignee: {{ .Env.ELASTALERT_JIRA_ASSIGNEE }}
{{ end }}
{{ if .Env.ELASTALERT_JIRA_BUMP_IN_STATUSES }}
jira_bump_in_statuses: {{ .Env.ELASTALERT_JIRA_BUMP_IN_STATUSES }}
{{ end }}
{{ if .Env.ELASTALERT_JIRA_BUMP_NOT_IN_STATUSES }}
jira_bump_not_in_statuses: {{ .Env.ELASTALERT_JIRA_BUMP_NOT_IN_STATUSES }}
{{ end }}
{{ if .Env.ELASTALERT_JIRA_BUMP_TICKETS }}
jira_bump_tickets: {{ .Env.ELASTALERT_JIRA_BUMP_TICKETS }}
{{ end }}
{{ if .Env.ELASTALERT_JIRA_COMPONENT }}
jira_component: {{ .Env.ELASTALERT_JIRA_COMPONENT }}
{{ end }}
{{ if .Env.ELASTALERT_JIRA_COMPONENTS }}
jira_components: {{ .Env.ELASTALERT_JIRA_COMPONENTS }}
{{ end }}
{{ if .Env.ELASTALERT_JIRA_ISSUETYPE }}
jira_issuetype: {{ .Env.ELASTALERT_JIRA_ISSUETYPE }}
{{ end }}
{{ if .Env.ELASTALERT_JIRA_LABEL }}
jira_label: {{ .Env.ELASTALERT_JIRA_LABEL }}
{{ end }}
{{ if .Env.ELASTALERT_JIRA_LABELS }}
jira_labels: {{ .Env.ELASTALERT_JIRA_LABELS }}
{{ end }}
{{ if .Env.ELASTALERT_JIRA_MAX_AGE }}
jira_max_age: {{ .Env.ELASTALERT_JIRA_MAX_AGE }}
{{ end }}
{{ if .Env.ELASTALERT_JIRA_PROJECT }}
jira_project: {{ .Env.ELASTALERT_JIRA_PROJECT }}
{{ end }}
{{ if .Env.ELASTALERT_JIRA_SERVER }}
jira_server: {{ .Env.ELASTALERT_JIRA_SERVER }}
{{ end }}
{{ if .Env.ELASTALERT_JIRA_WATCHERS }}
jira_watchers: {{ .Env.ELASTALERT_JIRA_WATCHERS }}
{{ end }}

{{ if .Env.ELASTALERT_OPSGENIE_ACCOUNT }}
# Opsgenie config
opsgenie_account: {{ .Env.ELASTALERT_OPSGENIE_ACCOUNT }}
{{ end }}
{{ if .Env.ELASTALERT_OPSGENIE_ADDR }}
opsgenie_addr: {{ .Env.ELASTALERT_OPSGENIE_ADDR }}
{{ end }}
{{ if .Env.ELASTALERT_OPSGENIE_ALIAS }}
opsgenie_alias: {{ .Env.ELASTALERT_OPSGENIE_ALIAS }}
{{ end }}
{{ if .Env.ELASTALERT_OPSGENIE_KEY }}
opsgenie_key: {{ .Env.ELASTALERT_OPSGENIE_KEY }}
{{ end }}
{{ if .Env.ELASTALERT_OPSGENIE_MESSAGE }}
opsgenie_message: {{ .Env.ELASTALERT_OPSGENIE_MESSAGE }}
{{ end }}
{{ if .Env.ELASTALERT_OPSGENIE_PROXY }}
opsgenie_proxy: {{ .Env.ELASTALERT_OPSGENIE_PROXY }}
{{ end }}
{{ if .Env.ELASTALERT_OPSGENIE_RECIPIENTS }}
opsgenie_recipients: {{ .Env.ELASTALERT_OPSGENIE_RECIPIENTS }}
{{ end }}
{{ if .Env.ELASTALERT_OPSGENIE_TAGS }}
opsgenie_tags: {{ .Env.ELASTALERT_OPSGENIE_TAGS }}
{{ end }}
{{ if .Env.ELASTALERT_OPSGENIE_TEAMS }}
opsgenie_teams: {{ .Env.ELASTALERT_OPSGENIE_TEAMS }}
{{ end }}

{{ if .Env.ELASTALERT_PAGERDUTY_CLIENT_NAME }}
# Pagerduty config
pagerduty_client_name: {{ .Env.ELASTALERT_PAGERDUTY_CLIENT_NAME }}
{{ end }}
{{ if .Env.ELASTALERT_PAGERDUTY_EVENT_TYPE }}
pagerduty_event_type: {{ .Env.ELASTALERT_PAGERDUTY_EVENT_TYPE }}
{{ end }}
{{ if .Env.ELASTALERT_PAGERDUTY_SERVICE_KEY }}
pagerduty_service_key: {{ .Env.ELASTALERT_PAGERDUTY_SERVICE_KEY }}
{{ end }}

{{ if .Env.ELASTALERT_SLACK_EMOJI_OVERRIDE }}
# Slack config
slack_emoji_override: {{ .Env.ELASTALERT_SLACK_EMOJI_OVERRIDE }}
{{ end }}
{{ if .Env.ELASTALERT_SLACK_ICON_URL_OVERRIDE }}
slack_icon_url_override: {{ .Env.ELASTALERT_SLACK_ICON_URL_OVERRIDE }}
{{ end }}
{{ if .Env.ELASTALERT_SLACK_MSG_COLOR }}
slack_msg_color: {{ .Env.ELASTALERT_SLACK_MSG_COLOR }}
{{ end }}
{{ if .Env.ELASTALERT_SLACK_PARSE_OVERRIDE }}
slack_parse_override: {{ .Env.ELASTALERT_SLACK_PARSE_OVERRIDE }}
{{ end }}
{{ if .Env.ELASTALERT_SLACK_TEXT_STRING }}
slack_text_string: {{ .Env.ELASTALERT_SLACK_TEXT_STRING }}
{{ end }}
{{ if .Env.ELASTALERT_SLACK_USERNAME_OVERRIDE }}
slack_username_override: {{ .Env.ELASTALERT_SLACK_USERNAME_OVERRIDE }}
{{ end }}
{{ if .Env.ELASTALERT_SLACK_WEBHOOK_URL }}
slack_webhook_url: {{ .Env.ELASTALERT_SLACK_WEBHOOK_URL }}
{{ end }}

{{ if .Env.ELASTALERT_TELEGRAM_BOT_TOKEN }}
# Telegram config
telegram_bot_token: {{ .Env.ELASTALERT_TELEGRAM_BOT_TOKEN }}
{{ end }}
{{ if .Env.ELASTALERT_TELEGRAM_ROOM_ID }}
telegram_room_id: {{ .Env.ELASTALERT_TELEGRAM_ROOM_ID }}
{{ end }}
{{ if .Env.ELASTALERT_TELEGRAM_API_URL }}
telegram_api_url: {{ .Env.ELASTALERT_TELEGRAM_API_URL }}
{{ end }}

{{ if .Env.ELASTALERT_TWILIO_ACCOUNT_SID }}
# Twilio config
twilio_account_sid: {{ .Env.ELASTALERT_TWILIO_ACCOUNT_SID }}
{{ end }}
{{ if .Env.ELASTALERT_TWILIO_AUTH_TOKEN }}
twilio_auth_token: {{ .Env.ELASTALERT_TWILIO_AUTH_TOKEN }}
{{ end }}
{{ if .Env.ELASTALERT_TWILIO_TO_NUMBER }}
twilio_to_number: {{ .Env.ELASTALERT_TWILIO_TO_NUMBER }}
{{ end }}
{{ if .Env.ELASTALERT_TWILIO_FROM_NUMBER }}
twilio_from_number: {{ .Env.ELASTALERT_TWILIO_FROM_NUMBER }}
{{ end }}

{{ if .Env.ELASTALERT_VICTOROPS_API_KEY }}
# VictorOps config
victorops_api_key: {{ .Env.ELASTALERT_VICTOROPS_API_KEY }}
{{ end }}
{{ if .Env.ELASTALERT_VICTOROPS_ROUTING_KEY }}
victorops_routing_key: {{ .Env.ELASTALERT_VICTOROPS_ROUTING_KEY }}
{{ end }}
{{ if .Env.ELASTALERT_VICTOROPS_MESSAGE_TYPE }}
victorops_message_type: {{ .Env.ELASTALERT_VICTOROPS_MESSAGE_TYPE }}
{{ end }}
{{ if .Env.ELASTALERT_VICTOROPS_ENTITY_DISPLAY_NAME }}
victorops_entity_display_name: {{ .Env.ELASTALERT_VICTOROPS_ENTITY_DISPLAY_NAME }}
{{ end }}

{{ if .Env.ELASTALERT_WECHAT_CORP_ID }}
# WeChat config
wechat_corp_id: {{ .Env.ELASTALERT_WECHAT_CORP_ID }}
{{ end }}
{{ if .Env.ELASTALERT_WECHAT_SECRET }}
wechat_secret: {{ .Env.ELASTALERT_WECHAT_SECRET }}
{{ end }}
{{ if .Env.ELASTALERT_WECHAT_AGENT_ID }}
wechat_agent_id: {{ .Env.ELASTALERT_WECHAT_AGENT_ID }}
{{ end }}
{{ if .Env.ELASTALERT_WECHAT_PARTY_ID }}
wechat_party_id: {{ .Env.ELASTALERT_WECHAT_PARTY_ID }}
{{ end }}
{{ if .Env.ELASTALERT_WECHAT_USER_ID }}
wechat_user_id: {{ .Env.ELASTALERT_WECHAT_USER_ID }}
{{ end }}
{{ if .Env.ELASTALERT_WECHAT_TAG_ID }}
wechat_tag_id: {{ .Env.ELASTALERT_WECHAT_TAG_ID }}
{{ end }}

{{ if .Env.ELASTALERT_DINGTALK_ACCESS_TOKEN }}
# Dingtalk config
dingtalk_access_token: {{ .Env.ELASTALERT_DINGTALK_ACCESS_TOKEN }}
{{ end }}
{{ if .Env.ELASTALERT_DINGTALK_SECRET }}
dingtalk_secret: {{ .Env.ELASTALERT_DINGTALK_SECRET }}
{{ end }}
{{ if .Env.ELASTALERT_DINGTALK_AT_MOBILES }}
dingtalk_at_mobiles: {{ .Env.ELASTALERT_DINGTALK_AT_MOBILES }}
{{ end }}
{{ if .Env.ELASTALERT_DINGTALK_AT_ALL }}
dingtalk_at_all: {{ .Env.ELASTALERT_DINGTALK_AT_ALL }}
{{ end }}
{{ if .Env.ELASTALERT_DINGTALK_MSGTYPE }}
dingtalk_msgtype: {{ .Env.ELASTALERT_DINGTALK_MSGTYPE }}
{{ end }}
{{ if .Env.ELASTALERT_DINGTALK_SECURITY_TYPE }}
dingtalk_security_type: {{ .Env.ELASTALERT_DINGTALK_SECURITY_TYPE }}
{{ end }}