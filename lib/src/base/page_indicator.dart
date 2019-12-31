import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

import 'package:ink_page_indicator/src/src.dart';

abstract class PageIndicator extends ImplicitAnimation {
  final int itemCount;
  final PageIndicatorController controller;
  final double padding;
  final Color activeColor;
  final Color inActiveColor;
  final double gap;
  final IndicatorShape shape;
  final IndicatorShape activeShape;
  PageIndicator({
    Key key,
    @required IndicatorShape shape,
    @required IndicatorShape activeShape,
    @required this.itemCount,
    @required this.padding,
    @required this.controller,
    @required this.activeColor,
    @required this.inActiveColor,
    @required this.gap,
  })  : shape = shape ?? IndicatorShape.circle(8),
        activeShape = activeShape ?? shape,
        assert(controller != null),
        assert(padding != null),
        assert(itemCount != null && itemCount >= 1),
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
  int get itemCount => widget.itemCount;

  @nonVirtual
  int get maxPages => itemCount - 1;

  double _p = 0;
  double get page => _p;
  set _page(double value) => _p = value.clamp(0.0, maxPages.toDouble());

  int _np = 0;
  int get nextPage => _np;
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
    } else if (itemCount >= 2) {
      _nextPage = 1;
    }
  }

  void _listener() {
    if (!pageController.hasClients) return;

    _page = pageController.page;
    _dir = pageController.position.userScrollDirection;

    _findNextPageIndices();
    _calculateScrollProgress();
    setState(() {});
  }

  void _debugPrint() {
    print(
      '${page.toStringAsFixed(2)}, $currentPage, $nextPage, ${progress.toStringAsFixed(2)}, $dir, $inAnimation',
    );
  }

  void _findNextPageIndices() {
    if (inAnimation) return;

    if (_currentPage >= itemCount) {
      _currentPage = itemCount - 1;
    }

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

  void onAnimateToPage(int page, Future future) async {
    inAnimation = true;
    _currentPage = this.page.floor();
    _progress = 0.0;
    _nextPage = page;
    await future;
    inAnimation = false;
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
