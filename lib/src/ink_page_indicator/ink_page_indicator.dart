import 'package:flutter/material.dart';

import 'package:ink_page_indicator/src/src.dart';
import 'package:ink_page_indicator/src/ink_page_indicator/ink_page_indicator_data.dart';
import 'package:ink_page_indicator/src/ink_page_indicator/ink_page_indicator_painter.dart';

enum InkStyle {
  simple,
  modern,
  none,
}

class InkPageIndicator extends PageIndicator {
  final Color inkColor;
  final InkStyle style;
  InkPageIndicator({
    Key key,
    @required int itemCount,
    @required PageIndicatorController controller,
    this.style = InkStyle.modern,
    this.inkColor,
    IndicatorShape shape,
    IndicatorShape activeShape,
    Color activeColor = Colors.black,
    Color inActiveColor = Colors.grey,
    double gap = 12.0,
    double padding = 8.0,
  })  : assert(style != null),
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
  InkPageIndicatorState createState() => InkPageIndicatorState();
}

class InkPageIndicatorState extends PageIndicatorState<InkPageIndicator, InkPageIndicatorData> {
  @override
  InkPageIndicatorData get newValue => InkPageIndicatorData(
        activeColor: widget.activeColor,
        inActiveColor: widget.inActiveColor,
        inkColor: widget.inkColor,
        gap: widget.gap,
        shape: widget.shape,
        activeShape: widget.activeShape,
      );

  @override
  Widget builder(BuildContext context, InkPageIndicatorData data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.padding),
      child: SizedBox(
        height: widget.shape.height,
        child: CustomPaint(
          size: Size.infinite,
          painter: InkPageIndicatorPainter(
            this,
            data,
          ),
        ),
      ),
    );
  }
}
