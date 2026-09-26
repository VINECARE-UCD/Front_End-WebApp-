import 'package:flutter/material.dart';

class DroneIcon extends StatelessWidget {
  final double size;
  final Color color;

  const DroneIcon({
    super.key,
    this.size = 24,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DronePainter(color),
    );
  }
}

class _DronePainter extends CustomPainter {
  final Color color;

  const _DronePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Arms
    canvas.drawLine(
      Offset(cx - 3, cy - 2),
      Offset(cx - 8, cy - 7),
      stroke,
    );
    canvas.drawLine(
      Offset(cx + 3, cy - 2),
      Offset(cx + 8, cy - 7),
      stroke,
    );
    canvas.drawLine(
      Offset(cx - 3, cy + 2),
      Offset(cx - 8, cy + 7),
      stroke,
    );
    canvas.drawLine(
      Offset(cx + 3, cy + 2),
      Offset(cx + 8, cy + 7),
      stroke,
    );

    // Rotors
    canvas.drawCircle(Offset(cx - 9, cy - 8), 2, stroke);
    canvas.drawCircle(Offset(cx + 9, cy - 8), 2, stroke);
    canvas.drawCircle(Offset(cx - 9, cy + 8), 2, stroke);
    canvas.drawCircle(Offset(cx + 9, cy + 8), 2, stroke);

    // Main drone body
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: 8,
        height: 5,
      ),
      const Radius.circular(2),
    );

    canvas.drawRRect(body, paint);

    // Camera
    canvas.drawCircle(
      Offset(cx, cy + 4),
      1,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _DronePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
