import 'package:flutter/material.dart';

class GloboDialogo extends StatelessWidget {
  final String texto;

  const GloboDialogo({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GloboPainter(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _GloboPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(25),
    );

    canvas.drawRRect(rrect, paint);

    final path = Path()
      ..moveTo(size.width * 0.3, size.height)
      ..lineTo(size.width * 0.4, size.height + 20)
      ..lineTo(size.width * 0.5, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
