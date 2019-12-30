import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:ink_page_indicator/src/src.dart';

class InkPageIndicatorData extends IndicatorData {
  final Color inkColor;
  InkPageIndicatorData({
    @required this.inkColor,
    @required Color activeColor,
    @required Color inActiveColor,
    @required double gap,
    @required IndicatorShape shape,
    @required IndicatorShape activeShape,
  }) : super(
          activeColor: activeColor,
          inActiveColor: inActiveColor,
          gap: gap,
          shape: shape,
          activeShape: activeShape,
        );

  @override
  InkPageIndicatorData lerpTo(IndicatorData b, double t) {
    if (b is InkPageIndicatorData) {
      return InkPageIndicatorData(
        activeColor: Color.lerp(activeColor, b.activeColor, t),
        inActiveColor: Color.lerp(inActiveColor, b.inActiveColor, t),
        inkColor: Color.lerp(inkColor, b.inkColor, t),
        gap: lerpDouble(gap, b.gap, t),
        shape: shape.lerpTo(b.shape, t),
        activeShape: activeShape.lerpTo(b.activeShape, t),
      );
    } else {
      throw ArgumentError('Indicator data is not of type InkPageIndicatorData');
    }
  }

  @override
  String toString() {
    return 'InkPageIndicatorData activeColor: $activeColor, inActiveColor: $inActiveColor, inkColor: $inkColor, gap: $gap, shape: $shape, activeShape: $activeShape';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is InkPageIndicatorData &&
        o.activeColor == activeColor &&
        o.inActiveColor == inActiveColor &&
        o.inkColor == inkColor &&
        o.gap == gap &&
        o.shape == shape &&
        o.activeShape == activeShape;
  }

  @override
  int get hashCode {
    return activeColor.hashCode ^
        inActiveColor.hashCode ^
        gap.hashCode ^
        inkColor.hashCode ^
        shape.hashCode ^
        activeShape.hashCode;
  }
}
