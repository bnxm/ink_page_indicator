import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// ignore_for_file: public_member_api_docs

/// A base Widget for implicit animations.
abstract class ImplicitAnimation extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  const ImplicitAnimation(
    Key key,
    this.duration,
    this.curve,
  )   : assert(duration != null),
        super(key: key);
}

abstract class ImplicitAnimationState<T, W extends ImplicitAnimation>
    extends State<W> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  AnimationController get controller => _controller;

  Animation<double> _animation;
  Animation<double> get animation => _animation;

  double get v => animation.value;
  T get newValue;
  T value;
  T oldValue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..value = 1.0;

    _animation = CurvedAnimation(
      curve: widget.curve ?? Curves.linear,
      parent: controller,
    );

    value = newValue;
    oldValue = newValue;

    animation.addListener(
      () => value = lerp(v, oldValue, newValue),
    );
  }

  @override
  void didUpdateWidget(W oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      controller.duration = widget.duration;
    }

    if (oldWidget.curve != widget.curve) {
      _animation = CurvedAnimation(
        curve: widget.curve ?? Curves.linear,
        parent: controller,
      );
    }

    if (value != newValue) {
      oldValue = value;
      controller.reset();
      controller.forward();
    }
  }

  T lerp(double v, T a, T b);

  Widget builder(BuildContext context, T value);

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return builder(context, value);
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
