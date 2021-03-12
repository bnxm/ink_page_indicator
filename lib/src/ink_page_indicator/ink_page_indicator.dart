import 'package:flutter/material.dart';

import 'package:ink_page_indicator/src/src.dart';

import 'ink_page_indicator_data.dart';
import 'ink_page_indicator_painter.dart';

/// The style of an [InkPageIndicator].
enum InkStyle {
  /// See: https://raw.githubusercontent.com/bnxm/ink_page_indicator/master/assets/ink_demo.gif
  normal,

  /// See: https://raw.githubusercontent.com/bnxm/ink_page_indicator/master/assets/simple_demo.gif
  simple,

  /// See: https://raw.githubusercontent.com/bnxm/ink_page_indicator/master/assets/translate_demo.gif
  translate,

  /// See: https://raw.githubusercontent.com/bnxm/ink_page_indicator/master/assets/transition_demo.gif
  transition,
}

/// A Flutter implementation of the InkPageIndicator.
class InkPageIndicator extends PageIndicator {
  /// The color of the ink between the dots
  /// for some [IntStyle]s.
  final Color? inkColor;

  /// The style of the transition between the dots.
  final InkStyle style;

  /// Creates a Flutter implementation of the InkPageIndicator.
  InkPageIndicator({
    Key? key,
    PageIndicatorController? controller,
    ValueNotifier<double>? page,
    int? pageCount,
    this.style = InkStyle.simple,
    this.inkColor,
    IndicatorShape? shape,
    IndicatorShape? activeShape,
    Color activeColor = Colors.black,
    Color inactiveColor = Colors.grey,
    double gap = 12.0,
    double padding = 8.0,
  })  : assert(gap >= 0.0),
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
  InkPageIndicatorState createState() => InkPageIndicatorState();
}

// ignore: public_member_api_docs
class InkPageIndicatorState
    extends PageIndicatorState<InkPageIndicator, InkPageIndicatorData> {
  @override
  InkPageIndicatorData get newValue => InkPageIndicatorData(
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        inkColor: widget.inkColor,
        gap: widget.gap,
        shape: widget.shape,
        activeShape: widget.activeShape,
      );

  @override
  Widget builder(BuildContext context, InkPageIndicatorData data) {
    if (pageCount == 0) return SizedBox(height: widget.shape.height);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.padding),
      child: SizedBox(
        height: widget.shape.height,
        child: CustomPaint(
          size: Size.infinite,
          painter: InkPageIndicatorPainter(this, data),
        ),
      ),
    );
  }
}
