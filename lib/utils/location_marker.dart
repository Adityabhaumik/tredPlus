import 'package:flutter/material.dart';

class GlowingCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 4;

    final Paint glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.blue.withOpacity(0.6),
          Colors.blue.withOpacity(0.3),
          Colors.blue.withOpacity(0.0)
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.5));

    canvas.drawCircle(center, radius * 1.5, glowPaint);

    final Paint circlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GlowingCircleWidget extends StatelessWidget {
  const GlowingCircleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200),
      painter: GlowingCirclePainter(),
    );
  }
}
