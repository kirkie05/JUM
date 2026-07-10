import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import '../../shared/widgets/jum_app_shell.dart';

// Import high-fidelity presentation screens
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/auth_screens.dart'
    show OnboardingScreen;
import '../../features/home/presentation/screens/home_screens.dart';
import '../../features/home/presentation/screens/search_screens.dart';
import '../../features/home/presentation/screens/notification_screens.dart';
import '../../features/community/presentation/screens/community_screens.dart';
import '../../features/community/presentation/screens/group_screens.dart';
import '../../features/sermons/presentation/screens/sermon_screens.dart';
import '../../features/sermons/presentation/screens/media_screens.dart';
import '../../features/giving/presentation/screens/giving_screens.dart';
import '../../features/gospel_army/presentation/screens/gospel_army_screens.dart';
import '../../features/events/presentation/screens/event_screens.dart';
import '../../features/bible/presentation/screens/bible_screens.dart';
import '../../features/bible/presentation/screens/bible_reading_plan_screen.dart';
import '../../features/messaging/presentation/screens/messaging_screens.dart';
import '../../features/marketplace/presentation/screens/marketplace_screens.dart';
import '../../features/profile/presentation/screens/profile_screens.dart';
import '../../features/admin/presentation/screens/admin_screens.dart';
import '../../features/admin/presentation/screens/admin_reading_plans_screen.dart';
import '../../features/forms/presentation/screens/form_screens.dart';
import '../../features/live/presentation/screens/live_stream_screen.dart';
import '../../features/live/presentation/screens/live_watch_screen.dart';
import '../../features/media/data/models/media_item.dart';
import '../../features/media/presentation/screens/media_player_screen.dart';

final appRouter = GoRouter(
  initialLocation: kIsWeb ? '/admin' : '/',
  routes: [
    // Auth routes
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
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

    // ShellRoute for BottomNav/LeftNav/TopNav
    ShellRoute(
      builder: (context, state, child) {
        int index = 0;
        final path = state.uri.toString();
        if (path.startsWith('/home/community')) {
          index = 1;
        } else if (path.startsWith('/home/media')) {
          index = 2;
        } else if (path.startsWith('/home/bible')) {
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
                context.go('/home/bible');
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
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/home/community',
          builder: (context, state) => const CommunityFeedScreen(),
        ),
        GoRoute(
          path: '/home/media',
          builder: (context, state) => const SermonListScreen(),
        ),
        GoRoute(
          path: '/home/bible',
          builder: (context, state) => const BibleReaderScreen(),
        ),
        GoRoute(
          path: '/home/give',
          builder: (context, state) => const GiveScreen(),
        ),
        GoRoute(
          path: '/home/give/categories',
          builder: (context, state) => const GiveCategoriesScreen(),
        ),
        GoRoute(
          path: '/home/give/payment',
          builder: (context, state) {
            final category = state.uri.queryParameters['category'] ?? 'General';
            return PaymentDetailScreen(category: category);
          },
        ),
        GoRoute(
          path: '/home/give/confirmation',
          builder: (context, state) {
            final amount = state.uri.queryParameters['amount'] ?? '0';
            final category = state.uri.queryParameters['category'] ?? 'General';
            final method = state.uri.queryParameters['method'] ?? 'Card';
            return GivingConfirmationScreen(
              amount: amount,
              category: category,
              method: method,
            );
          },
        ),
        GoRoute(
          path: '/home/more',
          builder: (context, state) => const MoreMenuScreen(),
        ),
        GoRoute(
          path: '/events',
          builder: (context, state) => const EventListScreen(),
        ),
        GoRoute(
          path: '/events/:id',
          builder: (context, state) =>
              EventDetailScreen(eventId: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: '/events/:id/ticket',
          builder: (context, state) =>
              TicketQrScreen(eventId: state.pathParameters['id'] ?? ''),
        ),
      ],
    ),

    // Other app sub-routes
    GoRoute(
      path: '/community/:postId',
      builder: (context, state) =>
          PostDetailScreen(postId: state.pathParameters['postId'] ?? ''),
    ),
    GoRoute(
      path: '/community/create-post',
      builder: (context, state) => const CreatePostScreen(),
    ),
    GoRoute(
      path: '/community/groups',
      builder: (context, state) => const GroupsListScreen(),
    ),
    GoRoute(
      path: '/community/groups/feed',
      builder: (context, state) => const GroupFeedScreen(),
    ),
    GoRoute(
      path: '/community/groups/chat/:id',
      builder: (context, state) => GroupChatScreen(
        conversationId: state.pathParameters['id'] ?? '',
        groupName: state.uri.queryParameters['name'] ?? 'Group Chat',
      ),
    ),
    GoRoute(
      path: '/sermons/:id',
      builder: (context, state) =>
          SermonDetailScreen(sermonId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/media/replays',
      builder: (context, state) => const ReplayListScreen(),
    ),
    GoRoute(
      path: '/media/audio-player',
      builder: (context, state) => const AudioPlayerScreen(),
    ),
    GoRoute(
      path: '/media/video-player',
      builder: (context, state) => const VideoPlayerScreen(),
    ),
    GoRoute(
      path: '/media/podcasts',
      builder: (context, state) => const PodcastListScreen(),
    ),
    GoRoute(
      path: '/media/podcast-episode',
      builder: (context, state) => const PodcastEpisodePlayerScreen(),
    ),
    GoRoute(
      path: '/media/stream-schedule',
      builder: (context, state) => const StreamScheduleScreen(),
    ),
    GoRoute(
      path: '/media/player',
      builder: (context, state) {
        final item = state.extra as MediaItem;
        return MediaPlayerScreen(item: item);
      },
    ),
    GoRoute(
      path: '/media/service-schedule',
      builder: (context, state) => const ServiceScheduleScreen(),
    ),
    GoRoute(
      path: '/live',
      builder: (context, state) => const LiveStreamScreen(),
    ),
    GoRoute(
      path: '/live/:id',
      builder: (context, state) =>
          LiveWatchScreen(streamId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/gospel_army',
      builder: (context, state) => const GospelArmyListScreen(),
    ),
    GoRoute(
      path: '/gospel_army/:courseId',
      builder: (context, state) =>
          GospelArmyDetailScreen(courseId: state.pathParameters['courseId'] ?? ''),
    ),
    GoRoute(
      path: '/gospel_army/:courseId/lesson/:lessonId',
      builder: (context, state) => LessonPlayerScreen(
        courseId: state.pathParameters['courseId'] ?? '',
        lessonId: state.pathParameters['lessonId'] ?? '',
      ),
    ),
    GoRoute(
      path: '/gospel_army/:courseId/lesson/:lessonId/quiz',
      builder: (context, state) => QuizScreen(
        courseId: state.pathParameters['courseId'] ?? '',
        lessonId: state.pathParameters['lessonId'] ?? '',
      ),
    ),
    GoRoute(
      path: '/bible/search',
      builder: (context, state) => const BibleSearchScreen(),
    ),
    GoRoute(
      path: '/bible',
      builder: (context, state) => const BibleReaderScreen(),
    ),
    GoRoute(
      path: '/bible/reading-plan',
      builder: (context, state) => const BibleReadingPlanScreen(),
    ),
    GoRoute(
      path: '/messaging',
      builder: (context, state) => const MessagingHomeScreen(),
    ),
    GoRoute(
      path: '/messaging/:id',
      builder: (context, state) =>
          ConversationScreen(peerId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/giving/history',
      builder: (context, state) => const GivingHistoryScreen(),
    ),
    GoRoute(
      path: '/giving/receipt/:id',
      builder: (context, state) =>
          GivingReceiptScreen(receiptId: state.pathParameters['id'] ?? ''),
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
      builder: (context, state) =>
          ProductDetailScreen(productId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/profile/settings',
      builder: (context, state) => const SettingsScreen(),
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
      builder: (context, state) => const UserManagementScreen(),
    ),
    GoRoute(
      path: '/admin/sermons',
      builder: (context, state) => const ContentManagementScreen(),
    ),
    GoRoute(
      path: '/admin/events',
      builder: (context, state) => const AdminEventsScreen(),
    ),
    GoRoute(
      path: '/admin/forms',
      builder: (context, state) => const AdminFormsScreen(),
    ),
    GoRoute(
      path: '/admin/giving',
      builder: (context, state) => const AdminGivingScreen(),
    ),
    GoRoute(
      path: '/admin/analytics',
      builder: (context, state) => const AnalyticsDashboardScreen(),
    ),
    GoRoute(
      path: '/admin/departments',
      builder: (context, state) => const DepartmentsListScreen(),
    ),
    GoRoute(
      path: '/admin/settings',
      builder: (context, state) => const AdminSettingsScreen(),
    ),
    GoRoute(
      path: '/admin/bible-plans',
      builder: (context, state) => const AdminReadingPlansScreen(),
    ),
  ],
  redirect: (context, state) {
    // If accessing via Web, force the user into the Admin dashboard zone.
    if (kIsWeb) {
      final currentPath = state.uri.toString();
      if (!currentPath.startsWith('/admin')) {
        return '/admin';
      }
    }
    return null;
  },
);
