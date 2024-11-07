import 'dart:async';
import 'package:flutter/material.dart';
import 'package:social_media_app/controller/auth_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
    void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const AuthPage()));
    });
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
