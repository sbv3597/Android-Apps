import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:save_in_gallery/save_in_gallery.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApphome(),
    );
  }
}

class MyApphome extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApphome> {
  List<Offset> points = [];
  bool _isLoading = false;
  bool _showResult = false;
  String _resultText = "";
  Color _resultColor = Colors.red;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Autograph'),
      ),
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromRGBO(138, 35, 135, 1.0),
                  Color.fromRGBO(233, 64, 87, 1.0),
                  Color.fromRGBO(242, 113, 33, 1.0),
                ])),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    height: height * 0.75,
                    width: width * 0.80,
                    child: GestureDetector(
                      onPanDown: (details) {
                        this.setState(() {
                          points.add(details.localPosition);
                        });
                      },
                      onPanUpdate: (details) {
                        this.setState(() {
                          points.add(details.localPosition);
                        });
                      },
                      onPanEnd: (details) {
                        this.setState(() {
                          points.add(null);
                        });
                      },
                      child: CustomPaint(
                        painter: MyPainter(points: points),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: height * 0.1,
                  width: width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                          onPressed: () {
                            this.setState(() {
                              points.clear();
                            });
                          },
                          child: Text('New Page')),
                      RaisedButton(
                          onPressed: () async {
                            final recorder = ui.PictureRecorder();
                            MyPainter(points: points).paint(Canvas(recorder),
                                Size(width * 0.80, height * 0.75));
                            _startLoading();
                            final picture = recorder.endRecording();
                            final img = await picture.toImage(
                                (width * 0.8).floor(), (height * 0.75).floor());
                            final pngBytes = await img.toByteData(
                                format: ImageByteFormat.png);
                            final _imageSaver = ImageSaver();
                            List<Uint8List> bytesList = [];
                            bytesList.add(pngBytes.buffer.asUint8List());
                            final res = await _imageSaver.saveImages(
                                imageBytes: bytesList,
                                directoryName: "Autograph");
                            _stopLoading();
                            _displayResult(res);
                          },
                          child: Text('Save')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            opacity: _showResult ? 1.0 : 0.0,
            duration: Duration(seconds: 1),
            child: Center(
              child: Container(
                color: Colors.grey,
                height: 100.0,
                width: 300.0,
                child: Center(
                  child: Text(
                    _resultText,
                    style: TextStyle(
                      color: _resultColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _progressIndictaor,
        ],
      ),
    );
  }

  Widget get _progressIndictaor {
    return _isLoading
        ? Container(
            child: Center(child: CircularProgressIndicator()),
            color: Color.fromRGBO(0, 0, 0, 0.3),
          )
        : Container();
  }

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  void _displayResult(bool success) {
    print(success);
    _showResult = true;
    if (success) {
      _displaySuccessMessage();
    } else {
      _displayErrorMessage();
    }
    Timer(Duration(seconds: 1), () {
      _hideResult();
    });
  }

  void _displaySuccessMessage() {
    setState(() {
      _resultText = "Image saved successfully";
      _resultColor = Colors.green;
    });
  }

  void _displayErrorMessage() {
    setState(() {
      _resultText = "An error occurred while saving images";
      _resultColor = Colors.red;
    });
  }

  void _hideResult() {
    setState(() {
      _showResult = false;
    });
  }
}

class MyPainter extends CustomPainter {
  final List<Offset> points;
  final bool save;

  MyPainter({this.save = false, this.points});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    Paint paint = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
    Paint painte = Paint()..color = Colors.black;
    for (int x = 0; x < points.length; x++) {
      if (points[x] != null && points[x + 1] != null) {
        canvas.drawLine(points[x], points[x + 1], painte);
      } else if (points[x] != null && points[x + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[x]], painte);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
    throw UnimplementedError();
  }

  void saveImage(Canvas canvas, PictureRecorder pr) async {
    final picture = pr.endRecording();
    final img = await picture.toImage(200, 200);
    final pngBytes = await img.toByteData(format: ImageByteFormat.png);
    final _imageSaver = ImageSaver();
    List<Uint8List> bytesList = [];
    bytesList.add(pngBytes.buffer.asUint8List());
    final res = await _imageSaver.saveImages(imageBytes: bytesList);
  }
}
