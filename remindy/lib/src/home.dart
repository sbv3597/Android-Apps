import 'dart:async';
import 'package:flutter/material.dart';
import 'package:remindy/GlobalVariables/globals.dart';
import 'package:remindy/HelperMethods/formatDate.dart';
import 'package:remindy/Models/simpleReminder.dart';
import 'package:remindy/src/cancelReminder.dart';
import 'package:remindy/src/createReminder.dart';

import 'editReminder.dart';

class Home extends StatefulWidget {
  static final route_id = 'home_route';
  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  StreamController _streamController;
  Stream _stream;
  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;

    _insert();
    _removeOldReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        actions: [
          IconButton(
              iconSize: 37.0,
              icon: Icon(
                Icons.add_circle,
                color: Colors.green,
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => CreateReminder()));
              })
        ],
        title: Text('Reminders'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        autofocus: true,
        child: Icon(Icons.add_alert),
        tooltip: 'Create a new reminder',
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => CreateReminder()));
        },
      ),
      body: StreamBuilder(
        stream: _stream,
        // ignore: missing_return
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Database Error'),
            );
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(child: Text('Select a lot')),
                );

                break;
              case ConnectionState.waiting:
                return Center(
                  child: SizedBox(
                    child: const CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                );
                break;
              case ConnectionState.active:
                if (snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: () {
                      return _insert();
                    },
                    child: ListView.builder(
                      cacheExtent: 100,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final Reminder reminder = (snapshot.data[index]);
                        print(reminder);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              reminder.isSelected = !reminder.isSelected;
                            });
                          },
                          child: Card(
                            elevation: 20.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(64, 75, 96, 0.9)),
                              child: (reminder.isSelected)
                                  ? Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          RaisedButton(
                                            color: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            onPressed: () {
                                              CancelReminder.cancel(
                                                  reminder.id);
                                              _insert();
                                            },
                                            child: Text('Cancel Reminder'),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          RaisedButton(
                                            color: Colors.greenAccent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditReminder(
                                                              reminder)));
                                            },
                                            child: Text('Edit Reminder'),
                                          ),
                                          Spacer(),
                                          IconButton(
                                              icon: Icon(Icons.cancel),
                                              onPressed: () {
                                                setState(() {
                                                  reminder.isSelected =
                                                      !reminder.isSelected;
                                                });
                                              })
                                        ],
                                      ),
                                    )
                                  : ListTile(
                                      title: Text(
                                        reminder.title ?? '',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        reminder.shortDesc ?? '',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      leading: Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                      ),
                                      trailing: Column(
                                        children: [
                                          Text(
                                              FormatDate.formatDate(
                                                  reminder.time),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          Text(
                                              FormatDate.formatTime(
                                                  TimeOfDay.fromDateTime(
                                                      reminder.time)),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      )),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      'No Reminder',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                break;
              case ConnectionState.done:
                return Container(
                  child: Center(child: Text('yes')),
                );
                // TODO: Handle this case.
                break;
            }
          }
        },
      ),
    );
  }

  Future<Null> _insert() async {
    _streamController.add(await Globals.databaseHelper.queryAllRows());
  }

  void _removeOldReminders() {
    final now = DateTime.now();
    Globals.databaseHelper
        .deleteOld(DateTime(now.year, now.month, now.day).toIso8601String());
  }
}
