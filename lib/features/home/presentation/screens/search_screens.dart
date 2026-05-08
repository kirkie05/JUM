import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/jum_card.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({Key? key}) : super(key: key);

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.border, width: 1.0),
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search sermons, users, events...',
              hintStyle: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              prefixIcon: Icon(Icons.search, size: 20, color: AppColors.textSecondary),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.normal,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: 'Sermons'),
            Tab(text: 'Users'),
            Tab(text: 'Events'),
            Tab(text: 'Courses'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSermonsTab(),
          _buildUsersTab(),
          _buildEventsTab(),
          _buildCoursesTab(),
        ],
      ),
    );
  }

  Widget _buildSermonsTab() {
    final list = [
      {'title': 'The Path of Silence', 'speaker': 'Rev. Elijah Thorne', 'duration': '42 mins'},
      {'title': 'Living Unhindered', 'speaker': 'Pastor Kingsley', 'duration': '38 mins'},
      {'title': 'The Kingdom Economy', 'speaker': 'Apostle David', 'duration': '55 mins'},
    ].where((s) => s['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) || s['speaker']!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    if (list.isEmpty) return _buildEmptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: JumCard(
            onTap: () {},
            child: Row(
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const Icon(Icons.play_circle_fill, size: 28, color: AppColors.primary),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        '${item['speaker']} • ${item['duration']}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUsersTab() {
    final list = [
      {'name': 'Emmanuel Adebayo', 'role': 'Minister', 'initials': 'EA'},
      {'name': 'Sarah Jenkins', 'role': 'Choir Member', 'initials': 'SJ'},
      {'name': 'John Doe', 'role': 'Member', 'initials': 'JD'},
    ].where((u) => u['name']!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    if (list.isEmpty) return _buildEmptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: JumCard(
            onTap: () {},
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.surface2,
                  radius: 24,
                  child: Text(
                    item['initials']!,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name']!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        item['role']!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.textSecondary),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventsTab() {
    final list = [
      {'title': 'Community Night Outreach', 'date': 'Friday, May 15 • 6:00 PM'},
      {'title': 'Morning Glory Prayers', 'date': 'Daily • 6:30 AM'},
      {'title': 'Annual Winter Soup Kitchen', 'date': 'Saturday, Dec 12 • 9:00 AM'},
    ].where((e) => e['title']!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    if (list.isEmpty) return _buildEmptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: JumCard(
            onTap: () {},
            child: Row(
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const Icon(Icons.event_outlined, size: 28, color: AppColors.primary),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        item['date']!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCoursesTab() {
    final list = [
      {'title': 'Theology and Discipleship', 'lessons': '12 Lessons'},
      {'title': 'Christian Leadership Essentials', 'lessons': '8 Lessons'},
      {'title': 'The Wisdom of Ecclesiastes', 'lessons': '10-day Journey'},
    ].where((c) => c['title']!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    if (list.isEmpty) return _buildEmptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: JumCard(
            onTap: () {},
            child: Row(
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const Icon(Icons.school_outlined, size: 28, color: AppColors.primary),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        item['lessons']!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted),
          const Gap(12),
          Text(
            'No results found',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const Gap(4),
          Text(
            'Try searching with another keyword',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
