import 'dart:math';

import 'package:flutter/material.dart';

/// Виджет для отображения кругового лоадера с градиентом
class CircularProgress extends StatefulWidget {
  const CircularProgress({
    @required this.size,
    @required this.secondaryColor,
    @required this.primaryColor,
    this.strokeWidth = 6.0,
    this.lapDuration = 1000,
    Key key,
  }) : super(key: key);

  final double size;
  final Color secondaryColor;
  final Color primaryColor;
  final double strokeWidth;
  final int lapDuration;

  @override
  _CircularProgress createState() => _CircularProgress();
}

class _CircularProgress extends State<CircularProgress>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.lapDuration,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(controller),
      child: CustomPaint(
        painter: CirclePaint(
          secondaryColor: widget.secondaryColor,
          primaryColor: widget.primaryColor,
          strokeWidth: widget.strokeWidth,
        ),
        size: Size(widget.size, widget.size),
      ),
    );
  }
}

/// Вспомогательный класс для виджета [CircularProgress]
class CirclePaint extends CustomPainter {
  CirclePaint({
    this.secondaryColor = Colors.grey,
    this.primaryColor = Colors.blue,
    this.strokeWidth = 15,
  });

  static const zero = 0.0, two = 2, degree270 = 270.0, degree360 = 360.0;
  final Color secondaryColor;
  final Color primaryColor;
  final double strokeWidth;

  double _degreeToRad(double degree) => degree * pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final double centerPoint = size.height / two;
    final double scapSize = strokeWidth * 0.7;
    final double scapToDegree = scapSize / centerPoint;
    final double startAngle = _degreeToRad(degree270) + scapToDegree;
    final double sweepAngle = _degreeToRad(degree360) - (two * scapToDegree);

    final Paint paint = Paint()
      ..color = primaryColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // ignore: cascade_invocations
    paint.shader = SweepGradient(
      colors: [secondaryColor, primaryColor],
      tileMode: TileMode.repeated,
      startAngle: _degreeToRad(degree270),
      endAngle: _degreeToRad(degree270 + degree360),
    ).createShader(
      Rect.fromCircle(
        center: Offset(centerPoint, centerPoint),
        radius: zero,
      ),
    );

    canvas.drawArc(
      const Offset(zero, zero) & Size(size.width, size.width),
      startAngle,
      sweepAngle,
      false,
      paint..color = primaryColor,
    );
  }

  @override
  bool shouldRepaint(CirclePaint oldDelegate) {
    return true;
  }
}
