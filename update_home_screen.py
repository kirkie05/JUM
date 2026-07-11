import re

with open('lib/features/home/presentation/screens/home_screens.dart', 'r') as f:
    content = f.read()

# 1. Update Greeting Section
greeting_current = "user != null ? 'Welcome, ${user.name}' : 'Welcome, JUM Member',"
greeting_new = "user?.firstName != null ? 'Welcome, ${user!.firstName}' : 'Welcome, Friend',"
content = content.replace(greeting_current, greeting_new)

# 2. Add Imports for Latest Sermon and Event
imports_block = """import '../../sermons/data/providers/sermon_provider.dart';
import '../../events/data/providers/events_provider.dart';
"""
if "import '../../sermons/data/providers/sermon_provider.dart';" not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\n" + imports_block)

# 3. Insert Latest Sermon & Remove Mixlr
# The user wants "Immediately after: 'Intentional Reflection' Insert a new section: Latest Sermon"
# The current code:
#                 const Text(
#                   'May your day be filled with intentional reflection.',
#                   ...
#                 ),
#                 const Gap(24),
#                 youtubeLiveStreamAsync.when(...)
#                 const Gap(32),
#                 _buildMixlrRadioCard(context, ref),
#
# I will replace the Featured Sermon / Live Stream / Mixlr block with the new Latest Sermon block.
# Wait, "The Home Screen should now be: 1. Welcome, 2. Intentional Reflection, 3. Latest Sermon, 4. Upcoming Events Slider, 5. Remaining Existing Sections"
# This means I should replace everything between Intentional Reflection and Upcoming Events with Latest Sermon?
# The user said: "There is an Audio Radio / Zoom Radio section. Requirement: REMOVE IT COMPLETELY... Immediately after: 'Intentional Reflection' Insert a new section: Latest Sermon".

content = re.sub(
    r'(const Gap\(24\),\s*// Featured Sermon or Live Now Hero Card.*?)(const Gap\(32\),\s*// Upcoming Events)',
    r'''const Gap(24),
                // Latest Sermon
                _buildLatestSermonSection(context, ref),
                \2''',
    content,
    flags=re.DOTALL
)

# Wait, `_buildLatestFromJumSection` might be removed if I match too broadly.
# The user said "5. Remaining Existing Sections". If `_buildLatestFromJumSection` was there, it should remain.
# Let's write a targeted replacement.

