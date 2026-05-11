import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../data/models/bible_models.dart';
import '../../data/providers/bible_providers.dart';

class BibleContentRenderer extends ConsumerWidget {
  final BibleChapter chapter;
  final Function(int verseNum, String content) onVerseSelected;

  const BibleContentRenderer({
    Key? key,
    required this.chapter,
    required this.onVerseSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVerse = ref.watch(selectedVerseProvider);
    final fontSize = ref.watch(bibleFontSizeProvider);
    final fontFamily = ref.watch(bibleFontFamilyProvider);
    final readingTheme = ref.watch(bibleReadingThemeProvider);
    
    final currentBook = ref.watch(currentBookProvider);
    final currentChapter = ref.watch(currentChapterNumberProvider);
    final highlights = ref.watch(bibleHighlightsProvider);

    // Theme config map
    final bool isDark = readingTheme == ReadingTheme.dark;
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF2D2D2D);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: chapter.content.map((node) {
          switch (node.type) {
            case ChapterNodeType.heading:
              return _buildHeading(context, node, isDark);
            case ChapterNodeType.lineBreak:
              return const Gap(16);
            case ChapterNodeType.verse:
              final vNum = node.verseNumber ?? 0;
              final highlightCode = highlights['${currentBook.toUpperCase()}.$currentChapter.$vNum'];
              final highlightColor = highlightCode != null ? Color(highlightCode) : null;
              return _buildVerse(
                context, 
                node, 
                ref, 
                selectedVerse,
                fontSize: fontSize,
                fontFamily: fontFamily,
                textColor: textColor,
                highlightColor: highlightColor,
              );
            default:
              return const SizedBox.shrink();
          }
        }).toList(),
      ),
    );
  }

  Widget _buildHeading(BuildContext context, ChapterNode node, bool isDark) {
    final text = _flattenNodeContent(node.content);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: isDark ? Colors.grey.shade400 : Colors.grey,
                fontFamily: 'Inter',
              ),
            ),
            const Gap(8),
            Container(
              width: 40,
              height: 2,
              color: isDark ? Colors.white38 : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerse(
    BuildContext context,
    ChapterNode node,
    WidgetRef ref,
    int? currentlySelected, {
    required double fontSize,
    required String fontFamily,
    required Color textColor,
    Color? highlightColor,
  }) {
    final vNum = node.verseNumber ?? 0;
    final isSelected = vNum == currentlySelected;
    final plainText = _flattenNodeContent(node.content);

    // Combine system selection highlight with user applied persistent highlight
    Color? displayBackgroundColor;
    if (isSelected) {
      displayBackgroundColor = Colors.grey.withOpacity(0.15);
    } else if (highlightColor != null) {
      // User preference highlight - subtle alpha blend for elegance
      displayBackgroundColor = highlightColor.withOpacity(0.35);
    }

    return InkWell(
      onTap: () {
        ref.read(selectedVerseProvider.notifier).state = isSelected ? null : vNum;
        if (!isSelected) {
          onVerseSelected(vNum, plainText);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: displayBackgroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.top,
                child: Transform.translate(
                  offset: const Offset(0, -4),
                  child: Text(
                    '$vNum ',
                    style: TextStyle(
                      fontSize: fontSize * 0.6, // scale relative to font selection
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ..._parseStyledContent(node.content, isSelected),
            ],
          ),
          style: TextStyle(
            fontSize: fontSize,
            height: 1.6,
            fontFamily: fontFamily, 
            color: textColor,
          ),
        ),
      ),
    );
  }

  String _flattenNodeContent(List<dynamic> content) {
    final buffer = StringBuffer();
    for (var c in content) {
      if (c is String) {
        buffer.write(c);
      } else if (c is Map) {
        if (c.containsKey('text')) {
          buffer.write(c['text']);
        }
      }
    }
    return buffer.toString();
  }

  List<InlineSpan> _parseStyledContent(List<dynamic> content, bool isSelected) {
    final List<InlineSpan> spans = [];
    for (var chunk in content) {
      if (chunk is String) {
        spans.add(TextSpan(text: chunk));
      } else if (chunk is Map) {
        if (chunk.containsKey('text')) {
          // Handle poetic styling
          final double indent = chunk.containsKey('poem') ? 12.0 * (chunk['poem'] as int) : 0.0;
          if (indent > 0) {
            spans.add(const TextSpan(text: '\n'));
            spans.add(WidgetSpan(child: SizedBox(width: indent)));
          }
          spans.add(TextSpan(
            text: chunk['text'],
            style: chunk.containsKey('italic') ? const TextStyle(fontStyle: FontStyle.italic) : null,
          ));
        } else if (chunk.containsKey('lineBreak') && chunk['lineBreak'] == true) {
          spans.add(const TextSpan(text: '\n'));
        }
      }
    }
    return spans;
  }
}
