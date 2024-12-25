// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to Home after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/home'); // Adjust route as needed
    });
  }

  final Color primaryColor = const Color(0xFF8A7CA3);
  final Color accentColor = const Color(0xFF1ABC9C);
  final Color backgroundColor = const Color(0xFFF5E6D3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // Background color for branding
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon or Logo
            // Icon(
            //   Icons.picture_as_pdf, // Use your app icon or logo here
            //   size: 100,
            //   color: Colors.white,
            // ),
            Image(image: AssetImage('assets/1.png')),
            SizedBox(height: 20),
            // App Title
            Text(
              'UNIVERSTY ARCHIVES NKTT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Subtitle or Tagline
            Text(
              'أرشيف لكل المراجع الجامعية ',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 30),
            // Loading Indicator
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
