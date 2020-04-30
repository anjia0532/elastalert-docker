from elastalert.util import pretty_ts
from elastalert.enhancements import BaseEnhancement

class TimeEnhancement(BaseEnhancement):
    def __init__(self, rule):
        self.local_time = self.rule.get('local_time_feild', 'local_time')
    def process(self, match):
        match[self.local_time] = pretty_ts(match['@timestamp'])