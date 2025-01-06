import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class CenteredSlider extends StatefulWidget {
  final Icon? icon;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final bool isVertical;

  const CenteredSlider({
    this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.isVertical = false,
    super.key,
  });

  @override
  State<CenteredSlider> createState() => _CenteredSliderState();
}

class _CenteredSliderState extends State<CenteredSlider> {
  double relativeValue = 0.0;

  @override
  void initState() {
    super.initState();
    relativeValue = (widget.value - widget.min) / (widget.max - widget.min);
  }

  @override
  void didUpdateWidget(CenteredSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    relativeValue = (widget.value - widget.min) / (widget.max - widget.min);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.isVertical ? double.maxFinite : Dimens.cameraSliderHandleArea,
      width: !widget.isVertical ? double.maxFinite : Dimens.cameraSliderHandleArea,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final biggestSize = widget.isVertical ? constraints.maxHeight : constraints.maxWidth;
          final handleDistance = biggestSize - Dimens.cameraSliderHandleArea;
          return RotatedBox(
            quarterTurns: widget.isVertical ? -1 : 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapUp: (details) => _updateHandlePosition(
                details.localPosition.dx,
                handleDistance,
              ),
              onHorizontalDragUpdate: (details) => _updateHandlePosition(
                details.localPosition.dx,
                handleDistance,
              ),
              child: SizedBox(
                height: Dimens.cameraSliderHandleArea,
                width: biggestSize,
                child: _Slider(
                  handleDistance: handleDistance,
                  handleSize: Dimens.cameraSliderHandleArea,
                  trackThickness: Dimens.cameraSliderTrackHeight,
                  value: relativeValue,
                  icon: RotatedBox(
                    quarterTurns: widget.isVertical ? 1 : 0,
                    child: widget.icon,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _updateHandlePosition(double offset, double handleDistance) {
    if (offset <= Dimens.cameraSliderHandleArea / 2) {
      relativeValue = 0;
    } else if (offset >= handleDistance + Dimens.cameraSliderHandleArea / 2) {
      relativeValue = 1;
    } else {
      relativeValue = (offset - Dimens.cameraSliderHandleArea / 2) / handleDistance;
    }
    setState(() {});
    widget.onChanged(relativeValue * (widget.max - widget.min) + widget.min);
  }
}

class _Slider extends StatelessWidget {
  final double handleSize;
  final double trackThickness;
  final double handleDistance;
  final double value;
  final Widget icon;

  const _Slider({
    required this.handleSize,
    required this.trackThickness,
    required this.handleDistance,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          height: trackThickness,

          /// add thickness to maintain radius overlap with handle
          width: handleDistance + trackThickness,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(trackThickness / 2),
            child: ColoredBox(color: Theme.of(context).colorScheme.surfaceContainerHighest),
          ),
        ),
        AnimatedPositioned.fromRect(
          duration: Dimens.durationS,
          rect: Rect.fromCenter(
            center: Offset(
              handleSize / 2 + handleDistance * value,
              handleSize / 2,
            ),
            width: handleSize,
            height: handleSize,
          ),
          child: Center(
            child: _Handle(
              color: Theme.of(context).colorScheme.primary,
              size: Dimens.cameraSliderHandleSize,
              child: IconTheme(
                data: Theme.of(context).iconTheme.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: Dimens.cameraSliderHandleIconSize,
                    ),
                child: icon,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Handle extends StatelessWidget {
  final Color color;
  final double size;
  final Widget? child;

  const _Handle({
    required this.color,
    required this.size,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}
