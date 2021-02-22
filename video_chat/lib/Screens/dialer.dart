import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:videochat/Models/message.dart';
import 'package:videochat/Veriables/globals.dart';
import 'package:videochat/Widgets/showSnackbar.dart';

import 'callScreen.dart';

class Dialer extends StatefulWidget {
  final String user;

  const Dialer(this.user);
  @override
  _DialerState createState() => _DialerState();
}

class _DialerState extends State<Dialer> {
  bool _connectedToSocket;

  String _errorConnectMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connectedToSocket = false;
    _errorConnectMessage = 'Connecting';
    connectToSocket();
  }

  connectToSocket() async {
    setState(() {
      _connectedToSocket = false;
      _errorConnectMessage = 'Connecting';
    });
    await Global.socketUtils.initSocket(widget.user);

    Global.socketUtils.connectToSocket();
    Global.socketUtils.setConnectListener(onConnect);
    Global.socketUtils.setOnDisconnectListener(onDisconnect);
    Global.socketUtils.setOnErrorListener(onError);
    Global.socketUtils.setOnConnectionErrorListener(onConnectError);
    Global.socketUtils.setOnChatMessageReceivedListener(onChatMessageReceived);
    await _connectToCall();
  }

  @override
  Widget build(BuildContext context) {
    Global.currentContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Call User'),
      ),
      body: (_connectedToSocket &&
              _errorConnectMessage != 'Connecting' &&
              Global.webRTCUtils.peerConnection != null)
          ? SafeArea(
              child: RaisedButton(
                  child: Icon(
                    Icons.video_call,
                    color: Colors.green,
                  ),
                  onPressed: () async {
                    await Global.webRTCUtils.createOffer();
                  }))
          : (_errorConnectMessage == 'Connecting'
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                    children: [
                      Text(
                        _errorConnectMessage,
                        style: TextStyle(
                            backgroundColor: Colors.yellow, color: Colors.red),
                      ),
                      RaisedButton(
                        onPressed: () {
                          this.connectToSocket();
                        },
                        child: Text('Reconnect'),
                      )
                    ],
                  ),
                )),
    );
  }

  Future<void> _connectToCall() async {
    await Global.webRTCUtils.initWebRtc();
  }

  onConnect(data) {
    print('Connected $data');
    setState(() {
      _errorConnectMessage = 'No error';
      _connectedToSocket = true;
    });
  }

  onConnectError(data) {
    print('onConnectError $data');
    setState(() {
      _connectedToSocket = false;
      _errorConnectMessage = 'Failed to Connect';
    });
  }

  onConnectTimeout(data) {
    print('onConnectTimeout $data');
    setState(() {
      _connectedToSocket = false;
      _errorConnectMessage = 'Connection timedout';
    });
  }

  onError(data) {
    print('onError $data');
    setState(() {
      _connectedToSocket = false;
      _errorConnectMessage = 'Connection Failed';
    });
  }

  onDisconnect(data) {
    print('onDisconnect $data');
    setState(() {
      _connectedToSocket = false;
      _errorConnectMessage = 'Disconnected';
    });
  }

  onChatMessageReceived(data) async {
    // print('shubham $data');
    if (null == data || data.toString().isEmpty) {
      return;
    }
    Chat sdpDescription = Chat.fromJson(data);
    if (sdpDescription.chatType == 'offer') {
      print('shubham ${sdpDescription.message}');
      ShowSnackbar.showCallDialog(
          sdpDescription.fromUser, sdpDescription.message);
      return;
    } else if (sdpDescription.chatType == 'answer') {
      await Global.webRTCUtils
          .setRemoteDescription(sdpDescription.message, false);
      return;
    }
    if (sdpDescription.chatType == 'candidate') if (Global.remote == true) {
      if (sdpDescription.message != null) {
        print('Shubham here also');
        await Global.webRTCUtils.addCandidate(sdpDescription.message);
      }
    } else {
      if (sdpDescription.message != null)
        Global.candidate = sdpDescription.message;
    }
  }
}
