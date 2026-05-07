import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/main/main_screen.dart';
import 'presentation/screens/shop/material_shop/models/product_model.dart';
import 'presentation/screens/shop/material_shop/screens/product/product_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final product = state.extra as ProductModel;
        return ProductPage(product: product);
      },
    ),
  ],
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(
    const ProviderScope(
      child: SetRiseApp(),
    ),
  );
}

class SetRiseApp extends StatelessWidget {
  const SetRiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SetRise',
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}
