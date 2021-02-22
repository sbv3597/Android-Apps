import 'package:remindy/Database/databaseHelper.dart';

class Reminder {
  final int id;
  final String title;
  final DateTime time;
  final String description;
  final bool isDone;
  bool isSelected;
  String shortDesc;

  Reminder(
      {this.id,
      this.title,
      this.time,
      this.description,
      this.isDone = false,
      this.isSelected = false}) {
    if (description != null) {
      if (description.length > 20) {
        this.shortDesc = description.substring(1, 20) + '...';
      } else
        this.shortDesc = description + '...';
    }
  }

  Map toMap() {
    Map<String, dynamic> map = {
      DatabaseHelper.columnTitle: title,
      DatabaseHelper.columnDescription: description,
      DatabaseHelper.columnIsDone: (isDone ? 1 : 0),
      //  DatabaseHelper.columnRepeat: (isRepeat ? 1 : 0),
      DatabaseHelper.columnTime: time.toIso8601String(),
    };
    if (id != null) {
      map[DatabaseHelper.columnId] = id;
    }

    return map;
  }

  static Reminder fromMap(Map map) {
    Reminder r = new Reminder(
      id: map[DatabaseHelper.columnId],
      description: map[DatabaseHelper.columnDescription],
      time: DateTime.parse(map[DatabaseHelper.columnTime]),
      isDone: map[DatabaseHelper.columnIsDone] == 1 ? true : false,
      // isRepeat: map[DatabaseHelper.columnRepeat] == 1 ? true : false,
      title: map[DatabaseHelper.columnTitle],
    );
    return r;
  }
}
