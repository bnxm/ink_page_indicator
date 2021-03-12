import 'package:flutter/material.dart';

import 'package:ink_page_indicator/src/src.dart';

import 'leaping_page_indicator_data.dart';
import 'leaping_page_indicator_painter.dart';

// ignore_for_file: public_member_api_docs

/// The style of an [LeapingPageIndicator].
enum LeapingStyle {
  normal,
}

/// An InkPageIndicator that jumps between the invidividual
/// dots.
class LeapingPageIndicator extends PageIndicator {
  final double radii;
  final LeapingStyle style;

  /// Creates an InkPageIndicator that jumps between the invidividual
  /// dots.
  LeapingPageIndicator({
    Key? key,
    PageIndicatorController? controller,
    ValueNotifier<double>? page,
    int? pageCount,
    double? leapHeight,
    this.style = LeapingStyle.normal,
    IndicatorShape? shape,
    IndicatorShape? activeShape,
    Color activeColor = Colors.black,
    Color inactiveColor = Colors.grey,
    double gap = 12.0,
    double padding = 8.0,
  })  : radii = leapHeight ?? gap,
        assert(gap >= 0.0),
        super(
          key: key,
          shape: shape,
          page: page,
          pageCount: pageCount,
          activeShape: activeShape,
          controller: controller,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          gap: gap,
          padding: padding,
        );

  @override
  LeapingPageIndicatorState createState() => LeapingPageIndicatorState();
}

class LeapingPageIndicatorState
    extends PageIndicatorState<LeapingPageIndicator, LeapingIndicatorData> {
  @override
  LeapingIndicatorData get newValue => LeapingIndicatorData(
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        radii: widget.radii,
        gap: widget.gap,
        shape: widget.shape,
        activeShape: widget.activeShape,
      );

  @override
  Widget builder(BuildContext context, LeapingIndicatorData data) {
    if (pageCount == 0) return SizedBox(height: widget.shape.height);

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
