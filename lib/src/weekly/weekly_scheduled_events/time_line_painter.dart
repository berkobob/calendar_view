import 'package:flutter/material.dart';

class TimeLinePainter extends CustomPainter {
  final double offset;
  TimeLinePainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.0;
    canvas.drawLine(
        Offset(size.width / 15, offset), Offset(size.width, offset), paint);
    canvas.drawCircle(Offset(size.width / 15, offset), 5.0, paint);
  }

  @override
  bool shouldRepaint(TimeLinePainter oldDelegate) =>
      oldDelegate.offset != offset;
}
