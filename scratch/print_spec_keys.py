import json

with open("scratch/openapi.json", "r") as f:
    spec = json.load(f)

print("Keys:", list(spec.keys()))
if "paths" in spec:
    print("Paths:", list(spec["paths"].keys())[:10])
if "definitions" in spec:
    print("Definitions:", list(spec["definitions"].keys())[:10])
else:
    print("No definitions found")
