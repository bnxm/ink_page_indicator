import 'package:flutter/material.dart';

import 'package:ink_page_indicator/src/base/base.dart';

// ignore_for_file: public_member_api_docs

/// A PageController for a PageView that uses a [PageIndicator].
///
/// The PageController can infer the `page` as well as the `pageCount`
/// for a [PageIndicator].
class PageIndicatorController extends PageController {
  PageIndicatorController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
  }) : super(
          initialPage: initialPage,
          keepPage: keepPage,
          viewportFraction: viewportFraction,
        );

  double get viewportSize => hasClients ? position.viewportDimension : 0;

  int get pageCount {
    if (viewportSize == 0) return 0;

    // A page is an increment of the viewport size
    return ((viewportSize + position.maxScrollExtent) / viewportSize).ceil();
  }

  // Allow multiple Indicators to listen on the same
  // controller.
  final List<PageIndicatorState> _indicators = [];

  void Function(int page, Duration duration)? onAnimateToPage;

  @override
  Future<void> animateToPage(
    int page, {
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.linear,
  }) async {
    final future = super.animateToPage(page, duration: duration, curve: curve);

    for (final indicator in _indicators) {
      indicator.onAnimateToPage(page, future);
    }
  }

  /// Registers the current indicator to listen for events of
  /// this [PageIndicatorController].
  void registerIndicator(PageIndicatorState indicator) {
    _indicators.add(indicator);
  }

  /// Unregisters the current indicator to listen for events of
  /// this [PageIndicatorController].
  void unregisterIndicator(PageIndicatorState indicator) {
    _indicators.remove(indicator);
  }

  @override
  void dispose() {
    for (final indicator in _indicators) {
      unregisterIndicator(indicator);
    }

    super.dispose();
  }
}
