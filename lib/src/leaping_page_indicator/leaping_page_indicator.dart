import 'package:flutter/material.dart';

import 'package:ink_page_indicator/src/src.dart';

import 'leaping_page_indicator_data.dart';
import 'leaping_page_indicator_painter.dart';

/// The style of an [LeapingPageIndicator].
enum LeapingStyle {
  normal,
}

class LeapingPageIndicator extends PageIndicator {
  final double radii;
  final LeapingStyle style;
  LeapingPageIndicator({
    Key key,
    @required int itemCount,
    @required PageIndicatorController controller,
    double radii,
    this.style = LeapingStyle.normal,
    IndicatorShape shape,
    IndicatorShape activeShape,
    Color activeColor = Colors.black,
    Color inActiveColor = Colors.grey,
    double gap = 12.0,
    double padding = 8.0,
  })  : radii = radii ?? gap,
        assert(style != null),
        assert(activeColor != null),
        assert(inActiveColor != null),
        assert(gap != null && gap >= 0.0),
        super(
          key: key,
          shape: shape,
          activeShape: activeShape,
          itemCount: itemCount,
          controller: controller,
          activeColor: activeColor,
          inActiveColor: inActiveColor,
          gap: gap,
          padding: padding,
        );

  @override
  LeapingPageIndicatorState createState() => LeapingPageIndicatorState();
}

class LeapingPageIndicatorState extends PageIndicatorState<LeapingPageIndicator, LeapingIndicatorData> {
  @override
  LeapingIndicatorData get newValue => LeapingIndicatorData(
        activeColor: widget.activeColor,
        inactiveColor: widget.inActiveColor,
        radii: widget.radii,
        gap: widget.gap,
        shape: widget.shape,
        activeShape: widget.activeShape,
      );

  @override
  Widget builder(BuildContext context, LeapingIndicatorData data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.padding),
      child: SizedBox(
        height: widget.shape.height,
        child: CustomPaint(
          size: Size.infinite,
          painter: LeapingPageIndicatorPainter(this, data),
        ),
      ),
    );
  }
}
