import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/providers/bible_providers.dart';
import '../../data/models/bible_models.dart';
import '../widgets/bible_content_renderer.dart';

class BibleReaderScreen extends ConsumerStatefulWidget {
  const BibleReaderScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends ConsumerState<BibleReaderScreen> {
  final ScrollController _scrollController = ScrollController();

  void _showVerseOptions(int verseNum, String content, String bookName, int chapterNum) {
    final refString = '$bookName $chapterNum:$verseNum';
    final currentBookId = ref.read(currentBookProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _VerseOptionsSheet(
        reference: refString,
        content: content,
        bookId: currentBookId,
        chapterNum: chapterNum,
        verseNum: verseNum,
      ),
    ).whenComplete(() {
      // Deselect verse when modal is dismissed
      ref.read(selectedVerseProvider.notifier).state = null;
    });
  }

  void _navigateToChapter(int delta, List<BibleBook> books, String currentBookId, int currentCh) {
    // Complex bounding logic: handle moving across book boundaries
    final currentIndex = books.indexWhere((b) => b.id == currentBookId);
    if (currentIndex == -1) return;
    final book = books[currentIndex];

    int nextCh = currentCh + delta;
    if (nextCh < 1) {
      // Go to previous book's last chapter
      if (currentIndex > 0) {
        final prevBook = books[currentIndex - 1];
        ref.read(currentBookProvider.notifier).state = prevBook.id;
        ref.read(currentChapterNumberProvider.notifier).state = prevBook.numberOfChapters;
        _scrollController.jumpTo(0);
      }
    } else if (nextCh > book.numberOfChapters) {
      // Go to next book's first chapter
      if (currentIndex < books.length - 1) {
        final nextBook = books[currentIndex + 1];
        ref.read(currentBookProvider.notifier).state = nextBook.id;
        ref.read(currentChapterNumberProvider.notifier).state = 1;
        _scrollController.jumpTo(0);
      }
    } else {
      // Normal step within same book
      ref.read(currentChapterNumberProvider.notifier).state = nextCh;
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(bibleBooksProvider);
    final chapterAsync = ref.watch(bibleChapterProvider);
    final currentBookId = ref.watch(currentBookProvider);
    final currentCh = ref.watch(currentChapterNumberProvider);
    final themeMode = ref.watch(bibleReadingThemeProvider);
    final bool isDark = themeMode == ReadingTheme.dark;

    // Define dynamic coloring based on preferences
    Color bgColor = Colors.white;
    Color appBarColor = Colors.white;
    Color textColor = Colors.black87;
    Brightness bright = Brightness.light;

    if (themeMode == ReadingTheme.sepia) {
      bgColor = const Color(0xFFFDF6E3);
      appBarColor = const Color(0xFFFDF6E3);
      textColor = const Color(0xFF586E75);
      bright = Brightness.light;
    } else if (themeMode == ReadingTheme.dark) {
      bgColor = const Color(0xFF121212);
      appBarColor = const Color(0xFF1E1E1E);
      textColor = Colors.white70;
      bright = Brightness.dark;
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: bright == Brightness.dark ? Brightness.light : Brightness.dark,
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: textColor),
          onPressed: () {
            if (booksAsync.hasValue) {
              _showBookChapterPicker(context, ref, booksAsync.value!, currentBookId, currentCh);
            }
          },
        ),
        title: booksAsync.when(
          data: (books) {
            final currentBook = books.firstWhere(
              (b) => b.id == currentBookId,
              orElse: () => books.first,
            );
            return InkWell(
              onTap: () => _showBookChapterPicker(context, ref, books, currentBookId, currentCh),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${currentBook.name} $currentCh',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      fontSize: 18,
                    ),
                  ),
                  const Gap(4),
                  Icon(Icons.keyboard_arrow_down, color: textColor.withOpacity(0.7), size: 20),
                ],
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const Text('Bible'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: textColor, size: 24),
            onPressed: () => GoRouter.of(context).push('/search'),
          ),
          const Gap(4),
          // New Interactive Version Display
          InkWell(
            onTap: () => _showTranslationPickerSheet(context, ref),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ref.watch(bibleTranslationProvider).toUpperCase(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: textColor,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, size: 18, color: textColor),
                ],
              ),
            ),
          ),
          const Gap(4),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: textColor, size: 24),
            onPressed: () => _showGeneralSettingsSheet(context, ref),
          ),
          const Gap(8),
        ],
      ),
      body: Stack(
        children: [
          chapterAsync.when(
            data: (chapter) {
              final currentBookName = booksAsync.whenOrNull(
                data: (l) => l.firstWhere((b) => b.id == currentBookId).name,
              ) ?? '';

              return ListView(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 20, bottom: 120),
                children: [
                  // Giant Top Header
                  Center(
                    child: Text(
                      '$currentBookName ${chapter.number}',
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Center(
                    child: Container(
                      width: 50,
                      height: 2.5,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                  const Gap(24),
                  // Dynamic Body Content
                  BibleContentRenderer(
                    chapter: chapter,
                    onVerseSelected: (vNum, content) {
                      _showVerseOptions(vNum, content, currentBookName, chapter.number);
                    },
                  ),
                  const Gap(40),
                  // Reflection Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C2C) : (themeMode == ReadingTheme.sepia ? const Color(0xFFF3EBDB) : const Color(0xFFF8F8F8)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reflect',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          const Gap(8),
                          Text(
                            'How do the messages of this chapter resonate with your walk with Christ today?',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              color: textColor.withOpacity(0.8),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
            error: (e, __) => Center(child: Text('Error loading content: $e')),
          ),
          // Floating Bottom Navigator Row
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: booksAsync.maybeWhen(
              data: (books) {
                final book = books.firstWhere((b) => b.id == currentBookId);
                final prevLabel = (currentCh > 1) 
                    ? '${book.name.toUpperCase()} ${currentCh - 1}' 
                    : 'PREV';
                final nextLabel = (currentCh < book.numberOfChapters) 
                    ? '${book.name.toUpperCase()} ${currentCh + 1}' 
                    : 'NEXT';

                return Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 20),
                          onPressed: () => _navigateToChapter(-1, books, currentBookId, currentCh),
                        ),
                      ),
                      Text(
                        '${book.name.toUpperCase()} $currentCh',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13, 
                          fontWeight: FontWeight.w900, 
                          color: textColor, 
                          letterSpacing: 0.8,
                          fontFamily: 'Inter'
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios_rounded, color: textColor, size: 20),
                          onPressed: () => _navigateToChapter(1, books, currentBookId, currentCh),
                        ),
                      ),
                    ],
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookChapterPicker(
    BuildContext context,
    WidgetRef ref,
    List<BibleBook> books,
    String activeBookId,
    int activeCh,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
            ),
            const Gap(20),
            const Text('Select Scripture', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Gap(16),
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (c, idx) {
                  final book = books[idx];
                  final isSelected = book.id == activeBookId;
                  return ExpansionTile(
                    initiallyExpanded: isSelected,
                    title: Text(
                      book.name,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.black : Colors.black87,
                      ),
                    ),
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: book.numberOfChapters,
                        itemBuilder: (ctx2, chIdx) {
                          final chNum = chIdx + 1;
                          final isChSel = isSelected && (chNum == activeCh);
                          return InkWell(
                            onTap: () {
                              ref.read(currentBookProvider.notifier).state = book.id;
                              ref.read(currentChapterNumberProvider.notifier).state = chNum;
                              Navigator.pop(ctx);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isChSel ? Colors.black : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$chNum',
                                style: TextStyle(
                                  color: isChSel ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTranslationPickerSheet(BuildContext context, WidgetRef ref) {
    final currentTrans = ref.watch(bibleTranslationProvider);
    const supported = ['KJV', 'NKJV', 'AMP', 'AMPC', 'TMB', 'TPT', 'NIV', 'NLT', 'TGB', 'BSB'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Translation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Gap(24),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: supported.map((t) => ListTile(
                  title: Text(t, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  trailing: currentTrans == t ? const Icon(Icons.check_circle, color: Colors.black87) : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  onTap: () {
                    ref.read(bibleTranslationProvider.notifier).state = t;
                    Navigator.pop(ctx);
                  },
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGeneralSettingsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _GeneralSettingsSheetContent(),
    );
  }
}

class _GeneralSettingsSheetContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFontSize = ref.watch(bibleFontSizeProvider);
    final currentFontFamily = ref.watch(bibleFontFamilyProvider);
    final currentTheme = ref.watch(bibleReadingThemeProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reader Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const Gap(24),
          const Text('FONT SIZE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          Row(
            children: [
              const Icon(Icons.format_size, size: 16),
              Expanded(
                child: Slider(
                  value: currentFontSize,
                  min: 14,
                  max: 32,
                  activeColor: Colors.black87,
                  onChanged: (val) {
                    ref.read(bibleFontSizeProvider.notifier).state = val;
                  },
                ),
              ),
              const Icon(Icons.format_size, size: 28),
            ],
          ),
          const Gap(16),
          const Text('FONT TYPE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          const Gap(8),
          DropdownButton<String>(
            isExpanded: true,
            value: currentFontFamily,
            items: ['Serif', 'Sans-serif', 'Monospace']
                .map((f) => DropdownMenuItem(value: f, child: Text(f, style: TextStyle(fontFamily: f))))
                .toList(),
            onChanged: (val) {
              if (val != null) ref.read(bibleFontFamilyProvider.notifier).state = val;
            },
          ),
          const Gap(24),
          const Text('THEME', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _themeOption(context, ref, ReadingTheme.light, 'Light', Colors.white, Colors.black),
              _themeOption(context, ref, ReadingTheme.sepia, 'Sepia', const Color(0xFFFDF6E3), const Color(0xFF586E75)),
              _themeOption(context, ref, ReadingTheme.dark, 'Dark', const Color(0xFF1E1E1E), Colors.white70),
            ],
          ),
          const Gap(24),
        ],
      ),
    );
  }

  Widget _themeOption(BuildContext context, WidgetRef ref, ReadingTheme target, String label, Color bg, Color text) {
    final isSelected = ref.watch(bibleReadingThemeProvider) == target;
    return GestureDetector(
      onTap: () => ref.read(bibleReadingThemeProvider.notifier).state = target,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.27,
        height: 50,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: isSelected ? Colors.black87 : Colors.grey.shade300, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(color: text, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _VerseOptionsSheet extends ConsumerWidget {
  final String reference;
  final String content;
  final String bookId;
  final int chapterNum;
  final int verseNum;

  const _VerseOptionsSheet({
    Key? key,
    required this.reference,
    required this.content,
    required this.bookId,
    required this.chapterNum,
    required this.verseNum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            reference.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const Gap(8),
          Text(
            '"$content"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              fontFamily: 'Serif',
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          const Gap(24),
          // Highlight palette with persistence actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _circleAction(context, ref, Icons.block, Colors.transparent, true, onTapped: () {
                ref.read(bibleHighlightsProvider.notifier).setHighlight(bookId, chapterNum, verseNum, null);
                Navigator.pop(context);
              }),
              _circleAction(context, ref, null, const Color(0xFFFFF9C4), false, onTapped: () {
                ref.read(bibleHighlightsProvider.notifier).setHighlight(bookId, chapterNum, verseNum, const Color(0xFFFBC02D));
                Navigator.pop(context);
              }),
              _circleAction(context, ref, null, const Color(0xFFC8E6C9), false, onTapped: () {
                ref.read(bibleHighlightsProvider.notifier).setHighlight(bookId, chapterNum, verseNum, const Color(0xFF388E3C));
                Navigator.pop(context);
              }),
              _circleAction(context, ref, null, const Color(0xFFBBDEFB), false, onTapped: () {
                ref.read(bibleHighlightsProvider.notifier).setHighlight(bookId, chapterNum, verseNum, const Color(0xFF1976D2));
                Navigator.pop(context);
              }),
              _circleAction(context, ref, null, const Color(0xFFF8BBD0), false, onTapped: () {
                ref.read(bibleHighlightsProvider.notifier).setHighlight(bookId, chapterNum, verseNum, const Color(0xFFC2185B));
                Navigator.pop(context);
              }),
            ],
          ),
          const Gap(24),
          // Menu items container
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _menuItem(
                  icon: Icons.notes,
                  label: 'Add Note',
                  onTap: () {},
                ),
                Divider(height: 1, color: Colors.grey.shade200),
                _menuItem(
                  icon: Icons.copy,
                  label: 'Copy Verse',
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: '$reference: $content'));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to Clipboard')));
                  },
                ),
                Divider(height: 1, color: Colors.grey.shade200),
                _menuItem(
                  icon: Icons.ios_share,
                  label: 'Share Image',
                  onTap: () {
                    Share.share('$reference\n"$content"');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const Gap(32),
        ],
      ),
    );
  }

  Widget _circleAction(
    BuildContext context,
    WidgetRef ref,
    IconData? icon,
    Color color,
    bool hasBorder, {
    Color? iconColor,
    VoidCallback? onTapped,
  }) {
    return GestureDetector(
      onTap: onTapped,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: hasBorder ? Border.all(color: Colors.grey.shade300) : null,
        ),
        child: icon != null ? Icon(icon, size: 20, color: iconColor ?? Colors.grey) : null,
      ),
    );
  }

  Widget _menuItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54, size: 22),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
