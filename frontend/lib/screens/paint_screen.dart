import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/my_custom_painter.dart';
import 'package:frontend/models/touch_points.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class PaintScreen extends StatefulWidget {
  final Map data;
  final String screenFrom;

  const PaintScreen({super.key, required this.data, required this.screenFrom});

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  IO.Socket? socket;
  Color selectedColor = Colors.black;
  double opacity = 1;
  double strokeWidth = 2;
  Map dataOfRoom = {};
  List<TouchPoints?> points = [];
  List<Widget> textBlankWidget = [];
  ScrollController _scrollController = ScrollController();
  List<Map> messages = [];
  final TextEditingController messageController = TextEditingController();

  String get host {
    if (kIsWeb) {
      return 'http://localhost:5000';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000';
    }

    return 'http://localhost:5000';
  }

  @override
  void initState() {
    super.initState();

    socket = IO.io(host, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });

    socket!.onConnect((_) {
      debugPrint('Socket connected: ${socket!.id}');

      if (widget.screenFrom == 'createRoom') {
        socket!.emit('create-game', widget.data);
      } else {
        socket!.emit('join-game', widget.data);
      }
    });

    socket!.on('updateRoom', (roomData) {
      setState(() {
        dataOfRoom = roomData;
      });

      debugPrint('Room data: $dataOfRoom');
    });

    socket!.on('points', (point) {
      if (point['details'] != null) {
        setState(() {
          points.add(
            TouchPoints(
              paint: Paint()
                ..strokeCap = StrokeCap.round
                ..isAntiAlias = true
                ..color = selectedColor.withValues(alpha: opacity)
                ..strokeWidth = strokeWidth.toDouble(),
              points: Offset(
                point['details']['dx'].toDouble(),
                point['details']['dy'].toDouble(),
              ),
            ),
          );
        });
      } else {
        setState(() {
          points.add(null);
        });
      }
    });

    socket!.on('color-change', (colorString) {
      setState(() {
        selectedColor = Color(int.parse(colorString, radix: 16));
      });
    });

    socket!.on('stroke-width', (value) {
      setState(() {
        strokeWidth = value.toDouble();
      });
    });

    socket!.on('clear-screen', (value) {
      setState(() {
        points.clear();
      });
    });

    socket!.on('message', (data) {
      setState(() {
        messages.add(data);
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 40,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });

    socket!.onDisconnect((_) {
      debugPrint('Socket disconnected');
    });

    socket!.onConnectError((error) {
      debugPrint('Socket connection error: $error');
    });

    socket!.connect();
  }

  @override
  void dispose() {
    socket?.disconnect();
    socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    void selectColor() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Choose Color'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) {
                  final colorString = color.value.toRadixString(16);

                  socket!.emit('color-change', {
                    'color': colorString,
                    'roomName': widget.data['name'],
                  });

                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
        child: Image.asset(
          'assets/images/backgrounddrawingpage.png',
          fit: BoxFit.cover,
        ),
      ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: height * 0.50,
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 0.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    socket!.emit('paint', {
                      'details': {
                        'dx': details.localPosition.dx,
                        'dy': details.localPosition.dy,
                      },
                      'roomName': widget.data['name'],
                    });
                  },

                  onPanStart: (details) {
                    socket!.emit('paint', {
                      'details': {
                        'dx': details.localPosition.dx,
                        'dy': details.localPosition.dy,
                      },
                      'roomName': widget.data['name'],
                    });
                  },

                  onPanEnd: (details) {
                    socket!.emit('paint', {
                      'details': null,
                      'roomName': widget.data['name'],
                    });
                  },

                  child: SizedBox.expand(
                    child: CustomPaint(
                      painter: MyCustomPainter(pointsList: points),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: .spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      selectColor();
                    },
                    icon: Icon(
                      Icons.color_lens,
                      color: Colors.black,
                      size: 30,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Slider(
                      min: 1.0,
                      max: 10.0,
                      label: 'Stroke width $strokeWidth',
                      activeColor: selectedColor,
                      value: strokeWidth,
                      onChanged: (double value) {
                        final map = {
                          'value': value,
                          'roomName': widget.data['name'],
                        };
                        socket!.emit('stroke-width', map);
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      socket!.emit('clear-screen', {
                        'roomName': widget.data['name'],
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 30,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                      color: Colors.white,
                      border: BoxBorder.all(color: Colors.black, width: 0.5),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              var message = messages[index].values;
                              return Padding(
                                padding: EdgeInsetsGeometry.symmetric(
                                  vertical: 0,
                                  horizontal: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text(
                                      message.elementAt(0),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Unkempt',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      message.elementAt(1),
                                      style: TextStyle(
                                        fontFamily: 'Unkempt',
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 10,
                              bottom: 15,
                              left: 15,
                              right: 15,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: TextField(
                                controller: messageController,
                                onSubmitted: (value) {
                                  if (value.trim().isNotEmpty) {
                                    Map map = {
                                      'username': widget.data['nickname'],
                                      'message': value.trim(),
                                      'word': widget.data['word'],
                                      'roomName': widget.data['name'],
                                    };
                                    socket!.emit('message', map);
                                    messageController.clear();
                                  }
                                },
                                style: const TextStyle(
                                  fontFamily: 'Unkempt',
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'Your Guess...',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Unkempt',
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
