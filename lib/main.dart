import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/colors.dart';
import 'screens/feed/feed_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const SetRiseApp());
}

class SetRiseApp extends StatelessWidget {
  const SetRiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SetRise',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: kBg,
          elevation: 0,
          iconTheme: IconThemeData(color: kWhite),
          titleTextStyle: TextStyle(
            color: kWhite, fontSize: 18,
            fontWeight: FontWeight.w900, fontFamily: 'HarmonyOS',
          ),
        ),
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'HarmonyOS'),
      ),
      home: const FeedScreen(),
    );
  }
}