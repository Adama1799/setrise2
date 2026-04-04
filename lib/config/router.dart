import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/auth/splash_screen.dart';
import '../presentation/screens/dating/dating_discover_screen.dart';
import '../presentation/screens/dating/matches_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/live/go_live_screen.dart';
import '../presentation/screens/live/live_feed_screen.dart';
import '../presentation/screens/live/live_room_screen.dart';
import '../presentation/screens/music/music_home_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/rize/rize_feed_screen.dart';
import '../presentation/screens/set/set_feed_screen.dart';
import '../presentation/screens/shop/product_detail_screen.dart';
import '../presentation/screens/shop/shop_home_screen.dart';

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    
    // Redirect logic
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isGoingToAuth = state.matchedLocation.startsWith('/auth');
      final isSplash = state.matchedLocation == '/splash';

      // If not authenticated and not going to auth or splash, redirect to login
      if (!isAuthenticated && !isGoingToAuth && !isSplash) {
        return '/auth/login';
      }

      // If authenticated and going to auth, redirect to home
      if (isAuthenticated && isGoingToAuth) {
        return '/';
      }

      return null;
    },

    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/auth',
        redirect: (context, state) => '/auth/login',
      ),
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Home (Main Navigation)
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Set Feed
      GoRoute(
        path: '/set',
        name: 'set',
        builder: (context, state) => const SetFeedScreen(),
      ),

      // Rize (Short Videos)
      GoRoute(
        path: '/rize',
        name: 'rize',
        builder: (context, state) => const RizeFeedScreen(),
      ),

      // Live Streaming
      GoRoute(
        path: '/live',
        name: 'live',
        builder: (context, state) => const LiveFeedScreen(),
        routes: [
          GoRoute(
            path: 'go-live',
            name: 'go-live',
            builder: (context, state) => const GoLiveScreen(),
          ),
          GoRoute(
            path: ':streamId',
            name: 'live-room',
            builder: (context, state) {
              final streamId = state.pathParameters['streamId']!;
              return LiveRoomScreen(streamId: streamId);
            },
          ),
        ],
      ),

      // Dating
      GoRoute(
        path: '/dating',
        name: 'dating',
        builder: (context, state) => const DatingDiscoverScreen(),
        routes: [
          GoRoute(
            path: 'matches',
            name: 'matches',
            builder: (context, state) => const MatchesScreen(),
          ),
        ],
      ),

      // Music
      GoRoute(
        path: '/music',
        name: 'music',
        builder: (context, state) => const MusicHomeScreen(),
      ),

      // Shop
      GoRoute(
        path: '/shop',
        name: 'shop',
        builder: (context, state) => const ShopHomeScreen(),
        routes: [
          GoRoute(
            path: 'product/:productId',
            name: 'product-detail',
            builder: (context, state) {
              final productId = state.pathParameters['productId']!;
              return ProductDetailScreen(productId: productId);
            },
          ),
        ],
      ),

      // Profile
      GoRoute(
        path: '/profile/:userId',
        name: 'profile',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return ProfileScreen(userId: userId);
        },
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '404 - Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
