import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// ignore_for_file: public_member_api_docs

/// A base Widget for implicit animations.
abstract class ImplicitAnimation extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  const ImplicitAnimation(
    Key? key,
    this.duration,
    this.curve,
  ) : super(key: key);
}

abstract class ImplicitAnimationState<T, W extends ImplicitAnimation>
    extends State<W> with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  )..value = 1.0;

  late var animation = CurvedAnimation(
    curve: widget.curve,
    parent: controller,
  )..addListener(
      () => value = lerp(v, oldValue, newValue),
    );

  double get v => animation.value;
  T get newValue;
  late T value = newValue;
  late T oldValue = newValue;

  @override
  void didUpdateWidget(W oldWidget) {
    super.didUpdateWidget(oldWidget);

    controller.duration = widget.duration;

    animation = CurvedAnimation(
      curve: widget.curve,
      parent: controller,
    );

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
      builder: (context, child) => builder(context, value),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
