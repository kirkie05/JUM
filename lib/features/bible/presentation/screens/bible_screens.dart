import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_card.dart';

// -------------------------------------------------------------
// BIBLE READER SCREEN
// -------------------------------------------------------------
class BibleReaderScreen extends StatefulWidget {
  const BibleReaderScreen({Key? key}) : super(key: key);

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  String _selectedBook = 'Genesis';
  int _selectedChapter = 1;
  double _fontSize = 16.0;
  final Set<int> _highlightedVerses = {};

  final List<String> _books = ['Genesis', 'Exodus', 'Leviticus', 'Psalms', 'Matthew', 'John', 'Romans'];
  final List<int> _chapters = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  final List<String> _verses = [
    'In the beginning God created the heaven and the earth.',
    'And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters.',
    'And God said, Let there be light: and there was light.',
    'And God saw the light, that it was good: and God divided the light from the darkness.',
    'And God called the light Day, and the darkness he called Night. And the evening and the morning were the first day.',
  ];

  void _showFontAdjustmentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Reader Preferences',
                    style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Font Size',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_fontSize.toInt()}px',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: _fontSize,
                    min: 12.0,
                    max: 28.0,
                    activeColor: AppColors.accent,
                    inactiveColor: AppColors.border,
                    onChanged: (val) {
                      setState(() => _fontSize = val);
                      setSheetState(() {});
                    },
                  ),
                  const Gap(16),
                  const Divider(color: AppColors.border),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Translation',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surface2,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'KJV (King James Version)',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Holy Bible'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size, color: AppColors.accent),
            onPressed: _showFontAdjustmentSheet,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline, color: AppColors.accent),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // PICKER ROW (BOOK / CHAPTER)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg, vertical: AppSizes.paddingMd),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedBook,
                        dropdownColor: AppColors.surface,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                        items: _books.map((book) {
                          return DropdownMenuItem<String>(
                            value: book,
                            child: Text(book),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedBook = val ?? 'Genesis'),
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedChapter,
                        dropdownColor: AppColors.surface,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                        items: _chapters.map((ch) {
                          return DropdownMenuItem<int>(
                            value: ch,
                            child: Text('Ch $ch'),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedChapter = val ?? 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          // VERSES DISPLAY
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSizes.paddingLg),
              itemCount: _verses.length,
              itemBuilder: (context, index) {
                final verseNum = index + 1;
                final isHighlighted = _highlightedVerses.contains(verseNum);
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.paddingLg),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isHighlighted) {
                          _highlightedVerses.remove(verseNum);
                        } else {
                          _highlightedVerses.add(verseNum);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: isHighlighted ? AppColors.accent.withOpacity(0.15) : null,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$verseNum ',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: _fontSize - 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: _verses[index],
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: _fontSize,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
