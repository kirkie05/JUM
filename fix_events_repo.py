with open('lib/features/events/data/repositories/events_repository.dart', 'r') as f:
    content = f.read()

content = content.replace("  }\n}\n\n  Future<EventModel?> fetchEvent(String eventId) async {", "  }\n\n  Future<EventModel?> fetchEvent(String eventId) async {")
content = content.replace("    return null;\n  }\n\n\n", "    return null;\n  }\n}\n")

with open('lib/features/events/data/repositories/events_repository.dart', 'w') as f:
    f.write(content)
