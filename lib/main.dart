// THE CHATOFI PROJECT

import 'package:chatofi/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ChatOFi());
}

class ChatOFi extends StatelessWidget {
  const ChatOFi({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ChatOFi",
      home: SplashScreen(),
    );
  }
}

// MADE BY PARTH THAKOR
