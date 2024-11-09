import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/splash_screen.dart';

void main() async
{
    Client()
      .setEndpoint("https://cloud.appwrite.io/v1")
      .setProject("672cc1fd002f9dce00dd");
  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splashscreen',
      routes:
      {
        '/splashscreen' : (context) => const SplashScreen(),
      },
   )
  );
}

