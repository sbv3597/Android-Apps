import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remindy/GlobalVariables/globals.dart';
import 'package:remindy/HelperMethods/formatDate.dart';
import 'package:remindy/Models/simpleReminder.dart';
import 'package:remindy/src/home.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class EditReminder extends StatefulWidget {
  final Reminder reminder;

  const EditReminder(this.reminder);
  @override
  _CreateReminderState createState() => _CreateReminderState();
}

class _CreateReminderState extends State<EditReminder> {
  String _currentDate;
  TextEditingController _titleCo;
  TextEditingController _descCo;

  String _currentTime;

  DateTime datetime;

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datetime = widget.reminder.time;
    _currentDate = FormatDate.formatDate(widget.reminder.time);

    _currentTime =
        FormatDate.formatTime(TimeOfDay.fromDateTime(widget.reminder.time));
    _descCo = TextEditingController();
    _titleCo = TextEditingController();
    _descCo.text = widget.reminder.description;
    _titleCo.text = widget.reminder.title;
    _initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.2,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text('Edit Reminder'),
        centerTitle: true,
        actions: [
          Builder(builder: (context) {
            return IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  Navigator.popAndPushNamed(context, Home.route_id);
                });
          }),
        ],
      ),
      body: Form(
        key: formKey,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scrollbar(
            thickness: 10.0,
            radius: Radius.circular(30.0),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: _titleCo,

                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: Colors.white, style: BorderStyle.solid),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: Colors.white, style: BorderStyle.solid),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: Colors.white, style: BorderStyle.solid),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: Colors.white, style: BorderStyle.solid),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: Colors.white, style: BorderStyle.solid),
                        ),
                        focusColor: Colors.white,
                        labelText: 'Enter the Title *',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title can not be empty';
                        } else if (value.length > 40)
                          return 'Title is too long';
                        else
                          return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10.0, right: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            color: Colors.black12,
                          ),
                          child: Row(
                            children: [
                              Text(
                                _currentDate,
                                style: TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.date_range,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _showDatePicker(context);
                                  })
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0, right: 5.0),
                          decoration: BoxDecoration(
                            backgroundBlendMode: BlendMode.darken,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            color: Colors.black12,
                          ),
                          child: Row(
                            children: [
                              Text(_currentTime,
                                  style: TextStyle(color: Colors.white)),
                              IconButton(
                                  icon: Icon(
                                    Icons.timer,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _showTimePicker(context);
                                  })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Scrollbar(
                      thickness: 5.0,
                      radius: Radius.circular(30.0),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Enter the Description',
                          labelStyle: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Colors.white, style: BorderStyle.solid),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Colors.white, style: BorderStyle.solid),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Colors.white, style: BorderStyle.solid),
                          ),
                        ),
                        controller: _descCo,
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.green,
                    hoverColor: Colors.white,
                    elevation: 4.0,
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        if (datetime == DateTime.now())
                          AlertDialog(
                            title: Text('Error'),
                            content: Text(
                                'Please select a date and Time It can not be a past Time'),
                            actions: [
                              RaisedButton(onPressed: () {
                                Navigator.pop(context);
                              })
                            ],
                          );
                        else {
                          Reminder _re = Reminder(
                              id: widget.reminder.id,
                              time: datetime,
                              title: _titleCo.value.text,
                              description: _descCo.value.text);
                          await Globals.databaseHelper.update(_re.toMap());
                          await shedulenotification(_re);
                          Navigator.popAndPushNamed(context, Home.route_id);
                          // Navigator.pop(context);
                        }
                      }
                    },
                    child: Text('Save'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future shedulenotification(Reminder re) async {
    await Globals.flutterLocalNotificationsPlugin.cancel(re.id);
    String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    Globals.flutterLocalNotificationsPlugin.zonedSchedule(
        re.id,
        re.title,
        re.shortDesc,
        tz.TZDateTime.from(datetime, tz.local).add(const Duration(seconds: 10)),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', 'your channel description',
                color: Colors.green,
                priority: Priority.max,
                importance: Importance.max)),
        uiLocalNotificationDateInterpretation: null,
        androidAllowWhileIdle: true);
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget.reminder.time,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      datetime = DateTime(picked.year, picked.month, picked.day, datetime.hour,
          datetime.minute);

      setState(() {
        _currentDate = FormatDate.formatDate(picked);
      });
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.reminder.time),
    );
    if (picked != null) {
      datetime = DateTime(datetime.year, datetime.month, datetime.day,
          picked.hour, picked.minute);
      //  print(datetime);
      setState(() {
        _currentTime = FormatDate.formatTime(picked);
        //   print(_currentDate);
      });
    }
  }

  Future onSelectNotification(String payload) async {
    print('shubham $payload');
  }

  Future<void> _initNotification() async {
    tz.initializeTimeZones();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    Globals.flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    await Globals.flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: onSelectNotification);
  }
}
