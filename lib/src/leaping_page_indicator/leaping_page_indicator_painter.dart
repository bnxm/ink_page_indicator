import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ink_page_indicator/src/src.dart';

import 'leaping_page_indicator.dart';
import 'leaping_page_indicator_data.dart';

// ignore_for_file: public_member_api_docs

class LeapingPageIndicatorPainter extends PageIndicatorPainter<
    LeapingIndicatorData, LeapingPageIndicator, LeapingPageIndicatorState> {
  LeapingPageIndicatorPainter(
    LeapingPageIndicatorState parent,
    LeapingIndicatorData data,
  ) : super(parent, data);

  double get radii => data.radii;

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    drawInActiveIndicators();
    drawActiveDot(progress);
  }

  @protected
  @override
  void drawActiveDot(double p) {
    final paint = Paint()
      ..color = activeColor
      ..isAntiAlias = true;

    final dy = center.dy;
    final curve = Path()
      ..moveTo(currentDot, dy)
      ..quadraticBezierTo(
        lerpDouble(currentDot, nextDot, 0.5)!,
        dy - radii,
        nextDot,
        dy,
      );

    final offset = getPathOffsetForFraction(
      curve,
      progress,
    );

    drawIndicator(offset, paint, activeShape);
  }
}
