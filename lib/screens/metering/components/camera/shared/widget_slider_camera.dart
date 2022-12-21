import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class CameraSlider extends StatefulWidget {
  final Icon icon;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final bool isVertical;

  const CameraSlider({
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.isVertical = false,
    super.key,
  });

  @override
  State<CameraSlider> createState() => _CameraSliderState();
}

class _CameraSliderState extends State<CameraSlider> {
  double relativeValue = 0.0;

  @override
  void initState() {
    super.initState();
    relativeValue = (widget.value - widget.min) / (widget.max - widget.min);
  }

  @override
  void didUpdateWidget(CameraSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    relativeValue = (widget.value - widget.min) / (widget.max - widget.min);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final biggestSize = widget.isVertical ? constraints.maxHeight : constraints.maxWidth;
        final handleDistance = biggestSize - Dimens.cameraSliderHandleSize;
        return RotatedBox(
          quarterTurns: widget.isVertical ? -1 : 0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapUp: (details) => _updateHandlePosition(details.localPosition.dx, handleDistance),
            onHorizontalDragUpdate: (details) => _updateHandlePosition(details.localPosition.dx, handleDistance),
            child: SizedBox(
              height: Dimens.cameraSliderHandleSize,
              width: biggestSize,
              child: _Slider(
                handleDistance: handleDistance,
                handleSize: Dimens.cameraSliderHandleSize,
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
    );
  }

  void _updateHandlePosition(double offset, double handleDistance) {
    if (offset <= Dimens.cameraSliderHandleSize / 2) {
      relativeValue = 0;
    } else if (offset >= handleDistance + Dimens.cameraSliderHandleSize / 2) {
      relativeValue = 1;
    } else {
      relativeValue = (offset - Dimens.cameraSliderHandleSize / 2) / handleDistance;
    }
    setState(() {});
    widget.onChanged(_clampToRange(relativeValue));
  }

  double _clampToRange(double relativeValue) => relativeValue * (widget.max - widget.min) + widget.min;
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
          width: handleDistance + trackThickness, // add thickness to maintain radius overlap with handle
          child: ClipRRect(
            borderRadius: BorderRadius.circular(trackThickness / 2),
            child: ColoredBox(color: Theme.of(context).colorScheme.surfaceVariant),
          ),
        ),
        AnimatedPositioned.fromRect(
          duration: Dimens.durationM,
          rect: Rect.fromCenter(
            center: Offset(
              handleSize / 2 + handleDistance * value,
              handleSize / 2,
            ),
            width: handleSize,
            height: handleSize,
          ),
          child: _Handle(
            color: Theme.of(context).colorScheme.primary,
            size: handleSize,
            child: IconTheme(
              data: Theme.of(context).iconTheme.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: Dimens.cameraSliderHandleIconSize,
                  ),
              child: icon,
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: SizedBox(
        height: size,
        width: size,
        child: ColoredBox(
          color: color,
          child: child,
        ),
      ),
    );
  }
}
