import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:videochat/Models/message.dart';
import 'package:videochat/Screens/callScreen.dart';
import 'package:videochat/Veriables/globals.dart';

class WebRTCUtils {
  RTCPeerConnection peerConnection;
  MediaStream localStream;
  RTCVideoRenderer localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = new RTCVideoRenderer();
  String Lcandidate;
  var answersdp;
  Future<void> initWebRtc() async {
    await initRenderers();
    _createPeerConnection().then((pc) {
      peerConnection = pc;
    });
  }

  initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    localStream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);
    // if (pc != null) print(pc);
    pc.addStream(localStream);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        Lcandidate = json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMlineIndex,
        });
      }
    };

    pc.onIceConnectionState = (e) {
      print('Shubham $e');
    };

    pc.onAddStream = (stream) {
      print('Shubham you recivd ${stream.ownerTag}stream');
      //  print('addStream: ' + stream.id);
      remoteRenderer.srcObject = stream;
      Navigator.push(Global.currentContext,
          MaterialPageRoute(builder: (context) => CallScreen()));
    };

    return pc;
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'facingMode': 'user',
      },
    };
    MediaStream stream = await navigator.getUserMedia(mediaConstraints);

    // localStream = stream;
    localRenderer.srcObject = stream;
    //= true;

    // _peerConnection.addStream(stream);

    return stream;
  }

  Future<void> addCandidate(jsonString) async {
    print('Shubham add candidate');
    dynamic session = await jsonDecode('$jsonString');
    // print(session['candidate']);
    dynamic candidate = new RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await peerConnection.addCandidate(candidate);
  }

  Future<String> createOffer() async {
    RTCSessionDescription description =
        await peerConnection.createOffer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp);
    print(json.encode(session));

    // print(json.encode({
    //       'sdp': description.sdp.toString(),
    //       'type': description.type.toString(),
    //     }));

    await peerConnection.setLocalDescription(description);
    Global.socketUtils.sendSingleChatMessage(Chat(
      chatId: '1',
      toUser: Global.toUser,
      fromUser: Global.currentUser,
      message: json.encode(session),
      chatType: 'offer',
    ));
    return description.sdp;
  }

  Future<void> createAnswer() async {
    RTCSessionDescription description =
        await peerConnection.createAnswer({'offerToReceiveVideo': 1});

    var session = parse(description.sdp);
    print(json.encode(session));
    // print(json.encode({
    //       'sdp': description.sdp.toString(),
    //       'type': description.type.toString(),
    //     }));

    await peerConnection.setLocalDescription(description);
    await Global.socketUtils.sendSingleChatMessage(Chat(
      chatId: '2',
      toUser: Global.toUser,
      fromUser: Global.currentUser,
      message: json.encode(session),
      chatType: 'answer',
    ));
  }

  Future<void> setRemoteDescription(jsonString, bool offer) async {
    dynamic session = await jsonDecode('$jsonString');

    String sdp = write(session, null);

    // RTCSessionDescription description =
    //     new RTCSessionDescription(session['sdp'], session['type']);
    RTCSessionDescription description =
        new RTCSessionDescription(sdp, offer ? 'offer' : 'answer');
    //  print(description.toMap());

    await peerConnection.setRemoteDescription(description);

    if (Global.candidate != null) {
      print('shubham $Global.candidate');
      await Global.webRTCUtils.addCandidate(Global.candidate);
    }
    Global.remote = true;
  }

  Future<void> sendAnswer() async {
    if (Lcandidate != null) {
      print('candidate shubham $Lcandidate');
      await Global.socketUtils.sendSingleChatMessage(Chat(
        chatId: '3',
        toUser: Global.toUser,
        fromUser: Global.currentUser,
        message: Lcandidate,
        chatType: 'candidate',
      ));
      return;
    } else
      sendAnswer();
  }

  disposeWebRtc() {
    localRenderer.dispose();
    remoteRenderer.dispose();
  }
}
