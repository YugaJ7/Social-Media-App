import 'package:flutter/material.dart';
import 'package:social_media_app/screens/splash_screen.dart';


void main() {
  runApp(FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: "eCommerce App",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}