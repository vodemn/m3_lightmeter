import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lightmeter/res/dimens.dart';

class ReadingValue {
  final String label;
  final String value;

  const ReadingValue({
    required this.label,
    required this.value,
  });
}

class ReadingContainerWithDialog extends StatefulWidget {
  final ReadingValue value;
  final Widget Function(BuildContext context) dialogBuilder;

  const ReadingContainerWithDialog({
    required this.value,
    required this.dialogBuilder,
    super.key,
  });

  @override
  State<ReadingContainerWithDialog> createState() => _ReadingContainerWithDialogState();
}

class _ReadingContainerWithDialogState extends State<ReadingContainerWithDialog> with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  late final _animationController = AnimationController(
    duration: Dimens.durationL,
    reverseDuration: Dimens.durationML,
    vsync: this,
  );
  late final _defaultCurve = CurvedAnimation(parent: _animationController, curve: Curves.linear);

  late final _colorAnimation = ColorTween(
    begin: Colors.transparent,
    end: Colors.black54,
  ).animate(_defaultCurve);
  late final _borderRadiusAnimation = Tween<double>(
    begin: Dimens.borderRadiusM,
    end: Dimens.borderRadiusXL,
  ).animate(_defaultCurve);
  late final _itemOpacityAnimation = Tween<double>(
    begin: 1,
    end: 0,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: const Interval(0, 0.5, curve: Curves.linear),
  ));
  late final _dialogOpacityAnimation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: const Interval(0.5, 1.0, curve: Curves.linear),
  ));

  late final SizeTween _sizeTween;
  late final Animation<Size?> _sizeAnimation;
  late final Animation<Size?> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    //timeDilation = 5.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mediaQuery = MediaQuery.of(context);
      final itemWidth = _key.currentContext!.size!.width;
      final itemHeight = _key.currentContext!.size!.height;

      _sizeTween = SizeTween(
        begin: Size(
          itemWidth,
          itemHeight,
        ),
        end: Size(
          mediaQuery.size.width - mediaQuery.padding.horizontal - Dimens.paddingL * 2,
          mediaQuery.size.height - mediaQuery.padding.vertical - Dimens.paddingL * 2,
        ),
      );
      _sizeAnimation = _sizeTween.animate(_defaultCurve);

      final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero);
      _offsetAnimation = SizeTween(
        begin: Size(
          offset.dx + itemWidth / 2,
          offset.dy + itemHeight / 2,
        ),
        end: Size(
          mediaQuery.size.width / 2,
          mediaQuery.size.height / 2 + mediaQuery.padding.top / 2 - mediaQuery.padding.bottom / 2,
        ),
      ).animate(_defaultCurve);
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.borderRadiusM),
          child: ColoredBox(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(Dimens.paddingM),
              child: _ReadingValueBuilder(widget.value),
            ),
          ),
        ),
      ),
    );
  }

  void _openDialog() {
    final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    _overlayEntry = OverlayEntry(
      builder: (context) => CompositedTransformFollower(
        offset: Offset(-offset.dx, -offset.dy),
        link: _layerLink,
        showWhenUnlinked: false,
        child: SizedBox.fromSize(
          size: MediaQuery.of(context).size,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) => Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _closeDialog,
                    child: ColoredBox(color: _colorAnimation.value!),
                  ),
                ),
                Positioned.fromRect(
                  rect: Rect.fromCenter(
                    center: Offset(
                      _offsetAnimation.value!.width,
                      _offsetAnimation.value!.height,
                    ),
                    width: _sizeAnimation.value!.width,
                    height: _sizeAnimation.value!.height,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_borderRadiusAnimation.value),
                    child: ColoredBox(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Center(
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: _itemOpacityAnimation.value,
                              child: Transform.scale(
                                scale: _sizeAnimation.value!.width / _sizeTween.begin!.width,
                                child: SizedBox(
                                  width: _sizeTween.begin!.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(Dimens.paddingM),
                                    child: _ReadingValueBuilder(widget.value),
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: _dialogOpacityAnimation.value,
                              child: Transform.scale(
                                scale: _sizeAnimation.value!.width / _sizeTween.end!.width,
                                child: widget.dialogBuilder(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context)?.insert(_overlayEntry!);
    _animationController.forward();
  }

  void _closeDialog() {
    _animationController.reverse();
    Future.delayed(_animationController.reverseDuration! * timeDilation).then((_) {
      _overlayEntry?.remove();
    });
  }
}

class ReadingContainer extends StatelessWidget {
  final List<_ReadingValueBuilder> _items;

  ReadingContainer({
    required List<ReadingValue> values,
    super.key,
  }) : _items = values.map((e) => _ReadingValueBuilder(e)).toList();

  ReadingContainer.singleValue({
    required ReadingValue value,
    super.key,
  }) : _items = [_ReadingValueBuilder(value)];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.borderRadiusM),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: _items,
          ),
        ),
      ),
    );
  }
}

class _ReadingValueBuilder extends StatelessWidget {
  final ReadingValue reading;

  const _ReadingValueBuilder(this.reading);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          reading.label,
          style: textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        const SizedBox(height: Dimens.grid4),
        Text(
          reading.value,
          style: textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      ],
    );
  }
}
