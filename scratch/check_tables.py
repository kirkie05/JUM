import urllib.request
import json
import ssl

url_base = "https://vxuiokugixdrmgpmppbh.supabase.co/rest/v1"
headers = {
    "apikey": "sb_publishable_4MJvO8FTchVxUXNRwz08yg_VLh-nbSB",
    "Authorization": "Bearer sb_publishable_4MJvO8FTchVxUXNRwz08yg_VLh-nbSB"
}

# Create unverified SSL context to bypass macOS local cert issues
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

tables = ["posts", "events", "sermons", "products", "courses", "youtube_videos"]

for table in tables:
    url = f"{url_base}/{table}?limit=5"
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, context=ctx) as response:
            status = response.getcode()
            body = response.read().decode('utf-8')
            data = json.loads(body)
            print(f"Table: {table} | Status: {status} | Count: {len(data)}")
            if len(data) > 0:
                print("Sample:", json.dumps(data[0], indent=2)[:300])
    except Exception as e:
        print(f"Table: {table} | Error: {e}")
