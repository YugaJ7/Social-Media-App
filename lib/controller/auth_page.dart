import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/homescreen.dart';
import 'package:social_media_app/screens/onboarding.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              snapshot.data!.displayName ?? "User";
              return HomeScreen();
            } else {
              return  OnboardingScreen();
            }
          })),
    );
  }
}