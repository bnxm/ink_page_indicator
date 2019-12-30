import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:ink_page_indicator/src/src.dart';
import 'package:ink_page_indicator/src/ink_page_indicator/ink_page_indicator_data.dart';

class InkPageIndicatorPainter
    extends PageIndicatorPainter<InkPageIndicatorData, InkPageIndicator, InkPageIndicatorState> {
  InkPageIndicatorPainter(
    InkPageIndicatorState parent,
    InkPageIndicatorData data,
  ) : super(parent, data);

  InkStyle get style => widget.style;
  Color get inkColor => data.inkColor ?? inActiveColor;

  bool get animateLastPageDot => style == InkStyle.modern || style == InkStyle.simple;

  double get activeDotProgress {
    switch (style) {
      case InkStyle.modern:
      case InkStyle.simple:
        return fInRange(0.4, 0.8, progress);
      default:
        return progress;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    drawStyle();
    drawInActiveIndicators();
    drawActiveDot(activeDotProgress);
  }

  @protected
  void drawStyle() {
    if (style == InkStyle.modern) {
      drawModernStyle();
    } else if (style == InkStyle.simple) {
      drawSimpleStyle();
    }
  }

  @protected
  @override
  void drawInActiveIndicators() {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = inActiveColor;

    for (var i = 0; i < dots.length; i++) {
      final dx = dots[i];
      final isCurrent = i == currentPage;
      final isNext = i == nextPage;

      IndicatorShape shape;
      if (isCurrent || isNext) {
        shape = this.shape.lerpTo(activeShape, isNext ? progress : 1 - progress);
      } else {
        shape = this.shape;
      }

      final f = !isCurrent || !animateLastPageDot ? 1.0 : fInRange(0.9, 1.0, progress);

      drawIndicator(dx, paint, shape.scale(f));
    }
  }

  @protected
  void drawSimpleStyle() {
    final paint = Paint()
      ..color = inkColor
      ..isAntiAlias = true;

    final startProgress = fInRange(0.0, 0.5, progress);
    final endProgress = fInRange(0.8, 1.0, progress);

    final start = lerpDouble(currentDot, nextDot, startProgress);
    final end = lerpDouble(currentDot, nextDot, endProgress);
    final shape = this.shape.lerpTo(activeShape, progress);
    final rrect = getRRectFromEndPoints(start, end, shape);

    canvas.drawRRect(rrect, paint);
  }

  @protected
  void drawModernStyle() {
    final inkProgress = fInRange(0.0, 0.4, progress);
    if (inkProgress == 0.0) return;

    final paint = Paint()
      ..color = inkColor
      ..isAntiAlias = true;

    final isInTransition = inkProgress > 0.0 && inkProgress < 1.0;

    if (isInTransition) {
      drawInkInTransition(paint, inkProgress);
    } else {
      final endTransitionProgress = fInRange(0.8, 1.0, progress);
      drawEndTransition(paint, endTransitionProgress);
    }
  }

  @protected
  void drawEndTransition(Paint paint, double transitionProgress) {
    final start = lerpDouble(currentDot, nextDot, transitionProgress);
    final rrect = getRRectFromEndPoints(start, nextDot, activeShape);

    canvas.drawRRect(rrect, paint);
  }

  @protected
  void drawInkInTransition(Paint paint, double inkProgress) {
    final dy = center.dy;
    final dx = lerpDouble(currentDot, nextDot, 0.5);
    final shape = this.shape.lerpTo(activeShape, inkProgress);

    Path createInkPath(double origin) => Path()
      ..moveTo(origin, dy)
      ..lineTo(lerpDouble(origin, dx, inkProgress), dy);

    void drawInkPath(Path path) {
      drawPressurePath(path, paint, [
        PressureStop(stop: 0.0, thickness: shape.height),
        PressureStop(stop: 1.0, thickness: shape.height * inkProgress),
      ]);
    }

    final fromInk = createInkPath(currentDot);
    final toInk = createInkPath(nextDot);

    drawInkPath(fromInk);
    drawInkPath(toInk);
  }
}
