// lib/config/router.dart (Final Updated)
import 'package:go_router/go_router.dart';
import '../presentation/screens/auth/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/set/set_feed_screen.dart';
import '../presentation/screens/rize/rize_feed_screen.dart';
import '../presentation/screens/live/live_feed_screen.dart';
import '../presentation/screens/live/go_live_screen.dart';
import '../presentation/screens/shop/shop_home_screen.dart';
import '../presentation/screens/shop/product_detail_screen.dart';
import '../presentation/screens/dating/dating_discover_screen.dart';
import '../presentation/screens/dating/matches_screen.dart';
import '../presentation/screens/music/music_home_screen.dart';
import '../presentation/screens/profile/user_profile_screen.dart';
import '../presentation/screens/explore/search_screen.dart';
import '../presentation/screens/main_navigation_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainNavigationScreen(),
    ),
    // Set Routes
    GoRoute(
      path: '/set',
      builder: (context, state) => const SetFeedScreen(),
    ),
    // Rize Routes
    GoRoute(
      path: '/rize',
      builder: (context, state) => const RizeFeedScreen(),
    ),
    // Live Routes
    GoRoute(
      path: '/live',
      builder: (context, state) => const LiveFeedScreen(),
    ),
    GoRoute(
      path: '/go-live',
      builder: (context, state) => const GoLiveScreen(),
    ),
    // Shop Routes
    GoRoute(
      path: '/shop',
      builder: (context, state) => const ShopHomeScreen(),
    ),
    GoRoute(
      path: '/shop/product/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
    // Dating Routes
    GoRoute(
      path: '/dating',
      builder: (context, state) => const DatingDiscoverScreen(),
    ),
    GoRoute(
      path: '/dating/matches',
      builder: (context, state) => const MatchesScreen(),
    ),
    // Music Routes
    GoRoute(
      path: '/music',
      builder: (context, state) => const MusicHomeScreen(),
    ),
    // Profile Routes
    GoRoute(
      path: '/user/:id',
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return UserProfileScreen(userId: userId);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);

ra
