import re

with open('lib/features/bible/data/models/bible_models.dart', 'r') as f:
    content = f.read()

# Insert fromJsonBolls into BibleChapter
bolls_factory = """  factory BibleChapter.fromJsonBolls(int chapterNum, List<dynamic> list) {
    final List<ChapterNode> nodes = [];
    
    for (var item in list) {
      final int vNum = item['verse'] as int? ?? 0;
      final String rawText = item['text']?.toString() ?? '';
      
      // Clean up HTML/XML tags like <S>xxxx</S> and <mark>
      final String cleanText = rawText
          .replaceAll(RegExp(r'<S>\\d+</S>'), '')
          .replaceAll('<mark>', '')
          .replaceAll('</mark>', '')
          .replaceAll(RegExp(r'<[^>]*>'), '') // generic cleanup
          .replaceAll(RegExp(r'\\s+'), ' ') // replace multiple spaces with single space
          .trim();
      
      nodes.add(ChapterNode(
        type: ChapterNodeType.verse,
        verseNumber: vNum,
        content: [cleanText],
      ));
    }
    
    return BibleChapter(
      number: chapterNum,
      content: nodes,
    );
  }"""

if "fromJsonBolls" not in content:
    content = content.replace("  factory BibleChapter.fromHtml", bolls_factory + "\\n\\n  factory BibleChapter.fromHtml")
    with open('lib/features/bible/data/models/bible_models.dart', 'w') as f:
        f.write(content)
    print("Added fromJsonBolls to BibleChapter.")
else:
    print("fromJsonBolls already exists.")
