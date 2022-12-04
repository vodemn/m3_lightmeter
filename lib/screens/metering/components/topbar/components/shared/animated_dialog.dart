import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lightmeter/res/dimens.dart';

class AnimatedDialog extends StatefulWidget {
  final Size? openedSize;
  final Widget? closedChild;
  final Widget? openedChild;
  final Widget? child;

  const AnimatedDialog({
    this.openedSize,
    this.closedChild,
    this.openedChild,
    this.child,
    super.key,
  });

  @override
  State<AnimatedDialog> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog> with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  final LayerLink _layerLink = LayerLink();

  late final Size _closedSize;
  late final Offset _closedOffset;

  late final AnimationController _animationController;
  late final CurvedAnimation _defaultCurvedAnimation;
  late final Animation<Color?> _barrierColorAnimation;
  late final SizeTween _sizeTween;
  late final Animation<Size?> _sizeAnimation;
  late final Animation<Size?> _offsetAnimation;
  late final Animation<double> _borderRadiusAnimation;
  late final Animation<double> _closedOpacityAnimation;
  late final Animation<double> _openedOpacityAnimation;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    //timeDilation = 10.0;
    _animationController = AnimationController(
      duration: Dimens.durationL,
      reverseDuration: Dimens.durationML,
      vsync: this,
    );
    _defaultCurvedAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
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
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0,
        0.8,
        curve: Curves.ease,
      ),
    ));
    _openedOpacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.8,
        1.0,
        curve: Curves.easeInOut,
      ),
    ));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final mediaQuery = MediaQuery.of(context);

      _closedSize = _key.currentContext!.size!;
      _sizeTween = SizeTween(
        begin: _closedSize,
        end: widget.openedSize ??
            Size(
              mediaQuery.size.width - mediaQuery.padding.horizontal - Dimens.paddingM * 4,
              mediaQuery.size.height - mediaQuery.padding.vertical - Dimens.paddingM * 4,
            ),
      );
      _sizeAnimation = _sizeTween.animate(_defaultCurvedAnimation);

      final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
      _closedOffset = renderBox.localToGlobal(Offset.zero);
      _offsetAnimation = SizeTween(
        begin: Size(
          _closedOffset.dx + _closedSize.width / 2,
          _closedOffset.dy + _closedSize.height / 2,
        ),
        end: Size(
          mediaQuery.size.width / 2,
          mediaQuery.size.height / 2 + mediaQuery.padding.top / 2 - mediaQuery.padding.bottom / 2,
        ),
      ).animate(_defaultCurvedAnimation);
    });
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
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Opacity(
          opacity: _overlayEntry != null ? 0 : 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.borderRadiusM),
            child: ColoredBox(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: widget.child ?? widget.closedChild,
            ),
          ),
        ),
      ),
    );
  }

  void _openDialog() {
    setState(() {
      _overlayEntry = OverlayEntry(
        builder: (context) => CompositedTransformFollower(
          offset: Offset(-_closedOffset.dx, -_closedOffset.dy),
          link: _layerLink,
          showWhenUnlinked: false,
          child: _AnimatedOverlay(
            controller: _animationController,
            barrierColorAnimation: _barrierColorAnimation,
            sizeAnimation: _sizeAnimation,
            offsetAnimation: _offsetAnimation,
            borderRadiusAnimation: _borderRadiusAnimation,
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
      );
    });
    Overlay.of(context)?.insert(_overlayEntry!);
    _animationController.forward();
  }

  Future<void> close() async {
    _animationController.reverse();
    await Future.delayed(_animationController.reverseDuration! * timeDilation);
    _overlayEntry?.remove();
    setState(() {
      _overlayEntry = null;
    });
  }
}

class _AnimatedOverlay extends StatelessWidget {
  final AnimationController controller;
  final Animation<Color?> barrierColorAnimation;
  final Animation<Size?> sizeAnimation;
  final Animation<Size?> offsetAnimation;
  final Animation<double> borderRadiusAnimation;
  final VoidCallback onDismiss;
  final Widget? child;
  final Widget Function(BuildContext context)? builder;

  const _AnimatedOverlay({
    required this.controller,
    required this.barrierColorAnimation,
    required this.sizeAnimation,
    required this.offsetAnimation,
    required this.borderRadiusAnimation,
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
                  color: Theme.of(context).colorScheme.primaryContainer,
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