import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:frontend/models/touch_points.dart';

class MyCustomPainter extends CustomPainter {
  MyCustomPainter({required this.pointsList});

  final List<TouchPoints?> pointsList;

  final List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.clipRect(rect);

    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(
          pointsList[i]!.points,
          pointsList[i + 1]!.points,
          pointsList[i]!.paint,
        );
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();

        offsetPoints.add(
          Offset(
            pointsList[i]!.points.dx + 0.1,
            pointsList[i]!.points.dy + 0.1,
          ),
        );

        canvas.drawPoints(
          ui.PointMode.points,
          offsetPoints,
          pointsList[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant MyCustomPainter oldDelegate) {
    return true;
  }
}
