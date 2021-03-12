import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:ink_page_indicator/src/src.dart';

// ignore_for_file: public_member_api_docs

class LeapingIndicatorData extends IndicatorData {
  final double radii;
  LeapingIndicatorData({
    this.radii = 8.0,
    required Color activeColor,
    required Color inactiveColor,
    required double gap,
    required IndicatorShape shape,
    required IndicatorShape activeShape,
  }) : super(
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          gap: gap,
          shape: shape,
          activeShape: activeShape,
        );

  @override
  LeapingIndicatorData lerpTo(IndicatorData b, double t) {
    if (b is LeapingIndicatorData) {
      return LeapingIndicatorData(
        activeColor: Color.lerp(activeColor, b.activeColor, t)!,
        inactiveColor: Color.lerp(inactiveColor, b.inactiveColor, t)!,
        radii: lerpDouble(radii, b.radii, t)!,
        gap: lerpDouble(gap, b.gap, t)!,
        shape: shape.lerpTo(b.shape, t),
        activeShape: activeShape.lerpTo(b.activeShape, t),
      );
    } else {
      throw ArgumentError('Indicator data is not of type LeapingIndicatorData');
    }
  }

  @override
  String toString() {
    return 'LeapingIndicatorData activeColor: $activeColor, inactiveColor: $inactiveColor, radii: $radii, gap: $gap, shape: $shape, activeShape: $activeShape';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LeapingIndicatorData &&
        o.activeColor == activeColor &&
        o.inactiveColor == inactiveColor &&
        o.radii == radii &&
        o.gap == gap &&
        o.shape == shape &&
        o.activeShape == activeShape;
  }

  @override
  int get hashCode {
    return activeColor.hashCode ^
        inactiveColor.hashCode ^
        gap.hashCode ^
        radii.hashCode ^
        shape.hashCode ^
        activeShape.hashCode;
  }
}
