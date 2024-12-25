import 'package:bookrim/home.dart';
import 'package:flutter/material.dart';
import 'splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // المسار الأول عند بدء التطبيق
      routes: {
        '/home': (context) => const PostView(), // الشاشة الرئيسية
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Using the existing splash screen
    );
  }
}
