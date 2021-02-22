import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remindy/Database/databaseHelper.dart';

class Globals {
  // reference to our single class that manages the database
  static final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
}
