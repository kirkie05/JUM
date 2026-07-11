import json

with open("scratch/openapi.json", "r") as f:
    spec = json.load(f)

profiles = spec.get("definitions", {}).get("profiles", {})
properties = profiles.get("properties", {})
print("Profiles columns:", list(properties.keys()))

donations = spec.get("definitions", {}).get("donations", {})
properties_donations = donations.get("properties", {})
print("Donations columns:", list(properties_donations.keys()))
