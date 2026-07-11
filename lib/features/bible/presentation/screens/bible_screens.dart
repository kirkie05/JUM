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
import '../../data/providers/reading_plan_providers.dart';
import '../../data/models/bible_reading_plan_engine.dart';
import '../../../../shared/widgets/jum_shimmer.dart';

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
    if (books.isEmpty) return; // Prevent empty list error
    
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
      if (currentIndex >= 0 && currentIndex < books.length - 1) {
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
    final planStateAsync = ref.watch(readingPlanStateProvider);
    final selectedDay = ref.watch(selectedPlanDayProvider);

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
            onPressed: () => GoRouter.of(context).push('/bible/search'),
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
      body: Column(
        children: [
          Expanded(
            child: Stack(
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
                  loading: () => Padding(padding: const EdgeInsets.all(24.0), child: JumShimmer.list()),
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
      builder: (ctx) => _BibleDashboardSheet(
        books: books,
        activeBookId: activeBookId,
        activeCh: activeCh,
      ),
    );
  }

  void _showTranslationPickerSheet(BuildContext context, WidgetRef ref) {
    final currentTrans = ref.watch(bibleTranslationProvider);
    const supported = ['BSB', 'KJV', 'ASV', 'WEB', 'FBV', 'RV'];

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

class _BibleDashboardSheet extends ConsumerWidget {
  final List<BibleBook> books;
  final String activeBookId;
  final int activeCh;

  const _BibleDashboardSheet({
    Key? key,
    required this.books,
    required this.activeBookId,
    required this.activeCh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planStateAsync = ref.watch(readingPlanStateProvider);
    final notesAsync = ref.watch(bibleNotesProvider('${activeBookId}_$activeCh'));
    final bookmarksAsync = ref.watch(bibleBookmarksProvider('${activeBookId}_$activeCh'));

    final currentBook = books.firstWhere((b) => b.id == activeBookId, orElse: () => books.first);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const Gap(16),
          const Center(
            child: Text(
              'Bible Menu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter', color: Colors.black87),
            ),
          ),
          const Gap(16),
          Expanded(
            child: ListView(
              children: [
                // 1. Reading Plan Card
                planStateAsync.maybeWhen(
                  data: (planState) {
                    final nextRead = planState.nextReading;
                    final isPlanDone = planState.completedDays.length == 365;
                    final currentStreak = planState.streak?.currentStreak ?? 0;

                    return Card(
                      elevation: 0,
                      color: AppColors.primary.withOpacity(0.06),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppColors.primary, width: 1.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/bible/reading-plan');
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '📖 Reading Plan',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Text(
                                    'Streak: $currentStreak Days 🔥',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              Text(
                                isPlanDone ? 'Plan Completed!' : 'Day ${nextRead.dayNumber} of 365',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const Gap(4),
                              Text(
                                isPlanDone ? 'All 365 days completed!' : nextRead.title,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const Gap(12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${planState.completionPercentage.toStringAsFixed(0)}% Complete',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const Text(
                                    'Manage Plan →',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
                const Gap(16),

                // 2. Continue Reading
                ListTile(
                  leading: const Icon(Icons.arrow_circle_right_outlined, color: AppColors.primary),
                  title: const Text('Continue Reading', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  subtitle: Text('Last read: ${currentBook.name} $activeCh', style: const TextStyle(color: Colors.grey)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Navigator.pop(context),
                ),
                const Divider(),

                // 3. Bible Search
                ListTile(
                  leading: const Icon(Icons.search, color: AppColors.primary),
                  title: const Text('Bible Search', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  subtitle: const Text('Search keywords and verses', style: TextStyle(color: Colors.grey)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/bible/search');
                  },
                ),
                const Divider(),

                // 4. Bookmarks
                bookmarksAsync.maybeWhen(
                  data: (bms) {
                    final bookmarksOnly = bms.where((b) => b.type == 'bookmark').toList();
                    return ListTile(
                      leading: const Icon(Icons.bookmark_outline, color: AppColors.primary),
                      title: const Text('Bookmarks', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                      subtitle: Text('${bookmarksOnly.length} bookmarks in this chapter', style: const TextStyle(color: Colors.grey)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () => Navigator.pop(context),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
                const Divider(),

                // 5. Highlights
                bookmarksAsync.maybeWhen(
                  data: (bms) {
                    final highlightsOnly = bms.where((b) => b.type == 'highlight').toList();
                    return ListTile(
                      leading: const Icon(Icons.border_color_outlined, color: AppColors.primary),
                      title: const Text('Highlights', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                      subtitle: Text('${highlightsOnly.length} highlighted verses in this chapter', style: const TextStyle(color: Colors.grey)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () => Navigator.pop(context),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
                const Divider(),

                // 6. Notes
                notesAsync.maybeWhen(
                  data: (notes) {
                    return ListTile(
                      leading: const Icon(Icons.note_alt_outlined, color: AppColors.primary),
                      title: const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                      subtitle: Text('${notes.length} notes in this chapter', style: const TextStyle(color: Colors.grey)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () => Navigator.pop(context),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
                const Divider(),

                // 7. Select Scripture Expandable
                ExpansionTile(
                  leading: const Icon(Icons.book_outlined, color: AppColors.primary),
                  title: const Text('Select Scripture', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  subtitle: const Text('Browse books and chapters', style: TextStyle(color: Colors.grey)),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                                    Navigator.pop(context);
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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

  void _showAddNoteDialog(
    BuildContext context,
    WidgetRef ref,
    String bookId,
    int chapterNum,
    int verseNum,
    String reference,
  ) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Note: $reference', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title (Optional)',
                hintText: 'e.g. Reflection, Key Lesson',
              ),
            ),
            const Gap(12),
            TextField(
              controller: bodyController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Note content',
                hintText: 'Write down your thoughts...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final body = bodyController.text.trim();
              if (body.isNotEmpty) {
                final noteProv = ref.read(bibleNotesProvider('${bookId}_$chapterNum').notifier);
                noteProv.addNote(
                  bookId: bookId,
                  chapter: chapterNum,
                  verse: verseNum,
                  title: titleController.text.trim().isEmpty ? null : titleController.text.trim(),
                  body: body,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Note added successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bibleBookmarksProvider('${bookId}_$chapterNum'));
    final bookmarks = bookmarksAsync.value ?? [];

    final isBookmarked = bookmarks.any((b) => b.verse == verseNum && b.type == 'bookmark');
    final isFavorite = bookmarks.any((b) => b.verse == verseNum && b.type == 'favorite');

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
                // Also remove highlight bookmark
                ref.read(bibleBookmarksProvider('${bookId}_$chapterNum').notifier).removeBookmark(
                      bookId: bookId,
                      chapter: chapterNum,
                      verse: verseNum,
                      type: 'highlight',
                    );
                Navigator.pop(context);
              }),
              _circleAction(context, ref, null, const Color(0xFFFFF9C4), false, onTapped: () {
                ref.read(bibleHighlightsProvider.notifier).setHighlight(bookId, chapterNum, verseNum, const Color(0xFFFBC02D));
                ref.read(bibleBookmarksProvider('${bookId}_$chapterNum').notifier).addBookmark(
                      bookId: bookId,
                      chapter: chapterNum,
                      verse: verseNum,
                      type: 'highlight',
                      color: '#FBC02D',
                    );
                Navigator.pop(context);
              }),
              _circleAction(context, ref, null, const Color(0xFFC8E6C9), false, onTapped: () {
                ref.read(bibleHighlightsProvider.notifier).setHighlight(bookId, chapterNum, verseNum, const Color(0xFF388E3C));
                ref.read(bibleBookmarksProvider('${bookId}_$chapterNum').notifier).addBookmark(
                      bookId: bookId,
                      chapter: chapterNum,
                      verse: verseNum,
                      type: 'highlight',
                      color: '#388E3C',
                    );
                Navigator.pop(context);
              }),
              _circleAction(context, ref, null, const Color(0xFFBBDEFB), false, onTapped: () {
                ref.read(bibleHighlightsProvider.notifier).setHighlight(bookId, chapterNum, verseNum, const Color(0xFF1976D2));
                ref.read(bibleBookmarksProvider('${bookId}_$chapterNum').notifier).addBookmark(
                      bookId: bookId,
                      chapter: chapterNum,
                      verse: verseNum,
                      type: 'highlight',
                      color: '#1976D2',
                    );
                Navigator.pop(context);
              }),
              _circleAction(context, ref, null, const Color(0xFFF8BBD0), false, onTapped: () {
                ref.read(bibleHighlightsProvider.notifier).setHighlight(bookId, chapterNum, verseNum, const Color(0xFFC2185B));
                ref.read(bibleBookmarksProvider('${bookId}_$chapterNum').notifier).addBookmark(
                      bookId: bookId,
                      chapter: chapterNum,
                      verse: verseNum,
                      type: 'highlight',
                      color: '#C2185B',
                    );
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
                  onTap: () {
                    Navigator.pop(context);
                    _showAddNoteDialog(context, ref, bookId, chapterNum, verseNum, reference);
                  },
                ),
                Divider(height: 1, color: Colors.grey.shade200),
                _menuItem(
                  icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  label: isBookmarked ? 'Remove Bookmark' : 'Bookmark Verse',
                  onTap: () {
                    final notifier = ref.read(bibleBookmarksProvider('${bookId}_$chapterNum').notifier);
                    if (isBookmarked) {
                      notifier.removeBookmark(bookId: bookId, chapter: chapterNum, verse: verseNum, type: 'bookmark');
                    } else {
                      notifier.addBookmark(bookId: bookId, chapter: chapterNum, verse: verseNum, type: 'bookmark');
                    }
                    Navigator.pop(context);
                  },
                ),
                Divider(height: 1, color: Colors.grey.shade200),
                _menuItem(
                  icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                  label: isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                  onTap: () {
                    final notifier = ref.read(bibleBookmarksProvider('${bookId}_$chapterNum').notifier);
                    if (isFavorite) {
                      notifier.removeBookmark(bookId: bookId, chapter: chapterNum, verse: verseNum, type: 'favorite');
                    } else {
                      notifier.addBookmark(bookId: bookId, chapter: chapterNum, verse: verseNum, type: 'favorite');
                    }
                    Navigator.pop(context);
                  },
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

// ---------------------------------------------------------
// NEW DEDICATED BIBLE SEARCH SYSTEM
// ---------------------------------------------------------
class BibleSearchScreen extends ConsumerStatefulWidget {
  const BibleSearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BibleSearchScreen> createState() => _BibleSearchScreenState();
}

class _BibleSearchScreenState extends ConsumerState<BibleSearchScreen> {
  final _textController = TextEditingController();
  String _submittedQuery = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    setState(() {
      _submittedQuery = _textController.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(bibleReadingThemeProvider);
    final isDark = themeMode == ReadingTheme.dark;

    Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    Color txtColor = isDark ? Colors.white70 : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: txtColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Search Scripture',
          style: TextStyle(color: txtColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _textController,
                style: TextStyle(color: txtColor),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _handleSearch(),
                decoration: InputDecoration(
                  hintText: 'Enter keywords (e.g. grace, love)',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  suffixIcon: _textController.text.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                          onPressed: () {
                            _textController.clear();
                            setState(() {
                              _submittedQuery = '';
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          Expanded(
            child: _submittedQuery.isEmpty
                ? _buildPlaceholder(isDark)
                : ref.watch(bibleSearchResultsProvider(_submittedQuery)).when(
                    data: (results) {
                      if (results.isEmpty) {
                        return Center(
                          child: Text(
                            'No verses found for "$_submittedQuery"',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: results.length,
                        separatorBuilder: (_, __) => Divider(color: isDark ? Colors.white10 : Colors.grey.shade200, height: 32),
                        itemBuilder: (ctx, idx) {
                          final res = results[idx];
                          final refStr = '${res['bookName']} ${res['chapter']}:${res['verse']}';
                          return InkWell(
                            onTap: () {
                              // Visual hint for final navigation integration
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Feature Locked: Visual confirmation viewing $refStr')),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  refStr.toUpperCase(),
                                  style: TextStyle(
                                    color: isDark ? Colors.blueAccent : AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  res['text'],
                                  style: TextStyle(
                                    fontFamily: 'Serif',
                                    height: 1.5,
                                    fontSize: 16,
                                    color: txtColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    loading: () => JumShimmer.list(),
                    error: (e, __) => Center(child: Text('Error searching: $e')),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_outlined, size: 64, color: isDark ? Colors.white24 : Colors.grey.shade300),
          const Gap(16),
          Text(
            'Search through the entire Bible\ninstantly by keyword.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey.shade400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
