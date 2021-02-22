import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:videochat/Veriables/globals.dart';

class CallScreen extends StatefulWidget {
  @override
  _CallScreenState createState() {
    return _CallScreenState();
  }
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Global.socketUtils.setOnMessageBackFromServer(onMessageBackFromServer);
  }

  @override
  Widget build(BuildContext context) {
    if (Global.webRTCUtils.remoteRenderer.srcObject == null)
      return Center(child: Text('Connecting...'));
    return SafeArea(
        child: Container(
            color: Colors.white,
            child:
                RTCVideoView(Global.webRTCUtils.remoteRenderer, mirror: true))
        /*   child: SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 2,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: localVideo(),
          ),
          remoteVideo(),
          /*Positioned(
                bottom: 0,
                child: Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.video_call,
                        color: Colors.red,
                        size: 50.0,
                      ),
                      Icon(
                        Icons.volume_mute,
                        color: Colors.red,
                        size: 50.0,
                      ),
                    ],
                  ),
                ),
              ),*/
        ],
      ),
    )*/
        );
  }
/*
  remoteVideo() {
    return new Container(
        height: 190.0,
        width: 190.0,
        key: new Key("local"),
        margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        decoration: new BoxDecoration(color: Colors.black),
        child:
            new RTCVideoView(Global.webRTCUtils.remoteRenderer, mirror: true));
  }

  localVideo() {
    return new Container(
        key: new Key("remote"),
        margin: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        decoration: new BoxDecoration(color: Colors.black),
        child: RTCVideoView(
          Global.webRTCUtils.remoteRenderer,
          mirror: true,
        ));
  } */

  onMessageBackFromServer(data) {
    print('data back from server shubham');
    print('shubham $data');
    if (data["message_sent_status"] == 10002 && data["chat_type"] == 'answer') {
      Global.webRTCUtils.sendAnswer();
    }
  }
}
