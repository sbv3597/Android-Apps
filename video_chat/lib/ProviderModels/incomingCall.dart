import 'package:flutter/cupertino.dart';

class IncomingCall extends ChangeNotifier {
  bool _callComing = false;
  bool getCallFlag() => _callComing;
  updateCallFlag() {
    _callComing = true;
    notifyListeners();
  }
}
