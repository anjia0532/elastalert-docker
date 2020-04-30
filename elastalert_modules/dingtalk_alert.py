#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
https://ding-doc.dingtalk.com/doc#/serverapi2/qf2nxq
"""
import json
import datetime
from elastalert.alerts import Alerter, BasicMatchString
from requests.exceptions import RequestException
from elastalert.util import elastalert_logger,EAException
import requests

import time
import hmac
import hashlib
import base64
import urllib.parse

'''
###################################################################
# 钉钉群机器人推送消息                                              #
#                                                                 #
# 作者: AnJia <anjia0532@gmail.com>                               #
# 作者博客: http://anjia0532.github.io/                            #
# Github: https://github.com/anjia0532/elastalert-dingtalk-plugin #
#                                                                 #
###################################################################
'''
class DingTalkAlerter(Alerter):
    
    required_options = frozenset(['dingtalk_access_token'])

    def __init__(self, rule):
        super(DingTalkAlerter, self).__init__(rule)

        self.access_token = self.rule.get('dingtalk_access_token', '')          #钉钉access_token
        self.secret = self.rule.get('dingtalk_secret', '')                      #如果安全验证是签名模式需要带上 secret
        self.mobiles = self.rule.get('dingtalk_at_mobiles', [])                 #@的手机号

        self.at_all = self.rule.get('dingtalk_at_all', False)                   #是否@全部
        self.msgtype = self.rule.get('dingtalk_msgtype', 'text')                #仅支持text和markdown两种格式，默认是text
        self.security_type = self.rule.get('dingtalk_security_type', 'keyword') #如果是sign需要传入 secret

    def sign(self):
        timestamp = str(round(time.time() * 1000))
        secret_enc = self.secret.encode('utf-8')
        string_to_sign = '{}\n{}'.format(timestamp, self.secret)
        string_to_sign_enc = string_to_sign.encode('utf-8')
        hmac_code = hmac.new(secret_enc, string_to_sign_enc, digestmod=hashlib.sha256).digest()
        sign = urllib.parse.quote_plus(base64.b64encode(hmac_code))
        return "&timestamp={}&sign={}".format(timestamp, sign)

    def alert(self, matches):
        headers = {
            'content-type': 'application/json',
            'Accept': 'application/json;charset=utf-8',
        }

        body = self.create_alert_body(matches)

        data = {
            "at": {
                "atMobiles":self.mobiles, 
                "isAtAll": self.at_all,
            },
            "msgtype": self.msgtype,
        }
        if self.msgtype == 'markdown':
            content = {
                'title': self.create_title(matches),
                'text': body
            }
        else:
            content = {'content': body}
        
        data[self.msgtype] = content

        webhook_url = 'https://oapi.dingtalk.com/robot/send?access_token=%s' %( self.access_token)

        if self.security_type == "sign":
            webhook_url = '%s%s' %(webhook_url , self.sign())
        
        try:
            response = requests.post(webhook_url, data=json.dumps(data), headers=headers)
            response.raise_for_status()
        except RequestException as e:
            raise EAException("send message has error: %s" % e)

    def get_info(self):
        return {'type': "DingtalkAlerter"}