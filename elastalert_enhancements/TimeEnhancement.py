from elastalert.util import pretty_ts,ts_to_dt,dt_to_ts,lookup_es_key
from elastalert.enhancements import BaseEnhancement

class TimeEnhancement(BaseEnhancement):
    def process(self, match):
        self.local_time = self.rule.get('local_time_feild', 'local_time')
        self.local_starttime = self.rule.get('local_starttime_feild', 'local_starttime')
        self.local_endtime = self.rule.get('local_endtime_feild', 'local_endtime')
        self.ts_field = self.rule.get('timestamp_field', '@timestamp')
        lt = self.rule.get('use_local_time',"False")

        match_ts = match[self.ts_field]
        match[self.local_time] = pretty_ts(match_ts, lt)
        match[self.local_starttime] = pretty_ts(dt_to_ts(ts_to_dt(match_ts) - self.rule['timeframe']), lt)
        match[self.local_endtime] = match[self.local_time]