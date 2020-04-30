from elastalert.util import pretty_ts,ts_to_dt,dt_to_ts,lookup_es_key
from elastalert.enhancements import BaseEnhancement

class TimeEnhancement(BaseEnhancement):
    def process(self, match):
        self.local_time = self.rule.get('local_time_feild', 'local_time')
        self.ts_field = self.rule.get('timestamp_field', '@timestamp')
        match[self.local_time] = pretty_ts(match[self.ts_field])
        lt = self.rule.get('use_local_time')
        match_ts = lookup_es_key(match, self.ts_field)
        match["local_starttime"] = pretty_ts(dt_to_ts(ts_to_dt(match_ts) - self.rule['timeframe']), lt)
        match["local_endtime"] = pretty_ts(match_ts, lt)