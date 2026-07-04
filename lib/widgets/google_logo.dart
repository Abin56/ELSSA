import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    final strokeWidth = size.width * 0.2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, 3.93, 1.15, false, paint);

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -0.35, 1.75, false, paint);

    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 1.4, 1.15, false, paint);

    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 2.55, 1.38, false, paint);

    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        radius,
        radius - strokeWidth / 2,
        radius - strokeWidth * 0.2,
        strokeWidth,
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
