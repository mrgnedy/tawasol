import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiamondAddPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint();
    Path path = Path()
      ..moveTo(0, 18 * 1.5)
      ..lineTo(10 * 1.5, 36 * 1.5)
      ..lineTo(30 * 1.5, 36 * 1.5)
      ..lineTo(40 * 1.5, 18 * 1.5)
      ..lineTo(30 * 1.5, 0)
      ..lineTo(10 * 1.5, 0)
      ..close();
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white;
    canvas.drawShadow(path, Colors.grey, 3, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
