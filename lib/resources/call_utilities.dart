import 'dart:math';

import 'package:doctor/callscreens/videocallscreen.dart';
import 'package:doctor/callscreens/voicecallscreen.dart';
import 'package:doctor/model/call.dart';
import 'package:doctor/model/person/user.dart';
import 'package:doctor/resources/call_methods.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial(BuildContext context, {required User from, required User to, isVideo = true}) async {
    Call call = Call(
      callerId: from.email,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.email,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000).toString()}',
      type: isVideo,
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => isVideo ? VideoCallScreen(call: call) : VoiceCallScreen(call: call),
          ));
    }
  }
}
