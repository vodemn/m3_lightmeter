import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/filled_circle/widget_circle_filled.dart';

class MeteringMeasureButton extends StatefulWidget {
  final double? ev;
  final bool isMetering;
  final bool hasError;
  final VoidCallback onTap;

  const MeteringMeasureButton({
    required this.ev,
    required this.isMetering,
    required this.hasError,
    required this.onTap,
    super.key,
  });

  @override
  State<MeteringMeasureButton> createState() => _MeteringMeasureButtonState();
}

class _MeteringMeasureButtonState extends State<MeteringMeasureButton> {
  bool _isPressed = false;

  @override
  void didUpdateWidget(covariant MeteringMeasureButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMetering != widget.isMetering) {
      _isPressed = widget.isMetering;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isMetering && widget.ev == null && !widget.hasError,
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
        child: SizedBox.fromSize(
          size: const Size.square(Dimens.grid72),
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
                      child: widget.hasError
                          ? Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.surface,
                              size: Dimens.grid24,
                            )
                          : (widget.ev != null ? _EvValueText(ev: widget.ev!) : null),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: CircularProgressIndicator(
                  /// This key is needed to make indicator start from the same point every time
                  key: ValueKey(widget.isMetering),
                  color: Theme.of(context).colorScheme.onSurface,
                  value: widget.isMetering ? null : 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EvValueText extends StatelessWidget {
  final double ev;

  const _EvValueText({required this.ev});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      '${ev.toStringAsFixed(1)}\n${S.of(context).ev}',
      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.surface),
      textAlign: TextAlign.center,
    );
  }
}
