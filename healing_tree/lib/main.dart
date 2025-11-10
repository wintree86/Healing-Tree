import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Database (Hive)
  final databaseService = DatabaseService();
  await databaseService.initialize();

  // TODO: Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(
    const ProviderScope(
      child: HealingTreeApp(),
    ),
  );
}

class HealingTreeApp extends ConsumerWidget {
  const HealingTreeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    // Watch settings for theme mode (for future implementation)
    // final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Healing Tree',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // TODO: Use themeMode from settings
      routerConfig: router,
    );
  }
}
