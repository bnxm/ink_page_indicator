import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

import 'package:ink_page_indicator/src/src.dart';

abstract class PageIndicator extends ImplicitAnimation {
  final PageIndicatorController controller;
  final double padding;
  final Color activeColor;
  final Color inactiveColor;
  final double gap;
  final IndicatorShape shape;
  final IndicatorShape activeShape;
  PageIndicator({
    Key key,
    @required IndicatorShape shape,
    @required IndicatorShape activeShape,
    @required this.padding,
    @required this.controller,
    @required this.activeColor,
    @required this.inactiveColor,
    @required this.gap,
  })  : shape = shape ?? IndicatorShape.circle(6),
        activeShape = activeShape ?? shape ?? IndicatorShape.circle(6),
        assert(controller != null),
        assert(padding != null),
        super(
          key,
          const Duration(milliseconds: 400),
          Curves.linear,
        );
}

abstract class PageIndicatorState<P extends PageIndicator, D extends IndicatorData>
    extends ImplicitAnimationState<D, P> {
  @nonVirtual
  @protected
  PageIndicatorController get pageController => widget.controller;

  @nonVirtual
  int get pageCount => pageController.pageCount;

  @nonVirtual
  int get maxPages => max(pageCount - 1, 0);

  double _p = 0;
  double get page => _p;
  // ignore: avoid_setters_without_getters
  set _page(double value) => _p = value.clamp(0.0, maxPages.toDouble());

  int _np = 0;
  int get nextPage => _np;
  // ignore: avoid_setters_without_getters
  set _nextPage(int value) => _np = value.clamp(0, maxPages);

  int _currentPage = 0;
  int get currentPage => _currentPage;

  double _progress = 0.0;
  double get progress => _progress;

  bool inAnimation = false;

  ScrollDirection _dir;
  ScrollDirection get dir => _dir;

  @override
  void initState() {
    super.initState();

    if (pageController != null) {
      _currentPage = pageController.initialPage ?? 0;
      _nextPage = _currentPage + 1;

      pageController
        ..registerIndicator(this)
        ..addListener(_listener);

      // Call the listener once the indicator is laid out to
      // recompute the page count.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _listener(),
      );
    } else if (pageCount >= 2) {
      _nextPage = 1;
    }
  }

  @override
  void didUpdateWidget(P oldWidget) {
    super.didUpdateWidget(oldWidget);
    ensureCurrentPageIsInRange();
  }

  void _listener() {
    if (!pageController.hasClients) return;

    _page = pageController.page;
    _dir = pageController.position.userScrollDirection;

    _findNextPageIndices();
    _calculateScrollProgress();

    setState(() {});
  }

  /* void _debugPrint() {
    print(
      '${page.toStringAsFixed(2)}, $currentPage, $nextPage, ${progress.toStringAsFixed(2)}, $dir, $inAnimation',
    );
  } */

  void _findNextPageIndices() {
    if (inAnimation) return;

    ensureCurrentPageIsInRange();

    // Save reached page as the new anchor
    if (page.remainder(1) == 0.0 || (page - _currentPage).abs() >= 1.0) {
      _currentPage = page.round();
    }

    final forwardScroll = page >= _currentPage;
    _nextPage = forwardScroll ? _currentPage + 1 : _currentPage - 1;
  }

  void _calculateScrollProgress() {
    _progress = ((page - currentPage) / (nextPage - currentPage)).abs().clamp(0.0, 1.0);
  }

  Future<void> onAnimateToPage(int page, Future future) async {
    inAnimation = true;
    _currentPage = this.page.floor();
    _progress = 0.0;
    _nextPage = page;
    await future;
    inAnimation = false;
  }

  @protected
  void ensureCurrentPageIsInRange() {
    if (_currentPage >= maxPages) {
      _currentPage = maxPages;
    }
  }

  @protected
  @override
  D lerp(double v, D a, D b) => a.lerpTo(b, v) as D;

  @override
  void dispose() {
    pageController?.removeListener(_listener);
    pageController?.unregisterIndicator(this);
    super.dispose();
  }
}
