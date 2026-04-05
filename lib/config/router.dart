import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/main/main_screen.dart';
import '../presentation/screens/set/set_screen.dart';
import '../presentation/screens/rize/rize_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/messages/messages_screen.dart';
import '../presentation/screens/search/search_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/set',
      builder: (context, state) => const SetScreen(),
    ),
    GoRoute(
      path: '/rize',
      builder: (context, state) => const RizeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/messages',
      builder: (context, state) => const MessagesScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);
