import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:videochat/Screens/dialer.dart';
import 'package:videochat/Veriables/globals.dart';
import 'package:videochat/users.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Global.initSockets();
    Global.initWebRtc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Chat'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          RaisedButton(
            child: Text('UserA'),
            onPressed: () async {
              Global.currentUser = Users.userA;
              Global.toUser = Users.userB;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Dialer(Users.userA)));
            },
          ),
          RaisedButton(
            child: Text('UserB'),
            onPressed: () async {
              Global.currentUser = Users.userB;
              Global.toUser = Users.userA;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Dialer(Users.userB)));
            },
          )
        ],
      ),
    );
  }
}
