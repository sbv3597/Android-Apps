import 'package:flutter/material.dart';
import 'package:videochat/ServerFiles/socketUtils.dart';
import 'package:videochat/WebRtc/webRtcUtils.dart';

class Global {
  static SocketUtils socketUtils;
  static WebRTCUtils webRTCUtils;
  static BuildContext currentContext;
  static String currentUser;
  static String toUser;
  static String candidate;
  static bool answer = false;
  static bool remote = false;

  static initSockets() {
    socketUtils = new SocketUtils();
  }

  static initWebRtc() {
    webRTCUtils = new WebRTCUtils();
  }
}
