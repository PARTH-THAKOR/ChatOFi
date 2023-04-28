// SPLASH ACTIVITY

import 'package:chatofi/fingerprintlock.dart';
import 'package:chatofi/login.dart';
import 'package:chatofi/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getDarkModeSwitch();
    getFingerLockSwitch();
    logIn(context);
    super.initState();
  }

  getFingerLockSwitch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey("fp")) {
      setState(() {
        fingerlock = sharedPreferences.getBool("fp")!;
        if (fingerlock == true) {
          const FingerLock().checkSensor();
        }
      });
    } else {
      setState(() {
        fingerlock = false;
      });
    }
  }

  getDarkModeSwitch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey("dm")) {
      setState(() {
        darkmode = sharedPreferences.getBool("dm")!;
      });
    } else {
      setState(() {
        darkmode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return splashScreenPage();
  }
}

splashScreenPage() {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFF212121)),
    ),
    backgroundColor: (darkmode) ? const Color(0xFF212121) : Colors.white,
    body: ListView(children: [
      Container(
        margin: const EdgeInsets.only(top: 300),
        alignment: Alignment.center,
        child: Text('ChatOFi',
            style: TextStyle(
                fontSize: 50,
                color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
                fontWeight: FontWeight.bold)),
      ),
      Container(
        margin: const EdgeInsets.only(top: 310),
        alignment: Alignment.center,
        child: Text('developers.roundrobin',
            style: TextStyle(
                color: (darkmode) ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
    ]),
  );
}
