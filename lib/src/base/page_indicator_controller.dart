import 'package:flutter/material.dart';
import 'package:ink_page_indicator/src/base/base.dart';

class PageIndicatorController extends PageController {

  PageIndicatorState indicator;

  void Function(int page, Duration duration) onAnimateToPage;

  @override
  Future<void> animateToPage(int page, {Duration duration, Curve curve}) async {
    final future = super.animateToPage(page, duration: duration, curve: curve);
    indicator?.onAnimateToPage(page, future);
  }
}