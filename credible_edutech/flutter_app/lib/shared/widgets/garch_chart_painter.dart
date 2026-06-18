import 'package:flutter/material.dart';
import 'dart:math' as math;

class GARCHChartPainter extends CustomPainter {
  final List<double> volatilityData;
  final Color lineColor;
  final Color gridColor;
  final Color backgroundColor;

  GARCHChartPainter({
    required this.volatilityData,
    this.lineColor = const Color(0xFF0066FF),
    this.gridColor = const Color(0xFF2a3042),
    this.backgroundColor = const Color(0xFF1a1f2a),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (volatilityData.isEmpty) return;

    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    // Calculate bounds
    final maxVol = volatilityData.reduce((a, b) => a > b ? a : b);
    final minVol = volatilityData.reduce((a, b) => a < b ? a : b);
    final volRange = maxVol - minVol;

    // Padding and scaling
    const padding = 40.0;
    const topPadding = 20.0;
    final plotWidth = size.width - (2 * padding);
    final plotHeight = size.height - padding - topPadding;

    // Draw grid
    _drawGrid(canvas, size, padding, topPadding, plotWidth, plotHeight);

    // Draw axes
    _drawAxes(canvas, size, padding, topPadding, plotWidth, plotHeight);

    // Draw data points and line
    _drawVolatilityLine(
      canvas,
      volatilityData,
      minVol,
      volRange,
      padding,
      topPadding,
      plotWidth,
      plotHeight,
    );

    // Draw labels
    _drawLabels(canvas, size, padding, topPadding, minVol, maxVol);
  }

  void _drawGrid(Canvas canvas, Size size, double padding, double topPadding,
      double plotWidth, double plotHeight) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    // Vertical grid lines
    final verticalSteps = 5;
    for (int i = 0; i <= verticalSteps; i++) {
      final x = padding + (plotWidth / verticalSteps) * i;
      canvas.drawLine(
        Offset(x, topPadding),
        Offset(x, topPadding + plotHeight),
        paint,
      );
    }

    // Horizontal grid lines
    final horizontalSteps = 5;
    for (int i = 0; i <= horizontalSteps; i++) {
      final y = topPadding + (plotHeight / horizontalSteps) * i;
      canvas.drawLine(
        Offset(padding, y),
        Offset(padding + plotWidth, y),
        paint,
      );
    }
  }

  void _drawAxes(Canvas canvas, Size size, double padding, double topPadding,
      double plotWidth, double plotHeight) {
    final paint = Paint()
      ..color = const Color(0xFF9E9E9E)
      ..strokeWidth = 1.5;

    // X-axis
    canvas.drawLine(
      Offset(padding, topPadding + plotHeight),
      Offset(padding + plotWidth, topPadding + plotHeight),
      paint,
    );

    // Y-axis
    canvas.drawLine(
      Offset(padding, topPadding),
      Offset(padding, topPadding + plotHeight),
      paint,
    );
  }

  void _drawVolatilityLine(
    Canvas canvas,
    List<double> data,
    double minVal,
    double range,
    double padding,
    double topPadding,
    double plotWidth,
    double plotHeight,
  ) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final points = <Offset>[];
    final xStep = plotWidth / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = padding + (i * xStep);
      final normalizedY = (data[i] - minVal) / (range > 0 ? range : 1);
      final y = topPadding + plotHeight - (normalizedY * plotHeight);

      points.add(Offset(x, y));
    }

    // Draw line
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw points
    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 3, pointPaint);
    }
  }

  void _drawLabels(
    Canvas canvas,
    Size size,
    double padding,
    double topPadding,
    double minVal,
    double maxVal,
  ) {
    const labelStyle = TextStyle(
      color: Color(0xFF9E9E9E),
      fontSize: 10,
    );

    // Y-axis labels
    final yLabels = [minVal, (minVal + maxVal) / 2, maxVal];
    for (int i = 0; i < yLabels.length; i++) {
      final y = topPadding + (size.height - padding - topPadding) * i / 2;
      final textPainter = TextPainter(
        text: TextSpan(
          text: yLabels[i].toStringAsFixed(4),
          style: labelStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - 5));
    }
  }

  @override
  bool shouldRepaint(GARCHChartPainter oldDelegate) {
    return oldDelegate.volatilityData != volatilityData;
  }
}
