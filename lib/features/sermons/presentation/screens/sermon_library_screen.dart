import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/jum_empty_state.dart';
import '../../../../shared/widgets/jum_shimmer.dart';
import '../../data/models/sermon_model.dart';
import '../../data/providers/sermon_provider.dart';
import '../widgets/sermon_card.dart';

class SermonLibraryScreen extends ConsumerStatefulWidget {
  const SermonLibraryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SermonLibraryScreen> createState() => _SermonLibraryScreenState();
}

class _SermonLibraryScreenState extends ConsumerState<SermonLibraryScreen> {
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  String _activeFilter = 'All';
  final List<String> _filters = ['All', 'Video', 'Audio'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final int crossAxisCount = width >= 1024
        ? 4
        : width >= 600
            ? 3
            : 2;

    final sermonsAsyncValue = ref.watch(sermonsProvider);
    final searchState = ref.watch(sermonSearchNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Media Library',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearchExpanded ? Icons.search_off : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                if (!_isSearchExpanded) {
                  _searchController.clear();
                  ref.read(sermonSearchNotifierProvider.notifier).search('');
                }
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFF1F1F1F),
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          // Animated Search Bar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isSearchExpanded ? 64 : 0,
            curve: Curves.easeInOut,
            child: _isSearchExpanded
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 8.0,
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
                      decoration: InputDecoration(
                        hintText: 'Search sermons...',
                        hintStyle: const TextStyle(color: Color(0xFF8E8E8E), fontFamily: 'Inter'),
                        prefixIcon: const Icon(Icons.search, color: Colors.white, size: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close, color: Color(0xFF8E8E8E), size: 20),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(sermonSearchNotifierProvider.notifier).search('');
                            setState(() => _isSearchExpanded = false);
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1F1F1F),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
                      onChanged: (val) {
                        ref.read(sermonSearchNotifierProvider.notifier).search(val);
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Horizontal Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _activeFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: Colors.white,
                    backgroundColor: const Color(0xFF1F1F1F),
                    labelStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _activeFilter = filter);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Sermon Library Grid
          Expanded(
            child: searchState.query.isNotEmpty
                ? _buildSearchResults(searchState, crossAxisCount)
                : _buildFullLibrary(sermonsAsyncValue, crossAxisCount),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(SermonSearchState searchState, int crossAxisCount) {
    if (searchState.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    final filtered = searchState.results.where((s) {
      if (_activeFilter == 'All') return true;
      if (_activeFilter == 'Video') return s.type == 'video';
      if (_activeFilter == 'Audio') return s.type == 'audio';
      if (_activeFilter == 'Series') {
        return s.description.toLowerCase().contains('series') ||
            s.title.toLowerCase().contains('series');
      }
      return true;
    }).toList();

    if (filtered.isEmpty) {
      return const JumEmptyState(
        title: 'No Sermons Found',
        subtitle: 'Try searching with a different keyword or removing filters.',
        icon: Icons.search_off_rounded,
      );
    }

    return _buildGrid(filtered, crossAxisCount);
  }

  Widget _buildFullLibrary(AsyncValue<List<dynamic>> sermonsAsyncValue, int crossAxisCount) {
    return sermonsAsyncValue.when(
      data: (sermonList) {
        final filtered = sermonList.where((s) {
          if (_activeFilter == 'All') return true;
          if (_activeFilter == 'Video') return s.type == 'video';
          if (_activeFilter == 'Audio') return s.type == 'audio';
          if (_activeFilter == 'Series') {
            return s.description.toLowerCase().contains('series') ||
                s.title.toLowerCase().contains('series');
          }
          return true;
        }).toList();

        if (filtered.isEmpty) {
          return const JumEmptyState(
            title: 'No Media Available',
            subtitle: 'There are currently no sermons uploaded in this category.',
            icon: Icons.video_library_rounded,
          );
        }

        return _buildGrid(filtered.cast(), crossAxisCount);
      },
      loading: () => const JumShimmerGrid(),
      error: (err, stack) => const JumEmptyState(
        title: 'Failed to Load Media',
        subtitle: 'Make sure you are connected to the internet and try again.',
        icon: Icons.cloud_off_rounded,
      ),
    );
  }

  Widget _buildGrid(List<SermonModel> sermons, int crossAxisCount) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemCount: sermons.length,
      itemBuilder: (context, index) {
        return SermonCard(sermon: sermons[index]);
      },
    );
  }
}

// Compact and responsive shimmer loading state
class JumShimmerGrid extends StatelessWidget {
  const JumShimmerGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JumShimmer(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1F1F),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1F1F),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1F1F),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1F1F),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
