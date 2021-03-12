import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'util.dart';

// ignore_for_file: public_member_api_docs

class PressureStop implements Comparable<PressureStop> {
  final double thickness;
  final double stop;
  PressureStop({
    required this.thickness,
    required this.stop,
  })   : assert(stop >= 0.0 && stop <= 1.0),
        assert(thickness >= 0.0);

  @override
  int compareTo(PressureStop other) => stop.compareTo(other.stop);
}

class PressurePath {
  final Path path;
  final List<PressureStop> stops;
  PressurePath(
    this.path,
    this.stops,
  ) : assert(stops.isNotEmpty) {
    _computeMetrics();
  }

  PathMetric? _metrics;
  PathMetric? get metrics => _metrics;

  double? _length;
  double? get length => _length;

  void _computeMetrics() {
    _metrics = path.computeMetrics().first;
    _length = metrics!.length;
  }

  void draw(Canvas? canvas, Paint paint) {
    final prevStyle = paint.style;
    final prevStrokeWidth = paint.strokeWidth;

    if (stops.length == 1) {
      _drawPath(canvas!, paint);
    } else {
      _drawMultiStopPath(canvas, paint);
    }

    paint.style = prevStyle;
    paint.strokeWidth = prevStrokeWidth;
  }

  void _drawMultiStopPath(Canvas? canvas, Paint paint) {
    paint.style = PaintingStyle.fill;

    double stepSize = 0.5;
    for (var step = 0.0; step < length!; step += stepSize) {
      final fraction = step / length!;
      final offset = metrics!.getTangentForOffset(step)!.position;
      final thickness = getThicknessForFraction(fraction)!;

      stepSize = math.min(
        0.5,
        math.max(thickness, 0.25),
      );

      paint.strokeWidth = thickness;
      canvas!.drawCircle(
        offset,
        thickness / 2,
        paint,
      );
    }
  }

  double? getThicknessForFraction(double fraction) {
    PressureStop targetStop = stops[0];
    PressureStop lastStop = stops[0];

    for (var i = 0; i < stops.length; i++) {
      final s = stops[i];
      final ls = i > 0 ? stops[i - 1] : s;

      final isStopInRange = s.stop >= fraction && ls.stop <= fraction;
      if (isStopInRange) {
        targetStop = s;
        lastStop = ls;
      }
    }

    final progress = interval(
      lastStop.stop,
      targetStop.stop,
      fraction,
    );

    return lerpDouble(
      lastStop.thickness,
      targetStop.thickness,
      progress,
    );
  }

  void _drawPath(Canvas canvas, Paint paint) {
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = stops[0].thickness;

    canvas.drawPath(path, paint);
  }
}
