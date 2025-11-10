import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/diary/presentation/screens/home_screen.dart';
import '../../features/diary/presentation/screens/diary_write_screen.dart';
import '../../features/diary/presentation/screens/diary_detail_screen.dart';
import '../../features/statistics/presentation/screens/statistics_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/diary/write',
        name: 'diaryWrite',
        builder: (context, state) => const DiaryWriteScreen(),
      ),
      GoRoute(
        path: '/diary/:id',
        name: 'diaryDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DiaryDetailScreen(diaryId: id);
        },
      ),
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        builder: (context, state) => const StatisticsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
