
## enhancement's Folder 


## Install dependencies (安装依赖pip包)

- touch requirements.txt (在本目录创建 requirements.txt 文件)
- write packagename to requirements.txt (录入需要安装的应用名)
- restart elastalert (然后重启Elastalert即可)

## TimeEnhancement.py (修改时间时区)

- set env `SET_CONTAINER_TIMEZONE=True` and `CONTAINER_TIMEZONE=Asia/Shanghai`(default is `Etc/UTC`) (启动时设置环境变量 `SET_CONTAINER_TIMEZONE=true` `CONTAINER_TIMEZONE=你的时区`，比如东八区 `Asia/Shanghai`,默认是`UTC`，格林尼治时间)
- set env `ELASTALERT_RUN_ENHANCEMENTS_FIRST=True` and `ELASTALERT_MATCH_ENHANCEMENTS=["elastalert_enhancements.TimeEnhancement"]` (启动时设置环境变量 `ELASTALERT_RUN_ENHANCEMENTS_FIRST=true` 和 `ELASTALERT_MATCH_ENHANCEMENTS=["elastalert_enhancements.TimeEnhancement"]` )
- use `local_time`,`local_starttime`,`local_endtime` ( `local_time` 是 `@timestamp` 转化成本地时间的字段名, `local_starttime` 本地化开始时间，`local_endtime` 本地化结束时间)

### Usege(使用)
```yaml
# ...
alert_text_type: alert_text_only
alert_text: |
  more than {} time alerts between {} and {} 
  datetime: {}
  app_name: {}
  message: {}

alert_text_args:
  - num_matches
  - local_starttime
  - local_endtime
  - local_time
  - app_name
  - message
# ...