import re

with open('lib/features/bible/data/providers/bible_providers.dart', 'r') as f:
    content = f.read()

translations_map = """
// Supported translations mapped from Bolls Life API
const Map<String, String> bibleTranslationsMap = {
  'KJV': 'King James Version',
  'NKJV': 'New King James Version',
  'ESV': 'English Standard Version',
  'NASB': 'New American Standard Bible',
  'NIV': 'New International Version',
  'NLT': 'New Living Translation',
  'CSB17': 'Christian Standard Bible',
  'BSB': 'Berean Standard Bible',
  'MSG': 'The Message',
  'AMP': 'Amplified Bible',
  'NET': 'New English Translation',
  'RSV': 'Revised Standard Version',
  'WEB': 'World English Bible',
  'ASV': 'American Standard Version',
  'YLT': 'Young\\'s Literal Translation',
};
"""

if "bibleTranslationsMap" not in content:
    content = content.replace("final bibleTranslationProvider = StateProvider<String>((ref) => 'BSB');", 
                              translations_map + "\\nfinal bibleTranslationProvider = StateProvider<String>((ref) => 'KJV');") # changed default to KJV

    with open('lib/features/bible/data/providers/bible_providers.dart', 'w') as f:
        f.write(content)
    print("Updated bible_providers.dart")
else:
    print("bibleTranslationsMap already exists.")
