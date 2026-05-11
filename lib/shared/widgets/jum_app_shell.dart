import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import 'jum_avatar.dart';
import 'glass_mesh_background.dart';
import '../../features/sermons/presentation/widgets/mini_player_bar.dart';

class JumAppShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final bool isAdminShell;

  const JumAppShell({
    Key? key,
    required this.child,
    required this.currentIndex,
    required this.onTabSelected,
    this.isAdminShell = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    Widget layout;

    if (isAdminShell || width >= 1024) {
      layout = _buildDesktopLayout(context);
    } else if (width >= 600) {
      layout = _buildTabletLayout(context);
    } else {
      layout = _buildMobileLayout(context);
    }

    return GlassMeshBackground(child: layout);
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: currentIndex == 1
          ? null
          : AppBar(
              title: const Text(
          'JUM',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            letterSpacing: 1.5,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary, size: 22),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 22),
            onPressed: () => context.push('/notifications'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: GestureDetector(
               onTap: () => context.push('/profile'),
              child: const JumAvatar(initials: 'JM', size: 30),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: child),
          const MiniPlayerBar(),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            color: Colors.black.withOpacity(0.2),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTabSelected,
              backgroundColor: Colors.transparent,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textMuted,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: AppStrings.home,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.forum_outlined),
                  label: AppStrings.community,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.play_circle_fill),
                  label: AppStrings.media,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_rounded),
                  label: AppStrings.bible,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: AppStrings.more,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
              child: Container(
                color: Colors.black.withOpacity(0.15),
                child: NavigationRail(
                  selectedIndex: currentIndex,
                  onDestinationSelected: onTabSelected,
                  backgroundColor: Colors.transparent,
                  selectedIconTheme: const IconThemeData(color: AppColors.primary),
                  unselectedIconTheme: const IconThemeData(color: AppColors.textMuted),
                  labelType: NavigationRailLabelType.none,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_filled),
                      selectedIcon: Icon(Icons.home_filled),
                      label: Text(AppStrings.home),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.forum_outlined),
                      selectedIcon: Icon(Icons.forum_outlined),
                      label: Text(AppStrings.community),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.play_circle_fill),
                      selectedIcon: Icon(Icons.play_circle_fill),
                      label: Text(AppStrings.media),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.menu_book_rounded),
                      selectedIcon: Icon(Icons.menu_book_rounded),
                      label: Text(AppStrings.bible),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.menu),
                      selectedIcon: Icon(Icons.menu),
                      label: Text(AppStrings.more),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1, color: AppColors.divider),
          Expanded(
            child: Column(
              children: [
                Expanded(child: child),
                const MiniPlayerBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
              child: Container(
                width: 240.0,
                color: Colors.black.withOpacity(0.15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.paddingLg),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: AppColors.primary, size: 28),
                          const SizedBox(width: AppSizes.paddingXs),
                          Expanded(
                            child: Text(
                              'JUM',
                              style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary, letterSpacing: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingXl),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSm),
                        children: [
                          _buildSidebarTile(0, Icons.home_filled, AppStrings.home),
                          _buildSidebarTile(1, Icons.forum_outlined, AppStrings.community),
                          _buildSidebarTile(2, Icons.play_circle_fill, AppStrings.media),
                          _buildSidebarTile(3, Icons.menu_book_rounded, AppStrings.bible),
                          _buildSidebarTile(4, Icons.menu, AppStrings.more),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    const Padding(
                      padding: EdgeInsets.all(AppSizes.paddingMd),
                      child: Row(
                        children: [
                          JumAvatar(initials: 'AD', size: AppSizes.avatarSm),
                          SizedBox(width: AppSizes.paddingSm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Church Admin',
                                  style: TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'admin@jum.org',
                                  style: TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 11, color: AppColors.textMuted),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1, color: AppColors.divider),
          Expanded(
            child: Column(
              children: [
                Expanded(child: child),
                const MiniPlayerBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarTile(int index, IconData icon, String label) {
    final isSelected = index == currentIndex;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ListTile(
        onTap: () => onTabSelected(index),
        selected: isSelected,
        selectedTileColor: AppColors.glassBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textMuted,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
