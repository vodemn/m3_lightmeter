import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

mixin AnimatedDialogClosedChild on Widget {
  Color backgroundColor(BuildContext context);
}

class AnimatedDialog extends StatefulWidget {
  final Size? openedSize;
  final AnimatedDialogClosedChild? closedChild;
  final Widget? openedChild;
  final Widget? child;

  const AnimatedDialog({
    this.openedSize,
    this.closedChild,
    this.openedChild,
    this.child,
    super.key,
  });

  static Future<void>? maybeClose(BuildContext context) =>
      context.findAncestorWidgetOfExactType<_AnimatedOverlay>()?.onDismiss();

  @override
  State<AnimatedDialog> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog> with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();

  late Size _closedSize;
  late Offset _closedOffset;

  late final AnimationController _animationController;
  late final CurvedAnimation _defaultCurvedAnimation;
  late final Animation<Color?> _barrierColorAnimation;
  late SizeTween _sizeTween;
  late Animation<Size?> _sizeAnimation;
  late Animation<Size?> _offsetAnimation;
  late final Animation<double> _borderRadiusAnimation;
  late final Animation<double> _closedOpacityAnimation;
  late final Animation<double> _openedOpacityAnimation;
  late Animation<Color?> _foregroundColorAnimation;
  late Animation<double> _elevationAnimation;

  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    //timeDilation = 10.0;
    _animationController = AnimationController(
      duration: Dimens.durationL,
      reverseDuration: Dimens.durationML,
      vsync: this,
    );
    _defaultCurvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _barrierColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.black54,
    ).animate(_defaultCurvedAnimation);
    _borderRadiusAnimation = Tween<double>(
      begin: Dimens.borderRadiusM,
      end: Dimens.borderRadiusXL,
    ).animate(_defaultCurvedAnimation);

    _closedOpacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0,
          0.8,
          curve: Curves.ease,
        ),
      ),
    );
    _openedOpacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.8,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _setClosedOffset();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _foregroundColorAnimation = ColorTween(
      begin: widget.closedChild?.backgroundColor(context) ?? Theme.of(context).colorScheme.primaryContainer,
      end: Theme.of(context).colorScheme.surface,
    ).animate(_defaultCurvedAnimation);

    _elevationAnimation = Tween<double>(
      begin: 0,
      end: Theme.of(context).dialogTheme.elevation,
    ).animate(_defaultCurvedAnimation);
  }

  @override
  void didUpdateWidget(covariant AnimatedDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setClosedOffset();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _key,
      onTap: _openDialog,
      child: Opacity(
        opacity: _isDialogShown ? 0 : 1,
        child: widget.child ?? widget.closedChild,
      ),
    );
  }

  void _setClosedOffset() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = _key.currentContext?.findRenderObject()! as RenderBox?;
      if (renderBox != null) {
        final size = MediaQuery.sizeOf(context);
        final padding = MediaQuery.paddingOf(context);
        final maxWidth = size.width - padding.horizontal - Dimens.dialogMargin.horizontal;
        final maxHeight = size.height - padding.vertical - Dimens.dialogMargin.vertical;
        _closedSize = _key.currentContext!.size!;
        _sizeTween = SizeTween(
          begin: _closedSize,
          end: Size(
            min(widget.openedSize?.width ?? double.maxFinite, maxWidth),
            min(widget.openedSize?.height ?? double.maxFinite, maxHeight),
          ),
        );
        _sizeAnimation = _sizeTween.animate(_defaultCurvedAnimation);

        _closedOffset = renderBox.localToGlobal(Offset.zero);
        _offsetAnimation = SizeTween(
          begin: Size(
            _closedOffset.dx + _closedSize.width / 2,
            _closedOffset.dy + _closedSize.height / 2,
          ),
          end: Size(
            size.width / 2,
            size.height / 2 + padding.top / 2 - padding.bottom / 2,
          ),
        ).animate(_defaultCurvedAnimation);
      }
    });
  }

  void _openDialog() {
    Navigator.of(context).push(
      PageRouteBuilder(
        barrierColor: Colors.transparent,
        opaque: false,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => WillPopScope(
          onWillPop: () => _animateReverse().then((value) => true),
          child: _AnimatedOverlay(
            controller: _animationController,
            barrierColorAnimation: _barrierColorAnimation,
            sizeAnimation: _sizeAnimation,
            offsetAnimation: _offsetAnimation,
            borderRadiusAnimation: _borderRadiusAnimation,
            foregroundColorAnimation: _foregroundColorAnimation,
            elevationAnimation: _elevationAnimation,
            onDismiss: close,
            builder: widget.closedChild != null && widget.openedChild != null
                ? (_) => _AnimatedSwitcher(
                      sizeAnimation: _sizeAnimation,
                      closedOpacityAnimation: _closedOpacityAnimation,
                      openedOpacityAnimation: _openedOpacityAnimation,
                      closedSize: _sizeTween.begin!,
                      openedSize: _sizeTween.end!,
                      closedChild: widget.closedChild!,
                      openedChild: widget.openedChild!,
                    )
                : null,
            child: widget.child,
          ),
        ),
      ),
    );
    _animateForward();
  }

  Future<void> _animateForward() async {
    setState(() {
      _isDialogShown = true;
    });
    await _animationController.forward();
  }

  Future<void> _animateReverse() async {
    await _animationController.reverse();
    setState(() {
      _isDialogShown = false;
    });
  }

  Future<void> close() => _animateReverse().then((_) => Navigator.of(context).pop());
}

class _AnimatedOverlay extends StatelessWidget {
  final AnimationController controller;
  final Animation<Color?> barrierColorAnimation;
  final Animation<Size?> sizeAnimation;
  final Animation<Size?> offsetAnimation;
  final Animation<double> borderRadiusAnimation;
  final Animation<Color?> foregroundColorAnimation;
  final Animation<double> elevationAnimation;
  final Future<void> Function() onDismiss;
  final Widget? child;
  final Widget Function(BuildContext context)? builder;

  const _AnimatedOverlay({
    required this.controller,
    required this.barrierColorAnimation,
    required this.sizeAnimation,
    required this.offsetAnimation,
    required this.borderRadiusAnimation,
    required this.foregroundColorAnimation,
    required this.elevationAnimation,
    required this.onDismiss,
    this.child,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: MediaQuery.of(context).size,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: onDismiss,
                child: ColoredBox(color: barrierColorAnimation.value!),
              ),
            ),
            Positioned.fromRect(
              rect: Rect.fromCenter(
                center: Offset(
                  offsetAnimation.value!.width,
                  offsetAnimation.value!.height,
                ),
                width: sizeAnimation.value!.width,
                height: sizeAnimation.value!.height,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadiusAnimation.value),
                child: Material(
                  elevation: elevationAnimation.value,
                  surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
                  color: foregroundColorAnimation.value,
                  child: builder?.call(context) ?? child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedSwitcher extends StatelessWidget {
  final Animation<Size?> sizeAnimation;
  final Animation<double> closedOpacityAnimation;
  final Animation<double> openedOpacityAnimation;
  final Size closedSize;
  final Size openedSize;
  final Widget closedChild;
  final Widget openedChild;

  const _AnimatedSwitcher({
    required this.sizeAnimation,
    required this.closedOpacityAnimation,
    required this.openedOpacityAnimation,
    required this.closedSize,
    required this.openedSize,
    required this.closedChild,
    required this.openedChild,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: closedOpacityAnimation.value,
          child: Transform.scale(
            scale: sizeAnimation.value!.width / closedSize.width,
            child: SizedBox(
              width: closedSize.width,
              child: closedChild,
            ),
          ),
        ),
        Opacity(
          opacity: openedOpacityAnimation.value,
          child: openedChild,
        ),
      ],
    );
  }
}
