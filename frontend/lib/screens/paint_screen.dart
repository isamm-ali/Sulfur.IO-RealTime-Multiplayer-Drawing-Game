import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/my_custom_painter.dart';
import 'package:frontend/models/touch_points.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PaintScreen extends StatefulWidget {
  final Map data;
  final String screenFrom;
  final Color selectedColor = Colors.black;
  final double opacity = 1;
  final double strokeWidth = 2;

  const PaintScreen({
    super.key,
    required this.data,
    required this.screenFrom,
  });

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  IO.Socket? socket;

  Map dataOfRoom = {};

  List<TouchPoints?> points = [];

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

    socket = IO.io(
      host,
      <String, dynamic>{
        'autoConnect': false,
        'transports': ['websocket'],
      },
    );

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
                ..color = widget.selectedColor.withValues()
                ..strokeWidth = widget.strokeWidth,
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width,
                height: height * 0.55,
                color: Colors.white,
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
                      painter: MyCustomPainter(
                        pointsList: points,
                      ),
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