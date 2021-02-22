import 'package:flutter/material.dart';
import 'package:videochat/Screens/callScreen.dart';
import 'package:videochat/Veriables/globals.dart';

class ShowSnackbar {
  static showCallDialog(String username, sdp) {
    return showDialog(
      context: Global.currentContext,
      builder: (context) {
        return AlertDialog(
          title: Text('Incoming Call'),
          content: Text('You are getting a call from $username'),
          actions: [
            RaisedButton(
                child: Text('Answer'),
                onPressed: () async {
                  await Global.webRTCUtils.setRemoteDescription(sdp, true);
                  await Global.webRTCUtils.createAnswer();

                  // await Global.webRTCUtils.sendAnswer();
                })
          ],
        );
      },
    );
  }
}
