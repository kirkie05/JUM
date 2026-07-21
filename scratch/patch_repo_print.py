with open('lib/features/bible/data/repositories/bible_repository.dart', 'r') as f:
    content = f.read()

content = content.replace("final chapter = BibleChapter.fromJsonBolls(chapterNumber, jsonList);", 
                          "print('DEBUG: jsonList length = ${jsonList.length}');\n      final chapter = BibleChapter.fromJsonBolls(chapterNumber, jsonList);\n      print('DEBUG: chapter content length = ${chapter.content.length}');")

with open('lib/features/bible/data/repositories/bible_repository.dart', 'w') as f:
    f.write(content)
