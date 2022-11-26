import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class MeteringScreenAnimatedSurface extends _AnimatedSurface {
  MeteringScreenAnimatedSurface.top({
    required super.controller,
    required super.areaHeight,
    required super.overflowSize,
    required super.child,
  }) : super(
          alignment: Alignment.topCenter,
          borderRadiusBegin: const BorderRadius.only(
            bottomLeft: Radius.circular(Dimens.borderRadiusL),
            bottomRight: Radius.circular(Dimens.borderRadiusL),
          ),
        );

  MeteringScreenAnimatedSurface.bottom({
    required super.controller,
    required super.areaHeight,
    required super.overflowSize,
    required super.child,
  }) : super(
          alignment: Alignment.bottomCenter,
          borderRadiusBegin: const BorderRadius.only(
            topLeft: Radius.circular(Dimens.borderRadiusL),
            topRight: Radius.circular(Dimens.borderRadiusL),
          ),
        );
}

class _AnimatedSurface extends StatelessWidget {
  final AnimationController controller;
  final Alignment alignment;
  final double areaHeight;
  final double overflowSize;
  final Widget child;

  final Animation<BorderRadius?> _borderRadiusAnimation;
  final Animation<double> _childOpacityAnimation;
  final Animation<double> _overflowHeightAnimation;

  _AnimatedSurface({
    required this.controller,
    required this.alignment,
    required BorderRadius borderRadiusBegin,
    required this.areaHeight,
    required this.overflowSize,
    required this.child,
  })  : _borderRadiusAnimation = BorderRadiusTween(
          begin: borderRadiusBegin,
          end: BorderRadius.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.4, 1.0, curve: Curves.linear),
          ),
        ),
        _childOpacityAnimation = Tween<double>(
          begin: 1,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.4, curve: Curves.linear),
          ),
        ),
        _overflowHeightAnimation = Tween<double>(
          begin: 0,
          end: overflowSize,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 1.0, curve: Curves.linear),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) => SizedBox(
        height: areaHeight + _overflowHeightAnimation.value,
        child: ClipRRect(
          borderRadius: _borderRadiusAnimation.value,
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            child: Align(
              alignment: alignment,
              child: Opacity(
                opacity: _childOpacityAnimation.value,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
