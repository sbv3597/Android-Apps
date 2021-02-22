import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:async';

import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

import 'package:path_provider/path_provider.dart';
import 'package:voice_changer_plugin/voice_changer_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Funny Sound Record',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Funny Recorder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterAudioRecorder _recorder;
  Recording _recording;
  Timer _t;
  var  _buttonTeext = 'New Start';
  String _alert;
   double width;
   double height;
   int _value=0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _prepare();
    });
  }


  void _opt() async {
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        {
          await _startRecording();
          break;
        }
      case RecordingStatus.Recording:
        {
          await _stopRecording();
          break;
        }
      case RecordingStatus.Stopped:
        {
          await _prepare();
          break;
        }

      default:
        break;
    }

    setState(() {
      _buttonTeext = _playerIcon(_recording.status);
    });
  }

  Future _init() async {
    String customPath = '/flutter_audio_recorder_';
    io.Directory appDocDirectory;
    appDocDirectory = await getExternalStorageDirectory();

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString();

    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.WAV, sampleRate: 22050);
    await _recorder.initialized;
  }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
        _buttonTeext = _playerIcon(_recording.status);
        _alert = "";
      });
    } else {
      setState(() {
        _alert = "Permission Required.";
      });
    }
  }

  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
    });
  }

  void _convert() {
    VoiceChangerPlugin.change(_recording.path, _value);
  }




  String _playerIcon(RecordingStatus status) {
    switch (status) {
      case RecordingStatus.Initialized:
        {
          return 'New Start';
        }
      case RecordingStatus.Recording:
        {
          return 'Recording';
        }
      case RecordingStatus.Stopped:
        {
          return 'Stop';
        }
      default:
        return 'New Start';
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(

      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('images/bg.jpg'),
          fit: BoxFit.cover

        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
          title: Text('Funny Recorder'),
        ),
        body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(

                  decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),

                    gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(138, 35, 135, 0.8),
                            Color.fromRGBO(233, 64, 87, 0.8),
                            Color.fromRGBO(242, 113, 33, 0.8),
                          ]),
                    border: Border.all()),
                          child: FlatButton(
                              onPressed: _opt,
                              child: Text(_buttonTeext,
                                style: Theme.of(context).textTheme.title,),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Container(
                        width: width*0.8,
                        child: Column(
                          children: [

                            Text(
                              'Duration',
                              style: Theme.of(context).textTheme.title,
                            ),
                            Text(
                              '${_recording?.duration ?? "-"}',
                              style: Theme.of(context).textTheme.body1,
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(138, 35, 135, 0.8),
                                  Color.fromRGBO(233, 64, 87, 0.8),
                                  Color.fromRGBO(242, 113, 33, 0.8),
                                ])
                        ),
                        padding: EdgeInsets.all(10.0),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: width,
                        child: Column(
                          children: [
                            Text(
                              'Status',
                              style: Theme.of(context).textTheme.title,
                            ),
                            Text(
                              '${_recording?.status ?? "-"}',
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(138, 35, 135, 0.8),
                                  Color.fromRGBO(233, 64, 87, 0.8),
                                  Color.fromRGBO(242, 113, 33, 0.8),
                                ])
                        ),
                        padding: EdgeInsets.all(10.0),
                      ),
                      SizedBox(
                        height: 5,
                      ),


                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: width*0.4,
                            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromRGBO(138, 35, 135, 0.8),
                                      Color.fromRGBO(233, 64, 87, 0.8),
                                      Color.fromRGBO(242, 113, 33, 0.8),
                                    ]),
                                borderRadius: BorderRadius.circular(10.0),

                                border: Border.all()),
                            child: Column(
                              children: [
                                Text('Select Type',
                            style: Theme.of(context).textTheme.title,
                                ),
                                Center(
                                  child: DropdownButton(
                                      value: _value,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text("Normal"),
                                          value: 0,
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Lorie"),
                                          value: 1,
                                        ),
                                        DropdownMenuItem(
                                            child: Text("Terror"),
                                            value: 2
                                        ),
                                        DropdownMenuItem(
                                            child: Text("Uncle"),
                                            value: 3
                                        ),
                                        DropdownMenuItem(
                                            child: Text("Funny"),
                                            value: 4
                                        ),
                                        DropdownMenuItem(
                                            child: Text("Vacant"),
                                            value: 5
                                        )
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _value = value;
                                        });
                                      }),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromRGBO(138, 35, 135, 1.0),
                                        Color.fromRGBO(233, 64, 87, 0.9),
                                        Color.fromRGBO(242, 113, 33, 1.0),
                                      ]),
                                  border: Border.all()),
                              width: width*0.3,
                              child: FlatButton(
                                child: Text('Convert',
                                  style: Theme.of(context).textTheme.title,
                                ),

                                onPressed: _recording?.status == RecordingStatus.Stopped
                                    ? _convert
                                    : null,
                              ),
                            ),
                          ),

                        ],
                      ),
                      Text(
                        '${_alert ?? ""}',
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                ),


             ),

        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50.0,
              child: Center(child: Text('Created by Shubham Bairagi',style:
                TextStyle(fontWeight: FontWeight.bold),))),
          color: Colors.orangeAccent,

        ),// This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}