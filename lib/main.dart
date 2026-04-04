// lib/main.dart (Final - Cross-Platform)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/di/service_locator.dart';
import 'core/storage/storage_adapter.dart';
import 'core/network/network_adapter.dart';
import 'config/router.dart';
import 'presentation/utils/universal_platform.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Storage
  await StorageAdapter.initStorage();
  
  // Setup Network
  NetworkAdapter.setupDio();
  
  // Setup Service Locator
  await setupServiceLocator();
  
  runApp(
    const ProviderScope(
      child: SetRiseApp(),
    ),
  );
}

class SetRiseApp extends ConsumerWidget {
  const SetRiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SetRise',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      builder: (context, child) {
        // Set app scale for web
        if (UniversalPlatform.isWeb) {
          return Scaffold(
            body: child,
          );
        }
        return child ?? Container();
      },
    );
  }
}
