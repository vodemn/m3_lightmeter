import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

import 'shared/widget_circle_filled.dart';

class MeteringMeasureButton extends StatefulWidget {
  final double size;
  final VoidCallback onTap;

  const MeteringMeasureButton({
    required this.onTap,
    this.size = 72,
    super.key,
  });

  @override
  State<MeteringMeasureButton> createState() => _MeteringMeasureButtonState();
}

class _MeteringMeasureButtonState extends State<MeteringMeasureButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.square(widget.size),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size / 2),
            border: Border.all(
              width: Dimens.grid4,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: Center(
            child: AnimatedScale(
              duration: Dimens.durationS,
              scale: _isPressed ? 0.9 : 1.0,
              child: FilledCircle(
                color: Theme.of(context).colorScheme.onSurface,
                size: widget.size - Dimens.grid16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
