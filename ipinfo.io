import requests
from datetime import datetime
import pytz

WEBHOOK_URL = 'https://ptb.discord.com/api/webhooks/1378440007294910494/L_thGPuBPiCfKF4MVElI7V8-6HA572rKW1YnXoV-1z1ba15ZFGhds3O0FschlfAWtA-E'

def get_ip_info(ip):
    url = f'https://ipinfo.io/{ip}/json?token={IPINFO_TOKEN}'
    response = requests.get(url)
    if response.status_code != 200:
        return None
    data = response.json()
    
    ip_addr = data.get('ip', 'N/A')
    city = data.get('city', 'N/A')
    country = data.get('country', 'N/A')
    loc = data.get('loc', 'N/A')
    org = data.get('org', 'N/A')
    timezone = data.get('timezone', 'UTC')
    
    local_time = datetime.now(pytz.timezone(timezone)).strftime('%Y-%m-%d %H:%M:%S')
    
    return {
        'IP': ip_addr,
        'Country': country,
        'City': city,
        'Location': loc,
        'Organization': org,
        'Local Time': local_time
    }

def send_to_discord(data):
    message = (
        "------------------------\n"
        "------------------------\n"
        f"🧠 IP: {data['IP']}\n"
        f"🌍 Country: {data['Country']}\n"
        f"🏙️ City: {data['City']}\n"
        f"📍 Location: {data['Location']}\n"
        f"🏢 Organization: {data['Organization']}\n"
        f"⏰ Local Time: {data['Local Time']}\n"
        "------------------------\n"
        "------------------------"
    )
    payload = {
        "content": f"```{message}```"
    }
    response = requests.post(WEBHOOK_URL, json=payload)
    if response.status_code == 204:
        print("تم إرسال البيانات للـ Discord webhook بنجاح.")
    else:
        print(f"حدث خطأ أثناء الإرسال. الحالة: {response.status_code}")

if __name__ == "__main__":
    ip_to_check = '8.8.8.8'  # بدلها بأي IP تريد تستعلم عنه
    ip_info = get_ip_info(ip_to_check)
    if ip_info:
        send_to_discord(ip_info)
    else:
        print("لم أتمكن من جلب معلومات الـ IP.")
