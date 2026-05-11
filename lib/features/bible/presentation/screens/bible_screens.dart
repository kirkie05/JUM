import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';
import '../../../../shared/widgets/jum_text_field.dart';

// -------------------------------------------------------------
// BIBLE HOME SCREEN (TABBED SYSTEM FOR READER & PLANS)
// -------------------------------------------------------------
class BibleReaderScreen extends StatefulWidget {
  const BibleReaderScreen({Key? key}) : super(key: key);

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Holy Scripture',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppColors.textPrimary,
                labelColor: AppColors.textPrimary,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                unselectedLabelStyle: AppTextStyles.bodyMedium,
                tabs: const [
                  Tab(text: 'Scripture Reader'),
                  Tab(text: 'Reading Plans'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _BibleReaderTab(),
          _ReadingPlansTab(),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// SCRIPTURE READER TAB (BILINGUAL & VERSE ACTIONS SUPPORT)
// -------------------------------------------------------------
class _BibleReaderTab extends StatefulWidget {
  const _BibleReaderTab({Key? key}) : super(key: key);

  @override
  State<_BibleReaderTab> createState() => _BibleReaderTabState();
}

class _BibleReaderTabState extends State<_BibleReaderTab> {
  String _selectedBook = 'Genesis';
  int _selectedChapter = 1;
  double _fontSize = 16.0;
  bool _isBilingual = true;
  String _activeTranslation = 'KJV';
  String _bilingualTranslation = 'YOR';

  final Set<int> _bookmarkedVerses = {};
  final Map<int, Color> _verseHighlights = {};
  final Map<int, String> _verseNotes = {};

  final Dio _dio = Dio();
  bool _isLoading = false;
  List<Map<String, String>> _fetchedVerses = [];

  final List<String> _books = [
    'Genesis', 'Exodus', 'Leviticus', 'Numbers', 'Deuteronomy', 'Joshua', 'Judges', 'Ruth',
    '1 Samuel', '2 Samuel', '1 Kings', '2 Kings', '1 Chronicles', '2 Chronicles', 'Ezra',
    'Nehemiah', 'Esther', 'Job', 'Psalms', 'Proverbs', 'Ecclesiastes', 'Song of Solomon',
    'Isaiah', 'Jeremiah', 'Lamentations', 'Ezekiel', 'Daniel', 'Hosea', 'Joel', 'Amos',
    'Obadiah', 'Jonah', 'Micah', 'Nahum', 'Habakkuk', 'Zephaniah', 'Haggai', 'Zechariah',
    'Malachi', 'Matthew', 'Mark', 'Luke', 'John', 'Acts', 'Romans', '1 Corinthians',
    '2 Corinthians', 'Galatians', 'Ephesians', 'Philippians', 'Colossians', '1 Thessalonians',
    '2 Thessalonians', '1 Timothy', '2 Timothy', 'Titus', 'Philemon', 'Hebrews', 'James',
    '1 Peter', '2 Peter', '1 John', '2 John', '3 John', 'Jude', 'Revelation'
  ];

  int _getMaxChapters(String book) {
    switch (book) {
      case 'Genesis': return 50;
      case 'Exodus': return 40;
      case 'Leviticus': return 27;
      case 'Numbers': return 36;
      case 'Deuteronomy': return 34;
      case 'Joshua': return 24;
      case 'Judges': return 21;
      case 'Ruth': return 4;
      case '1 Samuel': return 31;
      case '2 Samuel': return 24;
      case '1 Kings': return 22;
      case '2 Kings': return 25;
      case '1 Chronicles': return 29;
      case '2 Chronicles': return 36;
      case 'Ezra': return 10;
      case 'Nehemiah': return 13;
      case 'Esther': return 10;
      case 'Job': return 42;
      case 'Psalms': return 150;
      case 'Proverbs': return 31;
      case 'Ecclesiastes': return 12;
      case 'Song of Solomon': return 8;
      case 'Isaiah': return 66;
      case 'Jeremiah': return 52;
      case 'Lamentations': return 5;
      case 'Ezekiel': return 48;
      case 'Daniel': return 12;
      case 'Hosea': return 14;
      case 'Joel': return 3;
      case 'Amos': return 9;
      case 'Obadiah': return 1;
      case 'Jonah': return 4;
      case 'Micah': return 7;
      case 'Nahum': return 3;
      case 'Habakkuk': return 3;
      case 'Zephaniah': return 3;
      case 'Haggai': return 2;
      case 'Zechariah': return 14;
      case 'Malachi': return 4;
      case 'Matthew': return 28;
      case 'Mark': return 16;
      case 'Luke': return 24;
      case 'John': return 21;
      case 'Acts': return 28;
      case 'Romans': return 16;
      case '1 Corinthians': return 16;
      case '2 Corinthians': return 13;
      case 'Galatians': return 6;
      case 'Ephesians': return 6;
      case 'Philippians': return 4;
      case 'Colossians': return 4;
      case '1 Thessalonians': return 5;
      case '2 Thessalonians': return 3;
      case '1 Timothy': return 6;
      case '2 Timothy': return 4;
      case 'Titus': return 3;
      case 'Philemon': return 1;
      case 'Hebrews': return 13;
      case 'James': return 5;
      case '1 Peter': return 5;
      case '2 Peter': return 3;
      case '1 John': return 5;
      case '2 John': return 1;
      case '3 John': return 1;
      case 'Jude': return 1;
      case 'Revelation': return 22;
      default: return 50;
    }
  }

  // Raw high-fidelity bilingual translations for demonstration fallback
  final List<Map<String, String>> _genesisVerses = [
    {
      'KJV': 'In the beginning God created the heaven and the earth.',
      'YOR': 'Ní ìbẹ̀rẹ̀pẹ̀pẹ̀ Ọlọ́run dá àwọn ọ̀run àti ayé.',
      'FRE': 'Au commencement, Dieu créa les cieux et la terre.'
    },
    {
      'KJV': 'And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters.',
      'YOR': 'Ayé sì wà ní ríru àti lófò; òkùnkùn sì wà lójú ibú. Ẹ̀mí Ọlọ́run sì n-ràbàbà lójú omi.',
      'FRE': "La terre était informe et vide: il y avait des ténèbres à la surface de l'abîme, et l'esprit de Dieu se mouvait au-dessus des eaux."
    },
    {
      'KJV': 'And God said, Let there be light: and there was light.',
      'YOR': 'Ọlọ́run sì wí pé, "Kí ìmọ́lẹ̀ kí ó wà." Ìmọ́lẹ̀ sì wà.',
      'FRE': 'Dieu dit: Que la lumière soit! Et la lumière fut.'
    },
    {
      'KJV': 'And God saw the light, that it was good: and God divided the light from the darkness.',
      'YOR': 'Ọlọ́run sì rí i pé ìmọ́lẹ̀ náà dára. Ọlọ́run sì ya ìmọ́lẹ̀ náà sọ́tọ̀ kúrò lára òkùnkùn.',
      'FRE': 'Dieu vit que la lumière était bonne; et Dieu sépara la lumière d\'avec les ténèbres.'
    },
    {
      'KJV': 'And God called the light Day, and the darkness he called Night. And the evening and the morning were the first day.',
      'YOR': 'Ọlọ́run sì pe ìmọ́lẹ̀ náà ní "Ọ̀sán", òkùnkùn sì ni ó pe ní "Òru". Alẹ́ sì lẹ́, àárọ̀ sì tún mọ́—ní ọjọ́ kìn-ín-ní.',
      'FRE': 'Dieu appela la lumière jour, et il appela les ténèbres nuit. Ainsi, il y eut un soir, et il y eut un matin: ce fut le premier jour.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchedVerses = _genesisVerses;
    _fetchScripture();
  }

  Future<void> _fetchScripture() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String primaryTrans = _activeTranslation.toLowerCase();
      String secondaryTrans = _bilingualTranslation.toLowerCase();

      // Translate code mapping to API endpoints (fallback Cherokee/BBE if not supported natively)
      if (primaryTrans == 'yor') primaryTrans = 'bbe';
      if (secondaryTrans == 'yor') secondaryTrans = 'bbe';
      if (primaryTrans == 'fre') primaryTrans = 'bbe';
      if (secondaryTrans == 'fre') secondaryTrans = 'bbe';

      final primaryUrl = 'https://bible-api.com/${_selectedBook}+${_selectedChapter}?translation=$primaryTrans';
      final primaryResponse = await _dio.get(primaryUrl);

      final List<Map<String, String>> parsed = [];

      if (primaryResponse.statusCode == 200 && primaryResponse.data != null) {
        final primaryVerses = primaryResponse.data['verses'] as List<dynamic>;

        List<dynamic> secondaryVerses = [];
        if (_isBilingual && primaryTrans != secondaryTrans) {
          try {
            final secondaryUrl = 'https://bible-api.com/${_selectedBook}+${_selectedChapter}?translation=$secondaryTrans';
            final secondaryResponse = await _dio.get(secondaryUrl);
            if (secondaryResponse.statusCode == 200) {
              secondaryVerses = secondaryResponse.data['verses'] as List<dynamic>;
            }
          } catch (_) {}
        }

        for (int i = 0; i < primaryVerses.length; i++) {
          final pText = (primaryVerses[i]['text'] as String).trim();
          final sText = (secondaryVerses.isNotEmpty && i < secondaryVerses.length)
              ? (secondaryVerses[i]['text'] as String).trim()
              : 'Episod ${_selectedBook} ${_selectedChapter}:${i + 1}';

          parsed.add({
            _activeTranslation: pText,
            _bilingualTranslation: sText,
          });
        }

        setState(() {
          _fetchedVerses = parsed;
          _isLoading = false;
        });
      } else {
        throw Exception();
      }
    } catch (_) {
      setState(() {
        _fetchedVerses = _genesisVerses;
        _isLoading = false;
      });
    }
  }

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
                    style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
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
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: _fontSize,
                    min: 14.0,
                    max: 26.0,
                    activeColor: AppColors.textPrimary,
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
                        'Bilingual Layout',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                      Switch.adaptive(
                        value: _isBilingual,
                        activeColor: Colors.white,
                        activeTrackColor: AppColors.textSecondary,
                        onChanged: (val) {
                          setState(() => _isBilingual = val);
                          setSheetState(() {});
                        },
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

  void _showVerseActionsSheet(int verseNum, Map<String, String> verseMap) {
    final noteController = TextEditingController(text: _verseNotes[verseNum] ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: AppSizes.paddingLg,
            left: AppSizes.paddingLg,
            right: AppSizes.paddingLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Verse $verseNum Actions',
                style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
              const Gap(16),
              // Highlights Palette
              Text(
                'Highlight Tones',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHighlightPalette(verseNum, Colors.transparent, 'None', Icons.block),
                  _buildHighlightPalette(verseNum, const Color(0xFF2E2E2E), 'Soft Grey', Icons.circle),
                  _buildHighlightPalette(verseNum, const Color(0xFF4E4E4E), 'Charcoal', Icons.circle),
                  _buildHighlightPalette(verseNum, Colors.white.withOpacity(0.9), 'Pearl', Icons.circle),
                ],
              ),
              const Gap(24),
              const Divider(color: AppColors.border),
              const Gap(16),
              // Actions Options
              Row(
                children: [
                  Expanded(
                    child: JumButton(
                      label: _bookmarkedVerses.contains(verseNum) ? 'Remove Bookmark' : 'Add Bookmark',
                      variant: _bookmarkedVerses.contains(verseNum) ? JumButtonVariant.secondary : JumButtonVariant.primary,
                      onPressed: () {
                        setState(() {
                          if (_bookmarkedVerses.contains(verseNum)) {
                            _bookmarkedVerses.remove(verseNum);
                          } else {
                            _bookmarkedVerses.add(verseNum);
                          }
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_bookmarkedVerses.contains(verseNum) ? 'Bookmark saved.' : 'Bookmark removed.'),
                            backgroundColor: AppColors.textPrimary,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const Gap(24),
              // Private Study Notes
              Text(
                'Private Study Notes',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
              const Gap(8),
              JumTextField(
                label: 'Study Notes',
                hint: 'Write private sermon notes or revelations here...',
                controller: noteController,
              ),
              const Gap(16),
              JumButton(
                label: 'Save Private Notes',
                onPressed: () {
                  setState(() {
                    if (noteController.text.trim().isNotEmpty) {
                      _verseNotes[verseNum] = noteController.text.trim();
                    } else {
                      _verseNotes.remove(verseNum);
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Study notes saved successfully.'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
              const Gap(32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHighlightPalette(int verseNum, Color color, String name, IconData icon) {
    final isSelected = (_verseHighlights[verseNum] == color) || (color == Colors.transparent && !_verseHighlights.containsKey(verseNum));
    return GestureDetector(
      onTap: () {
        setState(() {
          if (color == Colors.transparent) {
            _verseHighlights.remove(verseNum);
          } else {
            _verseHighlights[verseNum] = color;
          }
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AppColors.textPrimary : Colors.transparent, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color == Colors.transparent ? AppColors.textMuted : color, size: 20),
            const Gap(6),
            Text(name, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // PICKERS ROW
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
                      onChanged: (val) {
                        setState(() {
                          _selectedBook = val ?? 'Genesis';
                          _selectedChapter = 1;
                        });
                        _fetchScripture();
                      },
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
                      items: List.generate(_getMaxChapters(_selectedBook), (i) => i + 1).map((ch) {
                        return DropdownMenuItem<int>(
                          value: ch,
                          child: Text('Ch $ch'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedChapter = val ?? 1;
                        });
                        _fetchScripture();
                      },
                    ),
                  ),
                ),
              ),
              const Gap(12),
              IconButton(
                icon: const Icon(Icons.tune, color: AppColors.textPrimary),
                onPressed: _showFontAdjustmentSheet,
              ),
            ],
          ),
        ),
        // TRANSLATIONS CHOICE CHIPS
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
          child: Row(
            children: [
              Text('Translation: ', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              const Gap(8),
              ChoiceChip(
                label: const Text('KJV'),
                selected: _activeTranslation == 'KJV',
                selectedColor: Colors.white,
                backgroundColor: AppColors.surface,
                labelStyle: TextStyle(color: _activeTranslation == 'KJV' ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                onSelected: (val) {
                  setState(() => _activeTranslation = 'KJV');
                  _fetchScripture();
                },
              ),
              const Gap(8),
              ChoiceChip(
                label: const Text('YOR'),
                selected: _activeTranslation == 'YOR',
                selectedColor: Colors.white,
                backgroundColor: AppColors.surface,
                labelStyle: TextStyle(color: _activeTranslation == 'YOR' ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                onSelected: (val) {
                  setState(() => _activeTranslation = 'YOR');
                  _fetchScripture();
                },
              ),
              const Gap(8),
              ChoiceChip(
                label: const Text('FRE'),
                selected: _activeTranslation == 'FRE',
                selectedColor: Colors.white,
                backgroundColor: AppColors.surface,
                labelStyle: TextStyle(color: _activeTranslation == 'FRE' ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                onSelected: (val) {
                  setState(() => _activeTranslation = 'FRE');
                  _fetchScripture();
                },
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.border, height: 24),
        // VERSES DISPLAY
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
                  itemCount: _fetchedVerses.length,
                  itemBuilder: (context, index) {
                    final verseNum = index + 1;
                    final verseMap = _fetchedVerses[index];
                    final primaryText = verseMap[_activeTranslation] ?? '';
                    final secondaryText = verseMap[_bilingualTranslation] ?? '';

                    final isBookmarked = _bookmarkedVerses.contains(verseNum);
              final highlightColor = _verseHighlights[verseNum];
              final hasNote = _verseNotes.containsKey(verseNum);

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingLg),
                child: InkWell(
                  onLongPress: () => _showVerseActionsSheet(verseNum, verseMap),
                  onTap: () => _showVerseActionsSheet(verseNum, verseMap),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: JumCard(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: highlightColor != null ? highlightColor.withOpacity(0.12) : null,
                        border: isBookmarked ? Border.all(color: Colors.white.withOpacity(0.4), width: 1) : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                '$verseNum',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              if (isBookmarked) const Icon(Icons.bookmark, size: 14, color: Colors.white),
                              if (hasNote) ...[
                                const Gap(6),
                                const Icon(Icons.note_alt, size: 14, color: AppColors.textSecondary),
                              ],
                            ],
                          ),
                          const Gap(6),
                          Text(
                            primaryText,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: _fontSize,
                              height: 1.5,
                            ),
                          ),
                          if (_isBilingual && _activeTranslation != _bilingualTranslation) ...[
                            const Gap(8),
                            const Divider(color: AppColors.border, height: 1),
                            const Gap(8),
                            Text(
                              secondaryText,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: _fontSize - 1.0,
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                              ),
                            ),
                          ],
                          if (hasNote) ...[
                            const Gap(8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Note: ${_verseNotes[verseNum]}',
                                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                              ),
                            ),
                          ],
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
    );
  }
}

// -------------------------------------------------------------
// READING PLANS TAB (DAILY TRACK PROGRESS & MILESTONES)
// -------------------------------------------------------------
class _ReadingPlansTab extends StatefulWidget {
  const _ReadingPlansTab({Key? key}) : super(key: key);

  @override
  State<_ReadingPlansTab> createState() => _ReadingPlansTabState();
}

class _ReadingPlansTabState extends State<_ReadingPlansTab> {
  int _completedDays = 4;
  final int _totalDays = 14;

  final List<Map<String, dynamic>> _dailyProgress = [
    {'day': 1, 'scripture': 'Genesis 1-3', 'title': 'The Dawn of Creation', 'checked': true},
    {'day': 2, 'scripture': 'Genesis 4-6', 'title': 'Covenant Foundations', 'checked': true},
    {'day': 3, 'scripture': 'Genesis 7-9', 'title': 'The Saving Ark', 'checked': true},
    {'day': 4, 'scripture': 'Genesis 10-12', 'title': 'The Call of Abraham', 'checked': true},
    {'day': 5, 'scripture': 'Genesis 13-15', 'title': 'Inheriting The Promise', 'checked': false},
    {'day': 6, 'scripture': 'Genesis 16-18', 'title': 'Sarah Laughs', 'checked': false},
    {'day': 7, 'scripture': 'Genesis 19-21', 'title': 'Faith Tested', 'checked': false},
  ];

  @override
  Widget build(BuildContext context) {
    final double completionPercent = _completedDays / _totalDays;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Plan Hero Header Card
          JumCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.import_contacts, color: Colors.white, size: 28),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active Reading Plan',
                              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2),
                            ),
                            Text(
                              'Understanding Covenant',
                              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overall Completion Progress',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                      Text(
                        '${(_completedDays * 100 / _totalDays).toInt()}% completed',
                        style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Gap(8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: completionPercent,
                      minHeight: 8,
                      backgroundColor: AppColors.surface,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const Gap(16),
                  Text(
                    'Reading Genesis reveals God\'s absolute faithfulness over thousands of generations. Keep going!',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const Gap(24),
          // Day Breakdown Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Checklist',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
              Text(
                '$_completedDays / $_totalDays Days Done',
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const Gap(12),
          // Checklist Cards
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _dailyProgress.length,
            itemBuilder: (context, index) {
              final dayItem = _dailyProgress[index];
              final isChecked = dayItem['checked'] as bool;
              final dayNum = dayItem['day'] as int;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: JumCard(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        dayItem['checked'] = !isChecked;
                        if (dayItem['checked']) {
                          _completedDays++;
                        } else {
                          _completedDays--;
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isChecked ? Colors.white : AppColors.surface,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Day $dayNum',
                              style: AppTextStyles.caption.copyWith(
                                color: isChecked ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dayItem['title'] as String,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    decoration: isChecked ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                                const Gap(2),
                                Text(
                                  dayItem['scripture'] as String,
                                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                            color: isChecked ? Colors.white : AppColors.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
