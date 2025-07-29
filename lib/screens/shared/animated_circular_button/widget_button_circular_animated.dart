import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/filled_circle/widget_circle_filled.dart';

class AnimatedCircularButton extends StatefulWidget {
  final double? progress;
  final bool isPressed;
  final VoidCallback onPressed;
  final Widget? child;

  const AnimatedCircularButton({
    this.progress = 1.0,
    required this.isPressed,
    required this.onPressed,
    this.child,
    super.key,
  });

  @override
  State<AnimatedCircularButton> createState() => _AnimatedCircularButtonState();
}

class _AnimatedCircularButtonState extends State<AnimatedCircularButton> {
  bool _isPressed = false;

  @override
  void didUpdateWidget(covariant AnimatedCircularButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPressed != widget.isPressed) {
      _isPressed = widget.isPressed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
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
      child: Stack(
        children: [
          Center(
            child: AnimatedScale(
              duration: Dimens.durationS,
              scale: _isPressed ? 0.9 : 1.0,
              child: FilledCircle(
                color: Theme.of(context).colorScheme.onSurface,
                size: Dimens.grid72 - Dimens.grid8,
                child: Center(
                  child: widget.child,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: CircularProgressIndicator(
              /// This key is needed to make indicator start from the same point every time
              key: ValueKey(widget.progress),
              color: Theme.of(context).colorScheme.onSurface,
              value: widget.progress,
            ),
          ),
        ],
      ),
    );
  }
}
