// FINGERPRINT LOCK ACTIVITY

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';

class FingerLock extends StatelessWidget {
  const FingerLock({Key? key}) : super(key: key);

  checkSensor() async {
    LocalAuthentication localAuthentication = LocalAuthentication();
    try {
      bool hasSensor = await localAuthentication.canCheckBiometrics;
      if (hasSensor == true) {
        getFingerAuth();
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  getFingerAuth() async {
    LocalAuthentication localAuthentication = LocalAuthentication();
    try {
      bool isAuthanticataed = await localAuthentication.authenticate(
          localizedReason: "Scan your Finger to access this App.",
          options: const AuthenticationOptions(
              biometricOnly: true, useErrorDialogs: true, stickyAuth: true));
      debugPrint(isAuthanticataed.toString());
      if (isAuthanticataed == false) {
        exit(0);
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(msg: "App is Locked for 30 Seconds");
      Timer(const Duration(seconds: 1), () {
        exit(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
