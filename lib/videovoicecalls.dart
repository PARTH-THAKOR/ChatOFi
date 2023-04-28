// VIDEO-VOICE CALLS ACTIVITY

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCall extends StatelessWidget {
  const VideoCall({Key? key, required this.callID}) : super(key: key);
  final String callID;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser?.phoneNumber;
    return ZegoUIKitPrebuiltCall(
      appID: 1082786651,
      appSign:
          "a75be6dd1bba8f33e9c60431caabf345be8270e9c5a4dcee793a724677f91773",
      userID: user.toString(),
      userName: user.toString(),
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}

class VoiceCall extends StatelessWidget {
  const VoiceCall({Key? key, required this.callID}) : super(key: key);
  final String callID;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser?.phoneNumber;
    return ZegoUIKitPrebuiltCall(
      appID: 1082786651,
      appSign:
          "a75be6dd1bba8f33e9c60431caabf345be8270e9c5a4dcee793a724677f91773",
      userID: user.toString(),
      userName: user.toString(),
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}
