import 'package:flutter/material.dart';
import 'package:social_media_app/screens/homescreen.dart';
import 'package:social_media_app/screens/onboarding.dart';
import 'package:social_media_app/services/appwrite_service.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppwriteService appwriteService = AppwriteService();
    return Scaffold(
      body: FutureBuilder(
        future: appwriteService.getCurrentSession(),
          builder: ((context, snapshot) {
            if (snapshot.hasData  && snapshot.data != null) {
              return HomeScreen();
            } else {
              return  OnboardingScreen();
            }
          })),
    );
  }
}