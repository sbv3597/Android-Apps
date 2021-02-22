import 'package:flutter/material.dart';
import 'package:remindy/src/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {Home.route_id: (context) => Home()},
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      home: Home(),
    );
  }
}
