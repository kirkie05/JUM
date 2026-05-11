import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class BibleBook {
  final String id;
  final String name;
  final String commonName;
  final String title;
  final int numberOfChapters;
  final int order;

  BibleBook({
    required this.id,
    required this.name,
    required this.commonName,
    required this.title,
    required this.numberOfChapters,
    required this.order,
  });

  factory BibleBook.fromJson(Map<String, dynamic> json, int listOrder) {
    final bookId = json['id'] ?? '';
    return BibleBook(
      id: bookId,
      name: json['name'] ?? '',
      commonName: json['nameLong'] ?? json['name'] ?? '',
      title: json['nameLong'] ?? '',
      numberOfChapters: canonicalChapterCounts[bookId] ?? 1,
      order: listOrder,
    );
  }

  static const Map<String, int> canonicalChapterCounts = {
    'GEN': 50, 'EXO': 40, 'LEV': 27, 'NUM': 36, 'DEU': 34, 'JOS': 24, 'JDG': 21, 'RUT': 4, '1SA': 31, '2SA': 24,
    '1KI': 22, '2KI': 25, '1CH': 29, '2CH': 36, 'EZR': 10, 'NEH': 13, 'EST': 10, 'JOB': 42, 'PSA': 150, 'PRO': 31,
    'ECC': 12, 'SNG': 8, 'ISA': 66, 'JER': 52, 'LAM': 5, 'EZK': 48, 'DAN': 12, 'HOS': 14, 'JOL': 3, 'AMO': 9,
    'OBA': 1, 'JON': 4, 'MIC': 7, 'NAM': 3, 'HAB': 3, 'ZEP': 3, 'HAG': 2, 'ZEC': 14, 'MAL': 4,
    'MAT': 28, 'MRK': 16, 'LUK': 24, 'JHN': 21, 'ACT': 28, 'ROM': 16, '1CO': 16, '2CO': 13, 'GAL': 6, 'EPH': 6,
    'PHP': 4, 'COL': 4, '1TH': 5, '2TH': 3, '1TI': 6, '2TI': 4, 'TIT': 3, 'PHM': 1, 'HEB': 13, 'JAS': 5,
    '1PE': 5, '2PE': 3, '1JN': 5, '2JN': 1, '3JN': 1, 'JUD': 1, 'REV': 22
  };
}

enum ChapterNodeType { heading, verse, lineBreak, unknown }

class ChapterNode {
  final ChapterNodeType type;
  final int? verseNumber;
  final List<dynamic> content; // Holds Strings or Maps (for style tagging)

  ChapterNode({
    required this.type,
    this.verseNumber,
    this.content = const [],
  });
}

class BibleChapter {
  final int number;
  final List<ChapterNode> content;

  BibleChapter({
    required this.number,
    required this.content,
  });

  factory BibleChapter.fromJsonWldeh(int chapterNum, Map<String, dynamic> json) {
    final List<dynamic> list = json['data'] ?? [];
    final List<ChapterNode> nodes = [];
    
    for (var item in list) {
      final String rawVerse = item['verse'] ?? '';
      final int vNum = int.tryParse(rawVerse.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final String text = item['text'] ?? '';
      
      // Check for Pilcrow paragraph character (¶) used in some sources for KJV
      final cleanText = text.replaceAll('\u00b6', '').trim();
      final bool isParagraphStart = text.contains('\u00b6');
      
      if (isParagraphStart) {
         nodes.add(ChapterNode(type: ChapterNodeType.lineBreak));
      }

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
  }

  factory BibleChapter.fromHtml(int chapterNum, String htmlContent) {
    final document = parse(htmlContent);
    final List<ChapterNode> nodes = [];

    // Iterate through the body elements (typically <p>, <h2>, etc.)
    for (var element in document.body?.children ?? []) {
      if (element.localName == 'h2' || element.localName == 'h3' || element.localName == 'h4') {
        nodes.add(ChapterNode(
          type: ChapterNodeType.heading,
          content: [element.text.trim()],
        ));
      } else if (element.localName == 'p' || element.localName == 'div') {
        _parseParagraphIntoNodes(element, nodes);
      }
    }

    return BibleChapter(
      number: chapterNum,
      content: nodes,
    );
  }

  static void _parseParagraphIntoNodes(dom.Element element, List<ChapterNode> targetList) {
    // Extract styling flags
    final isPoem = element.classes.contains('q') || element.classes.contains('q1') || element.classes.contains('q2');
    
    int? currentVerse;
    List<dynamic> currentSegments = [];

    void flushSegment() {
      if (currentVerse != null && currentSegments.isNotEmpty) {
        targetList.add(ChapterNode(
          type: ChapterNodeType.verse,
          verseNumber: currentVerse,
          content: List.from(currentSegments),
        ));
        currentSegments.clear();
      }
    }

    // Loop through children of paragraph (verse spans and raw text)
    for (var node in element.nodes) {
      if (node is dom.Element && node.classes.contains('v')) {
        // Encountered new verse span
        flushSegment(); // save previous verse text
        final vIdStr = node.attributes['id'] ?? ''; // e.g. "v1"
        final cleanIdStr = vIdStr.replaceAll(RegExp(r'[^0-9]'), '');
        currentVerse = int.tryParse(cleanIdStr);
      } else if (node is dom.Element) {
        // Other nested elements like italics/words of christ
        final isItalic = node.classes.contains('it') || node.localName == 'i' || node.localName == 'em';
        final text = node.text;
        if (text.isNotEmpty) {
          if (isItalic || isPoem) {
            currentSegments.add({
              'text': text,
              if (isItalic) 'italic': true,
              if (isPoem) 'poem': 1, // trigger indent formatting
            });
          } else {
            currentSegments.add(text);
          }
        }
      } else if (node is dom.Text) {
        // Raw text node
        final text = node.text;
        if (text.trim().isNotEmpty) {
          if (isPoem) {
             currentSegments.add({'text': text, 'poem': 1});
          } else {
             currentSegments.add(text);
          }
        }
      }
    }
    
    // Final flush for end of paragraph
    flushSegment();
  }
}
