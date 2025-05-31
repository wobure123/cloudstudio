import re
import time
import requests


def upload_paste(content, remark="update", expiry_time="0", max_views=0):
    url = "https://cloudpaste-backend.huaifengaichen.dpdns.org/api/user/pastes/cpolar"
    headers = {
        "Authorization": "ApiKey dMpnPLFyWCds",
        "Content-Type": "application/json"
    }
    data = {
        "content": content,
        "remark": remark,
        # "password": "访问密码，可选",
        "expiryTime": expiry_time,
        "maxViews": max_views
    }
    response = requests.put(url, json=data, headers=headers)
    print(response.status_code)
    print(response.json())
    return response

logfile = "cpolar.log"
output_file = "tunnel_url.txt"
# 匹配日志中的公网地址
forwarding_re = re.compile(r'Tunnel established at (tcp://[^\s"]+)')

def extract_url():
    with open(logfile, 'r', encoding='utf-8', errors='ignore') as f:
        for line in f:
            match = forwarding_re.search(line)
            if match:
                url = match.group(1)
                # 上传
                upload_paste(content=url)
                
                with open(output_file, 'w', encoding='utf-8') as out:
                    out.write(url)
                print('cpolar公网地址:', url)
                return True
    return False

# 持续检测直到抓到地址
while not extract_url():
    time.sleep(1)
