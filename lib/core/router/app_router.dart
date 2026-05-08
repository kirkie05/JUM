import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/jum_app_bar.dart';
import '../../shared/widgets/jum_app_shell.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

// Import high-fidelity presentation screens
import '../../features/auth/presentation/screens/auth_screens.dart';
import '../../features/home/presentation/screens/home_screens.dart';
import '../../features/home/presentation/screens/search_screens.dart';
import '../../features/home/presentation/screens/notification_screens.dart';
import '../../features/community/presentation/screens/community_screens.dart';
import '../../features/sermons/presentation/screens/sermon_screens.dart';
import '../../features/giving/presentation/screens/giving_screens.dart';
import '../../features/school/presentation/screens/school_screens.dart';
import '../../features/events/presentation/screens/event_screens.dart';
import '../../features/bible/presentation/screens/bible_screens.dart';
import '../../features/messaging/presentation/screens/messaging_screens.dart';
import '../../features/marketplace/presentation/screens/marketplace_screens.dart';
import '../../features/profile/presentation/screens/profile_screens.dart';
import '../../features/admin/presentation/screens/admin_screens.dart';
import '../../features/forms/presentation/screens/form_screens.dart';
import '../../features/live/presentation/screens/live_stream_screen.dart';
import '../../features/live/presentation/screens/live_watch_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Auth routes
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/church-select',
      builder: (context, state) => const ChurchSelectScreen(),
    ),

    // ShellRoute for BottomNav/LeftNav/TopNav
    ShellRoute(
      builder: (context, state, child) {
        int index = 0;
        final path = state.uri.toString();
        if (path.startsWith('/home/community')) {
          index = 1;
        } else if (path.startsWith('/home/media')) {
          index = 2;
        } else if (path.startsWith('/home/give')) {
          index = 3;
        } else if (path.startsWith('/home/more')) {
          index = 4;
        }
        return JumAppShell(
          currentIndex: index,
          onTabSelected: (newIndex) {
            switch (newIndex) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.go('/home/community');
                break;
              case 2:
                context.go('/home/media');
                break;
              case 3:
                context.go('/home/give');
                break;
              case 4:
                context.go('/home/more');
                break;
            }
          },
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/home/community',
          builder: (context, state) => const CommunityFeedScreen(),
        ),
        GoRoute(
          path: '/home/media',
          builder: (context, state) => const SermonListScreen(),
        ),
        GoRoute(
          path: '/home/give',
          builder: (context, state) => const GiveScreen(),
        ),
        GoRoute(
          path: '/home/more',
          builder: (context, state) => const MoreMenuScreen(),
        ),
      ],
    ),

    // Other app sub-routes
    GoRoute(
      path: '/community/:postId',
      builder: (context, state) => PostDetailScreen(postId: state.pathParameters['postId'] ?? ''),
    ),
    GoRoute(
      path: '/sermons/:id',
      builder: (context, state) => SermonDetailScreen(sermonId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/live',
      builder: (context, state) => const LiveStreamScreen(),
    ),
    GoRoute(
      path: '/live/:id',
      builder: (context, state) => LiveWatchScreen(streamId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/school',
      builder: (context, state) => const SchoolListScreen(),
    ),
    GoRoute(
      path: '/school/:courseId',
      builder: (context, state) => SchoolDetailScreen(courseId: state.pathParameters['courseId'] ?? ''),
    ),
    GoRoute(
      path: '/school/:courseId/lesson/:lessonId',
      builder: (context, state) => LessonPlayerScreen(
        courseId: state.pathParameters['courseId'] ?? '',
        lessonId: state.pathParameters['lessonId'] ?? '',
      ),
    ),
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventListScreen(),
    ),
    GoRoute(
      path: '/events/:id',
      builder: (context, state) => EventDetailScreen(eventId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/bible',
      builder: (context, state) => const BibleReaderScreen(),
    ),
    GoRoute(
      path: '/messaging',
      builder: (context, state) => const MessagingHomeScreen(),
    ),
    GoRoute(
      path: '/messaging/:id',
      builder: (context, state) => ConversationScreen(peerId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/giving/history',
      builder: (context, state) => const GivingHistoryScreen(),
    ),
    GoRoute(
      path: '/giving/receipt/:id',
      builder: (context, state) => PlaceholderScreen(title: 'Receipt Screen: ${state.pathParameters['id']}'),
    ),
    GoRoute(
      path: '/forms',
      builder: (context, state) => const GenericFormScreen(),
    ),
    GoRoute(
      path: '/forms/success',
      builder: (context, state) {
        final id = state.uri.queryParameters['id'] ?? 'JUM-00000';
        return SubmissionSuccessScreen(referenceId: id);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const GlobalSearchScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/marketplace',
      builder: (context, state) => const ProductListScreen(),
    ),
    GoRoute(
      path: '/marketplace/:id',
      builder: (context, state) => ProductDetailScreen(productId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const PlaceholderScreen(title: 'Edit Profile Screen'),
    ),
    GoRoute(
      path: '/profile/orders',
      builder: (context, state) => const MyOrdersScreen(),
    ),

    // Admin routes with admin layout forced
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin/members',
      builder: (context, state) => const PlaceholderScreen(title: 'Admin Members', isAdmin: true),
    ),
    GoRoute(
      path: '/admin/sermons',
      builder: (context, state) => const PlaceholderScreen(title: 'Admin Sermons', isAdmin: true),
    ),
    GoRoute(
      path: '/admin/events',
      builder: (context, state) => const PlaceholderScreen(title: 'Admin Events', isAdmin: true),
    ),
    GoRoute(
      path: '/admin/forms',
      builder: (context, state) => const PlaceholderScreen(title: 'Admin Forms', isAdmin: true),
    ),
    GoRoute(
      path: '/admin/giving',
      builder: (context, state) => const PlaceholderScreen(title: 'Admin Giving', isAdmin: true),
    ),
    GoRoute(
      path: '/admin/analytics',
      builder: (context, state) => const PlaceholderScreen(title: 'Admin Analytics', isAdmin: true),
    ),
    GoRoute(
      path: '/admin/settings',
      builder: (context, state) => const PlaceholderScreen(title: 'Admin Settings', isAdmin: true),
    ),
  ],
  redirect: (context, state) {
    // Standard redirect placeholder
    return null;
  },
);

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final bool isAdmin;

  const PlaceholderScreen({
    Key? key,
    required this.title,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyContent = Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.blur_on_rounded,
              size: 64.0,
              color: AppColors.accent,
            ),
            const SizedBox(height: AppSizes.paddingMd),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingXs),
            const Text(
              'Feature Screen Skeleton',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingLg),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: [
                _buildRouteButton(context, 'Splash', '/'),
                _buildRouteButton(context, 'Onboarding', '/onboarding'),
                _buildRouteButton(context, 'Sign In', '/sign-in'),
                _buildRouteButton(context, 'Sign Up', '/sign-up'),
                _buildRouteButton(context, 'Church Select', '/church-select'),
                _buildRouteButton(context, 'Home Shell', '/home'),
                _buildRouteButton(context, 'Sermon Detail', '/sermons/sample-id'),
                _buildRouteButton(context, 'Live streams', '/live'),
                _buildRouteButton(context, 'School', '/school'),
                _buildRouteButton(context, 'Course Detail', '/school/course-101'),
                _buildRouteButton(context, 'Events', '/events'),
                _buildRouteButton(context, 'Bible', '/bible'),
                _buildRouteButton(context, 'Messaging', '/messaging'),
                _buildRouteButton(context, 'Giving History', '/giving/history'),
                _buildRouteButton(context, 'Marketplace', '/marketplace'),
                _buildRouteButton(context, 'Profile', '/profile'),
                _buildRouteButton(context, 'Admin Dashboard', '/admin'),
              ],
            ),
            if (isAdmin) ...[
              const SizedBox(height: AppSizes.paddingLg),
              const Divider(color: AppColors.divider),
              const SizedBox(height: AppSizes.paddingSm),
              const Text(
                'Admin Sub-routes',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.paddingSm),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  _buildRouteButton(context, 'Members', '/admin/members'),
                  _buildRouteButton(context, 'Sermons', '/admin/sermons'),
                  _buildRouteButton(context, 'Events', '/admin/events'),
                  _buildRouteButton(context, 'Forms', '/admin/forms'),
                  _buildRouteButton(context, 'Giving', '/admin/giving'),
                  _buildRouteButton(context, 'Analytics', '/admin/analytics'),
                  _buildRouteButton(context, 'Settings', '/admin/settings'),
                ],
              ),
            ],
          ],
        ),
      ),
    );

    if (isAdmin) {
      return JumAppShell(
        currentIndex: 4, // More/Admin
        isAdminShell: true,
        onTabSelected: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/home/community');
          if (index == 2) context.go('/home/media');
          if (index == 3) context.go('/home/give');
          if (index == 4) context.go('/home/more');
        },
        child: Scaffold(
          appBar: JumAppBar(title: title, showBack: true),
          body: bodyContent,
        ),
      );
    }

    return Scaffold(
      appBar: JumAppBar(title: title, showBack: true),
      body: bodyContent,
    );
  }

  Widget _buildRouteButton(BuildContext context, String label, String route) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          border: Border.all(color: AppColors.border, width: 0.5),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.0,
            color: AppColors.accent,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
