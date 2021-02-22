import 'package:remindy/GlobalVariables/globals.dart';

class CancelReminder {
  static cancel(int id) async {
    await Globals.databaseHelper.delete(id);
    await Globals.flutterLocalNotificationsPlugin.cancel(id);
  }
}
