import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../media/data/models/media_item.dart';
import '../../../media/data/providers/media_provider.dart';
import '../../../../shared/widgets/jum_card.dart';
import '../../../../shared/widgets/jum_button.dart';

// -------------------------------------------------------------
// 1. ADMIN DASHBOARD SCREEN
// -------------------------------------------------------------
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'val': '1,420',
        'label': 'Total Members',
        'icon': Icons.people_outline,
        'route': '/admin/members',
      },
      {
        'val': '\$42,500',
        'label': 'Monthly Giving',
        'icon': Icons.volunteer_activism_outlined,
        'route': '/admin/analytics',
      },
      {
        'val': '380',
        'label': 'Enrolled Students',
        'icon': Icons.school_outlined,
        'route': '/admin/analytics',
      },
      {
        'val': '14',
        'label': 'Active Groups',
        'icon': Icons.chat_bubble_outline,
        'route': '/admin/departments',
      },
    ];

    final activities = [
      {
        'text': 'Sarah Jenkins enrolled in Foundations of Faith Course',
        'time': '10 mins ago',
      },
      {
        'text': 'Brother James contributed \$50.00 for Tithe',
        'time': '1 hour ago',
      },
      {
        'text': 'Pastor Kingsley posted new Sermon: "Living Unhindered"',
        'time': '2 hours ago',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'OVERVIEW METRICS',
              style: AppTextStyles.overline.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            // STATS GRID
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSizes.paddingMd,
                mainAxisSpacing: AppSizes.paddingMd,
                childAspectRatio: 1.3,
              ),
              itemCount: stats.length,
              itemBuilder: (context, index) {
                final stat = stats[index];
                return InkWell(
                  onTap: () => context.push(stat['route'] as String),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  child: JumCard(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMd),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            stat['icon'] as IconData,
                            color: AppColors.accent,
                            size: 24,
                          ),
                          const Gap(8),
                          Text(
                            stat['val'] as String,
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            stat['label'] as String,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const Gap(28),
            Text(
              'CONTROL CENTER',
              style: AppTextStyles.overline.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            // CONTROL QUICK LINK BUTTONS
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _buildQuickLinkCard(
                  context,
                  Icons.analytics_outlined,
                  'Analytics',
                  '/admin/analytics',
                ),
                _buildQuickLinkCard(
                  context,
                  Icons.video_library_outlined,
                  'Content Upload',
                  '/admin/sermons',
                ),
                _buildQuickLinkCard(
                  context,
                  Icons.manage_accounts_outlined,
                  'User Roster',
                  '/admin/members',
                ),
                _buildQuickLinkCard(
                  context,
                  Icons.corporate_fare_outlined,
                  'Departments',
                  '/admin/departments',
                ),
              ],
            ),
            const Gap(28),
            Text(
              'RECENT SYSTEM ACTIVITY',
              style: AppTextStyles.overline.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            // ACTIVITIES LIST
            JumCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                child: Column(
                  children: activities.map((activity) {
                    final isLast = activities.last == activity;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.accent,
                              size: 18,
                            ),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activity['text']!,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    activity['time']!,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (!isLast)
                          const Divider(color: AppColors.border, height: 24),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLinkCard(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: JumCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.accent, size: 28),
              const Gap(8),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. ANALYTICS DASHBOARD SCREEN
// -------------------------------------------------------------
class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final growthStats = [
      {'month': 'Jan', 'val': 45},
      {'month': 'Feb', 'val': 70},
      {'month': 'Mar', 'val': 110},
      {'month': 'Apr', 'val': 85},
      {'month': 'May', 'val': 140},
      {'month': 'Jun', 'val': 195},
    ];

    final givingBuckets = [
      {'name': 'Tithes', 'current': 25000, 'target': 25000, 'pct': 1.0},
      {'name': 'Offerings', 'current': 12500, 'target': 15000, 'pct': 0.83},
      {'name': 'Seed Gifts', 'current': 5000, 'target': 10000, 'pct': 0.50},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Analytics & Growth',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // COMMUNITY GROWTH CHART
            Text(
              'COMMUNITY GROWTH (NEW MEMBERS)',
              style: AppTextStyles.overline.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            JumCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Column(
                  children: [
                    SizedBox(
                      height: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: growthStats.map((stat) {
                          final double value = (stat['val'] as int).toDouble();
                          final double pct =
                              value / 200.0; // Scaled to max of 200
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${stat['val']}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(4),
                              Container(
                                width: 28,
                                height: 120 * pct,
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const Gap(8),
                              Text(
                                stat['month'] as String,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(28),

            // FINANCIAL GOAL OVERVIEW
            Text(
              'MONTHLY CONTRIBUTIONS TRACKER',
              style: AppTextStyles.overline.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            Column(
              children: givingBuckets.map((bucket) {
                final double progress = bucket['pct'] as double;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: JumCard(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                bucket['name'] as String,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${bucket['current']} / \$${bucket['target']}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                          Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.surface2,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: progress,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(6),
                          Text(
                            '${(progress * 100).toInt()}% of target achieved',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textMuted,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Gap(28),

            // ACADEMIC (LMS) INSIGHTS
            Text(
              'GOSPEL ARMY SCHOOL INSIGHTS',
              style: AppTextStyles.overline.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            JumCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Column(
                  children: [
                    _buildAcademicRow(
                      'Active Course Enrollments',
                      '380 Students',
                    ),
                    const Divider(color: AppColors.border, height: 24),
                    _buildAcademicRow(
                      'Syllabus Lessons Finished',
                      '1,450 Lessons',
                    ),
                    const Divider(color: AppColors.border, height: 24),
                    _buildAcademicRow(
                      'Course Certificates Issued',
                      '42 Certificates',
                    ),
                    const Divider(color: AppColors.border, height: 24),
                    _buildAcademicRow('Average Quiz Score', '87% Success Rate'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// 3. CONTENT MANAGEMENT SCREEN
// -------------------------------------------------------------
class ContentManagementScreen extends ConsumerStatefulWidget {
  const ContentManagementScreen({super.key});

  @override
  ConsumerState<ContentManagementScreen> createState() =>
      _ContentManagementScreenState();
}

class _ContentManagementScreenState
    extends ConsumerState<ContentManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _speakerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _youtubeController = TextEditingController(
    text: MediaChannelConfig.defaults.youtubeUrl,
  );
  final _mixlrController = TextEditingController(
    text: MediaChannelConfig.defaults.mixlrUrl,
  );
  String _selectedMediaType = 'Sermon';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSavedChannels();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _speakerController.dispose();
    _descriptionController.dispose();
    _youtubeController.dispose();
    _mixlrController.dispose();
    super.dispose();
  }

  void _simulateUpload() {
    if (_formKey.currentState!.validate()) {
      _titleController.clear();
      _speakerController.clear();
      _descriptionController.clear();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const _UploadProgressDialog(),
      );
    }
  }

  Future<void> _loadSavedChannels() async {
    final config = await ref.read(mediaRepositoryProvider).loadChannelConfig();
    if (!mounted) return;
    _youtubeController.text = config.youtubeUrl;
    _mixlrController.text = config.mixlrUrl;
  }

  Future<void> _saveChannels() async {
    final youtubeUrl = _youtubeController.text.trim();
    final mixlrUrl = _mixlrController.text.trim();
    if (youtubeUrl.isEmpty || mixlrUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add both YouTube and Mixlr channel URLs.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    await ref
        .read(mediaRepositoryProvider)
        .saveChannelConfig(
          MediaChannelConfig(youtubeUrl: youtubeUrl, mixlrUrl: mixlrUrl),
        );
    ref.invalidate(mediaChannelConfigProvider);
    ref.invalidate(mediaFeedProvider);
    ref.invalidate(youtubeVideosProvider);
    ref.invalidate(mixlrAudioProvider);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Channels saved. Media feed refreshed.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaFeed = ref.watch(mediaFeedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Content Management',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'UPLOAD NEW MEDIA'),
            Tab(text: 'ACTIVE CATALOG'),
            Tab(text: 'MANAGE CHANNELS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB A: UPLOAD FORM
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'SELECT CONTENT TYPE',
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(8),
                  Row(
                    children: ['Sermon', 'Podcast', 'Live Broadcast'].map((
                      type,
                    ) {
                      final isSelected = _selectedMediaType == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          selectedColor: AppColors.accent,
                          backgroundColor: AppColors.surface,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.black
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedMediaType = type);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const Gap(24),
                  Text(
                    'MEDIA METADATA DETAILS',
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(12),
                  TextFormField(
                    controller: _titleController,
                    decoration: _getInputDecoration(
                      'Media Title (e.g. Living in Grace)',
                    ),
                    style: _getInputStyle(),
                    validator: (val) => (val == null || val.trim().isEmpty)
                        ? 'Please enter media title'
                        : null,
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: _speakerController,
                    decoration: _getInputDecoration('Speaker / Teacher Name'),
                    style: _getInputStyle(),
                    validator: (val) => (val == null || val.trim().isEmpty)
                        ? 'Please enter speaker name'
                        : null,
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: _getInputDecoration(
                      'Study Notes & Description',
                    ),
                    style: _getInputStyle(),
                    validator: (val) => (val == null || val.trim().isEmpty)
                        ? 'Please enter study description'
                        : null,
                  ),
                  const Gap(28),
                  JumButton(
                    label: 'SIMULATE MEDIA UPLOAD',
                    isFullWidth: true,
                    onPressed: _simulateUpload,
                  ),
                ],
              ),
            ),
          ),

          // TAB B: CATALOG LISTING
          mediaFeed.when(
            data: (items) => ListView.builder(
              padding: const EdgeInsets.all(AppSizes.paddingLg),
              itemCount: items.length,
              itemBuilder: (context, index) => _buildCatalogItem(items[index]),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            ),
            error: (error, stack) => _buildAdminError(error.toString()),
          ),

          // TAB C: MANAGE CHANNELS FORM
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'CHURCH YOUTUBE CHANNEL',
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(12),
                TextFormField(
                  controller: _youtubeController,
                  decoration: _getInputDecoration('YouTube Channel URL or ID'),
                  style: _getInputStyle(),
                ),
                const Gap(24),
                Text(
                  'CHURCH MIXLR AUDIO CHANNEL',
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(12),
                TextFormField(
                  controller: _mixlrController,
                  decoration: _getInputDecoration(
                    'Mixlr Station URL or Username',
                  ),
                  style: _getInputStyle(),
                ),
                const Gap(32),
                JumButton(
                  label: 'SAVE & PULL CHANNEL DATA',
                  isFullWidth: true,
                  onPressed: _saveChannels,
                ),
                const Gap(28),
                Text(
                  'PULLED CHANNEL DATA',
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(12),
                _buildChannelPreview(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 14.0,
        color: AppColors.textSecondary,
      ),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.border, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.border, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
    );
  }

  TextStyle _getInputStyle() {
    return const TextStyle(fontSize: 15.0, color: AppColors.textPrimary);
  }

  Widget _buildCatalogItem(MediaItem item) {
    final isVideo = item.type == MediaItemType.video;
    final detail = item.viewCount != null
        ? '${item.viewCount} views'
        : item.isLive
        ? 'Live now'
        : item.sourceName;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: JumCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isVideo ? Icons.ondemand_video_rounded : Icons.radio_rounded,
                  color: AppColors.accent,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface2,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isVideo ? 'YOUTUBE VIDEO' : 'MIXLR AUDIO',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            detail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(6),
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.sourceUrl,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChannelPreview() {
    final youtube = ref.watch(youtubeVideosProvider);
    final mixlr = ref.watch(mixlrAudioProvider);

    return Column(
      children: [
        _buildPreviewSection(
          title: 'YouTube Videos',
          icon: Icons.smart_display_rounded,
          media: youtube,
        ),
        const Gap(12),
        _buildPreviewSection(
          title: 'Mixlr Audio',
          icon: Icons.graphic_eq_rounded,
          media: mixlr,
        ),
      ],
    );
  }

  Widget _buildPreviewSection({
    required String title,
    required IconData icon,
    required AsyncValue<List<MediaItem>> media,
  }) {
    return JumCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: media.when(
          data: (items) {
            final sample = items.take(3).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppColors.accent, size: 20),
                    const Gap(8),
                    Text(
                      '$title (${items.length})',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                if (sample.isEmpty)
                  Text(
                    'No items returned yet.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  )
                else
                  ...sample.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const SizedBox(
            height: 44,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
          ),
          error: (error, stack) => Text(
            error.toString(),
            style: AppTextStyles.caption.copyWith(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}

class _UploadProgressDialog extends StatefulWidget {
  const _UploadProgressDialog({Key? key}) : super(key: key);

  @override
  State<_UploadProgressDialog> createState() => _UploadProgressDialogState();
}

class _UploadProgressDialogState extends State<_UploadProgressDialog> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return false;
      setState(() {
        _progress += 0.08;
      });
      if (_progress >= 1.0) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Content uploaded & cataloged successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        return false;
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(
        'Uploading New Media',
        style: AppTextStyles.h2.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Processing raw file, compiling transcripts, and syncing to active servers...',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const Gap(16),
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: AppColors.border,
            color: AppColors.accent,
          ),
          const Gap(8),
          Text(
            '${(_progress * 100).clamp(0, 100).toInt()}% uploaded',
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 4. USER MANAGEMENT SCREEN
// -------------------------------------------------------------
class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _searchController = TextEditingController();
  String _filterQuery = '';

  final List<Map<String, String>> _usersList = [
    {
      'name': 'Emmanuel Adebayo',
      'email': 'emmanuel@gmail.com',
      'role': 'Partner',
      'date': 'Joined Jan 2026',
    },
    {
      'name': 'Sarah Jenkins',
      'email': 'sarah.j@outlook.com',
      'role': 'Member',
      'date': 'Joined Feb 2026',
    },
    {
      'name': 'Pastor Kingsley',
      'email': 'kingsley@unhindered.org',
      'role': 'Pastor',
      'date': 'Joined Jul 2024',
    },
    {
      'name': 'Sister Ruth',
      'email': 'ruth@gmail.com',
      'role': 'Admin',
      'date': 'Joined Dec 2025',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showRoleModifier(BuildContext context, Map<String, String> user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Modify Roster Role',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(4),
              Text(
                'Change system access privileges for ${user['name']}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const Gap(20),
              const Divider(color: AppColors.border),
              const Gap(12),
              ...['Member', 'Partner', 'Admin', 'Pastor'].map((role) {
                final isCurrent = user['role'] == role;
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      user['role'] = role;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${user['name']} has been promoted to $role!',
                        ),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          role,
                          style: TextStyle(
                            color: isCurrent
                                ? AppColors.accent
                                : AppColors.textPrimary,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                        if (isCurrent)
                          const Icon(
                            Icons.check_rounded,
                            color: AppColors.accent,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _usersList.where((u) {
      final name = u['name']!.toLowerCase();
      final email = u['email']!.toLowerCase();
      final query = _filterQuery.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'User Roster Management',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // SEARCH INPUT
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _filterQuery = val),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                hintText: 'Search roster by name or email...',
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: const BorderSide(color: AppColors.accent),
                ),
              ),
            ),
          ),

          // ROSTER LISTING
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No members found matching search.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingLg,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final user = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: JumCard(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 4.0,
                            ),
                            title: Text(
                              user['name']!,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['email']!,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const Gap(2),
                                Text(
                                  user['date']!,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    user['role']!.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => _showRoleModifier(context, user),
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

// -------------------------------------------------------------
// 5. DEPARTMENTS LIST SCREEN
// -------------------------------------------------------------
class DepartmentsListScreen extends StatelessWidget {
  const DepartmentsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final departments = [
      {
        'name': 'Ushering Unit',
        'leader': 'Sister Grace',
        'volunteers': '24 Volunteers',
        'schedule': 'Sundays 6:30 AM',
        'icon': Icons.supervised_user_circle_outlined,
      },
      {
        'name': 'Levites Choir',
        'leader': 'Brother Caleb',
        'volunteers': '18 Volunteers',
        'schedule': 'Saturdays 4:00 PM',
        'icon': Icons.music_note_outlined,
      },
      {
        'name': 'Media & Streaming',
        'leader': 'Brother David',
        'volunteers': '12 Volunteers',
        'schedule': 'Wednesdays 5:30 PM',
        'icon': Icons.video_camera_back_outlined,
      },
      {
        'name': 'Youth Fellowship',
        'leader': 'Brother Joshua',
        'volunteers': '45 Volunteers',
        'schedule': 'Fridays 6:00 PM',
        'icon': Icons.groups_outlined,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Church Departments',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final dept = departments[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: JumCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.surface2,
                          child: Icon(
                            dept['icon'] as IconData,
                            color: AppColors.accent,
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dept['name'] as String,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Leader: ${dept['leader']}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            dept['volunteers'] as String,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    const Divider(color: AppColors.border, height: 1),
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: AppColors.textMuted,
                              size: 16,
                            ),
                            const Gap(6),
                            Text(
                              dept['schedule'] as String,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            _showVolunteerManagement(
                              context,
                              dept['name'] as String,
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'Manage Volunteers',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(4),
                              const Icon(
                                Icons.arrow_forward,
                                color: AppColors.accent,
                                size: 14,
                              ),
                            ],
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
      ),
    );
  }

  void _showVolunteerManagement(BuildContext context, String deptName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      builder: (context) {
        return _VolunteerListModal(deptName: deptName);
      },
    );
  }
}

class _VolunteerListModal extends StatefulWidget {
  final String deptName;
  const _VolunteerListModal({Key? key, required this.deptName})
    : super(key: key);

  @override
  State<_VolunteerListModal> createState() => _VolunteerListModalState();
}

class _VolunteerListModalState extends State<_VolunteerListModal> {
  final List<Map<String, dynamic>> _volunteers = [
    {'name': 'Sarah Jenkins', 'active': true},
    {'name': 'Emmanuel Adebayo', 'active': true},
    {'name': 'Sister Ruth', 'active': false},
    {'name': 'Brother James', 'active': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.deptName} Roster',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Gap(4),
          const Text(
            'Toggle volunteer membership status',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const Gap(16),
          const Divider(color: AppColors.border),
          Expanded(
            child: ListView.builder(
              itemCount: _volunteers.length,
              itemBuilder: (context, index) {
                final vol = _volunteers[index];
                return SwitchListTile(
                  title: Text(
                    vol['name'] as String,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  value: vol['active'] as bool,
                  activeColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) {
                    setState(() {
                      vol['active'] = val;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AdminEventsScreen extends StatelessWidget {
  const AdminEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = [
      {
        'title': 'Night of Worship',
        'date': 'May 15, 2026',
        'status': 'Published',
        'rsvps': '246',
      },
      {
        'title': 'Leadership Intensive',
        'date': 'May 22, 2026',
        'status': 'Draft',
        'rsvps': '84',
      },
      {
        'title': 'Community Outreach',
        'date': 'June 1, 2026',
        'status': 'Published',
        'rsvps': '172',
      },
    ];

    return _AdminScaffold(
      title: 'Admin Events',
      actionLabel: 'Create Event',
      actionIcon: Icons.add,
      onAction: () => _showAdminSnack(context, 'Event draft created'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AdminMetricRow(
            items: const [
              _AdminMetric('3', 'Upcoming', Icons.event_available_outlined),
              _AdminMetric(
                '502',
                'Total RSVPs',
                Icons.confirmation_number_outlined,
              ),
              _AdminMetric('2', 'Published', Icons.public_outlined),
            ],
          ),
          const Gap(20),
          ...events.map(
            (event) => _AdminListTile(
              icon: Icons.event_note_outlined,
              title: event['title']!,
              subtitle: '${event['date']} • ${event['rsvps']} RSVPs',
              trailing: event['status']!,
              onTap: () => _showAdminSnack(context, '${event['title']} opened'),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminFormsScreen extends StatelessWidget {
  const AdminFormsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forms = [
      {
        'title': 'First-Time Visitor',
        'meta': '42 submissions this month',
        'status': 'Active',
      },
      {
        'title': 'Volunteer Signup',
        'meta': '18 pending reviews',
        'status': 'Active',
      },
      {
        'title': 'Prayer Request',
        'meta': '9 new requests',
        'status': 'Private',
      },
    ];

    return _AdminScaffold(
      title: 'Admin Forms',
      actionLabel: 'New Form',
      actionIcon: Icons.playlist_add,
      onAction: () => _showAdminSnack(context, 'Form builder opened'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AdminMetricRow(
            items: const [
              _AdminMetric('3', 'Forms', Icons.dynamic_form_outlined),
              _AdminMetric('69', 'Responses', Icons.inbox_outlined),
              _AdminMetric('18', 'Pending', Icons.pending_actions_outlined),
            ],
          ),
          const Gap(20),
          ...forms.map(
            (form) => _AdminListTile(
              icon: Icons.article_outlined,
              title: form['title']!,
              subtitle: form['meta']!,
              trailing: form['status']!,
              onTap: () =>
                  _showAdminSnack(context, '${form['title']} responses opened'),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminGivingScreen extends StatelessWidget {
  const AdminGivingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gifts = [
      {'name': 'Sarah Jenkins', 'fund': 'Tithe', 'amount': '\$150.00'},
      {'name': 'Brother James', 'fund': 'Missions', 'amount': '\$100.00'},
      {'name': 'Anonymous', 'fund': 'Offering', 'amount': '\$75.00'},
    ];

    return _AdminScaffold(
      title: 'Admin Giving',
      actionLabel: 'Export Report',
      actionIcon: Icons.download_outlined,
      onAction: () => _showAdminSnack(context, 'Giving report exported'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AdminMetricRow(
            items: const [
              _AdminMetric(
                '\$42.5k',
                'Monthly Giving',
                Icons.volunteer_activism_outlined,
              ),
              _AdminMetric('\$8.2k', 'Missions', Icons.public_outlined),
              _AdminMetric('128', 'Givers', Icons.people_outline),
            ],
          ),
          const Gap(20),
          Text(
            'Recent Gifts',
            style: AppTextStyles.overline.copyWith(fontWeight: FontWeight.bold),
          ),
          const Gap(8),
          ...gifts.map(
            (gift) => _AdminListTile(
              icon: Icons.receipt_long_outlined,
              title: gift['name']!,
              subtitle: gift['fund']!,
              trailing: gift['amount']!,
              onTap: () =>
                  _showAdminSnack(context, '${gift['name']} receipt opened'),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _approvalRequired = true;
  bool _liveChatEnabled = true;
  bool _givingReceipts = true;

  @override
  Widget build(BuildContext context) {
    return _AdminScaffold(
      title: 'Admin Settings',
      actionLabel: 'Save Changes',
      actionIcon: Icons.save_outlined,
      onAction: () => _showAdminSnack(context, 'Settings saved'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AdminSwitchTile(
            title: 'Require approval for new posts',
            subtitle: 'Route member posts through moderator review.',
            value: _approvalRequired,
            onChanged: (value) => setState(() => _approvalRequired = value),
          ),
          _AdminSwitchTile(
            title: 'Enable live stream chat',
            subtitle: 'Allow members to chat during active broadcasts.',
            value: _liveChatEnabled,
            onChanged: (value) => setState(() => _liveChatEnabled = value),
          ),
          _AdminSwitchTile(
            title: 'Send giving receipts automatically',
            subtitle: 'Email receipts after every successful contribution.',
            value: _givingReceipts,
            onChanged: (value) => setState(() => _givingReceipts = value),
          ),
        ],
      ),
    );
  }
}

class _AdminScaffold extends StatelessWidget {
  final String title;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback onAction;
  final Widget child;

  const _AdminScaffold({
    required this.title,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/admin'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        children: [
          JumButton(label: actionLabel, onPressed: onAction, isFullWidth: true),
          const Gap(20),
          child,
        ],
      ),
    );
  }
}

class _AdminMetricRow extends StatelessWidget {
  final List<_AdminMetric> items;

  const _AdminMetricRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 720 ? items.length : 1;
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: columns == 1 ? 3.8 : 2.4,
          children: items
              .map(
                (item) => JumCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingMd),
                    child: Row(
                      children: [
                        Icon(item.icon, color: AppColors.accent),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.value,
                                style: AppTextStyles.h2.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(item.label, style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _AdminMetric {
  final String value;
  final String label;
  final IconData icon;

  const _AdminMetric(this.value, this.label, this.icon);
}

class _AdminListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback onTap;

  const _AdminListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      child: JumCard(
        child: ListTile(
          leading: Icon(icon, color: AppColors.accent),
          title: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(subtitle, style: AppTextStyles.caption),
          trailing: Text(
            trailing,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _AdminSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AdminSwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      child: JumCard(
        child: SwitchListTile(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.accent,
          title: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(subtitle, style: AppTextStyles.caption),
        ),
      ),
    );
  }
}

void _showAdminSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColors.primary,
      duration: const Duration(seconds: 1),
    ),
  );
}
