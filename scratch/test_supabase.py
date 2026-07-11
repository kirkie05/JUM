import requests
import json

url = "https://vxuiokugixdrmgpmppbh.supabase.co/rest/v1/profiles?limit=1"
headers = {
    "apikey": "sb_publishable_4MJvO8FTchVxUXNRwz08yg_VLh-nbSB",
    "Authorization": "Bearer sb_publishable_4MJvO8FTchVxUXNRwz08yg_VLh-nbSB"
}

try:
    response = requests.get(url, headers=headers)
    print("Status Code:", response.status_code)
    print("Response Content:", response.text[:500])
except Exception as e:
    print("Error:", e)
