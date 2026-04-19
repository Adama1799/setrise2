import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'config/router.dart';

class SetRiseApp extends StatelessWidget {
  const SetRiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Setrise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
