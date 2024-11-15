import 'dart:async';
import 'package:flutter/material.dart';
import 'package:social_media_app/controller/navbar.dart';
import 'package:social_media_app/screens/onboarding.dart';
import 'package:social_media_app/services/appwrite_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppwriteService appwriteService = AppwriteService();
  @override
    void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final session = await appwriteService.getCurrentSession();

    if (session != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navbar()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage('assets/images/splash.png')
        )
      ),
    );
  }
}
