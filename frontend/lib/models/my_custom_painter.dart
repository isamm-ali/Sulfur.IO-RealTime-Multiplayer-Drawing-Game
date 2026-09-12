import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:frontend/models/touch_points.dart';

class MyCustomPainter extends CustomPainter {
  MyCustomPainter({required this.pointsList});
  final List<TouchPoints?> pointsList;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(rect);
    TouchPoints? previousPoint;
    for (final currentPoint in pointsList) {
      if (currentPoint == null) {
        previousPoint = null;
        continue;
      }
      if (previousPoint != null) {
        canvas.drawLine(
          previousPoint.points,
          currentPoint.points,
          previousPoint.paint,
        );
      } else {
        canvas.drawPoints(
          ui.PointMode.points,
          [currentPoint.points],
          currentPoint.paint,
        );
      }

      previousPoint = currentPoint;
    }
  }
  @override
  bool shouldRepaint(covariant MyCustomPainter oldDelegate) {
    return true;
  }
}
