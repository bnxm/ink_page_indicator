import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ink_page_indicator/src/src.dart';

import 'ink_page_indicator_data.dart';

// ignore_for_file: public_member_api_docs

class InkPageIndicatorPainter extends PageIndicatorPainter<InkPageIndicatorData,
    InkPageIndicator, InkPageIndicatorState> {
  InkPageIndicatorPainter(
    InkPageIndicatorState parent,
    InkPageIndicatorData data,
  ) : super(parent, data);

  InkStyle get style => widget.style;
  Color get inkColor => data.inkColor ?? inactiveColor;

  bool get animateLastPageDot =>
      style == InkStyle.simple || style == InkStyle.normal;

  @override
  double get activeDotProgress {
    switch (style) {
      case InkStyle.simple:
      case InkStyle.normal:
        return interval(0.4, 0.8, progress);
      default:
        return progress;
    }
  }

  @override
  double get inactiveDotProgress {
    switch (style) {
      case InkStyle.normal:
        return interval(0.0, 0.4, progress);
      case InkStyle.simple:
        return interval(0.0, 0.5, progress);
      default:
        return progress;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    drawInActiveIndicators();
    drawInkStyle();
    drawActiveDot(activeDotProgress);
  }

  @protected
  @override
  void drawInActiveIndicators() {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = inactiveColor;

    for (var i = 0; i < dots.length; i++) {
      final dx = dots[i];
      final isCurrent = i == currentPage;
      final isNext = i == nextPage;

      IndicatorShape shape = this.shape;
      if (isCurrent || isNext) {
        // Lerp the next shape to the active shape and the current shape
        // from the active shape to the inactive shape.
        shape = this.shape.lerpTo(
              activeShape,
              isNext ? inactiveDotProgress : 1 - inactiveDotProgress,
            );
      }

      final animateLastDotInAgain = isCurrent && animateLastPageDot;
      if (animateLastDotInAgain) {
        shape = shape.scale(interval(0.9, 1.0, progress));
      }

      if (style == InkStyle.transition && (isCurrent || isNext)) {
        if (progress == 0.0 || currentPage == nextPage) {
          paint.color = isCurrent ? activeColor : inactiveColor;
        } else {
          paint.color = Color.lerp(
            isCurrent ? activeColor : inactiveColor,
            isCurrent ? inactiveColor : activeColor,
            progress,
          )!;
        }
      } else if (style == InkStyle.normal && isNext) {
        paint.color = getNextActiveInkTransitionColor()!;
      } else {
        paint.color = inactiveColor;
      }

      drawIndicator(dx, paint, shape);
    }
  }

  @protected
  @override
  void drawActiveDot(double p) {
    if (style == InkStyle.transition) return;

    super.drawActiveDot(p);
  }

  @protected
  void drawInkStyle() {
    if (style == InkStyle.normal) {
      drawOriginalStyle();
    } else if (style == InkStyle.simple) {
      drawSimpleStyle();
    }
  }

  @protected
  void drawSimpleStyle() {
    final paint = Paint()
      ..color = inkColor
      ..isAntiAlias = true;

    final startProgress = inactiveDotProgress;
    final endProgress = interval(0.8, 1.0, progress);

    final start = lerpDouble(currentDot, nextDot, startProgress)!;
    final end = lerpDouble(currentDot, nextDot, endProgress)!;
    final shape = activeShape;
    final rrect = getRRectFromEndPoints(start, end, shape);

    canvas.drawRRect(rrect, paint);
  }

  @protected
  void drawOriginalStyle() {
    final inkProgress = inactiveDotProgress;
    if (inkProgress == 0.0) return;

    final paint = Paint()
      ..color = inkColor
      ..isAntiAlias = true;

    final isInTransition = inkProgress > 0.0 && inkProgress < 1.0;

    if (isInTransition) {
      drawInkInTransition(paint, inkProgress);
    } else {
      final endTransitionProgress = interval(0.8, 1.0, progress);
      drawEndTransition(paint, endTransitionProgress);
    }
  }

  @protected
  void drawInkInTransition(Paint paint, double inkProgress) {
    final dy = center.dy;
    final dx = lerpDouble(currentDot, nextDot, 0.5);
    final shape = this.shape.lerpTo(activeShape, inkProgress);

    Path createInkPath(double origin) => Path()
      ..moveTo(origin, dy)
      ..lineTo(lerpDouble(origin, dx, inkProgress)!, dy);

    void drawInkPath(Path path, IndicatorShape shape) {
      drawPressurePath(path, paint, [
        PressureStop(stop: 0.0, thickness: shape.height),
        PressureStop(stop: 1.0, thickness: shape.height * inkProgress),
      ]);
    }

    final fromInk = createInkPath(currentDot);
    final toInk = createInkPath(nextDot);

    drawInkPath(fromInk, activeShape);

    paint.color = getNextActiveInkTransitionColor()!;

    drawInkPath(toInk, shape);
  }

  // Transition between the inactive item color and the
  // ink color.
  @protected
  Color? getNextActiveInkTransitionColor() => Color.lerp(
        inactiveColor,
        inkColor,
        interval(0.0, 0.5, inactiveDotProgress),
      );

  @protected
  void drawEndTransition(Paint paint, double transitionProgress) {
    final start = lerpDouble(currentDot, nextDot, transitionProgress)!;
    final rrect = getRRectFromEndPoints(start, nextDot, activeShape);

    canvas.drawRRect(rrect, paint);
  }
}
