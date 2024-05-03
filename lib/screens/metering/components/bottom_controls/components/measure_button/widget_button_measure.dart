import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/filled_circle/widget_circle_filled.dart';
import 'package:lightmeter/utils/context_utils.dart';

const String _subscript100 = '\u2081\u2080\u2080';

class MeteringMeasureButton extends StatefulWidget {
  final double? ev;
  final double? ev100;
  final bool isMetering;
  final VoidCallback onTap;

  const MeteringMeasureButton({
    required this.ev,
    required this.ev100,
    required this.isMetering,
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
    return GestureDetector(
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
                  child: widget.ev != null ? _EvValueText(ev: widget.ev!, ev100: widget.ev100!) : null,
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
    );
  }
}

class _EvValueText extends StatelessWidget {
  final double ev;
  final double ev100;

  const _EvValueText({
    required this.ev,
    required this.ev100,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      _text(context),
      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.surface),
      textAlign: TextAlign.center,
    );
  }

  String _text(BuildContext context) {
    final bool showEv100 = context.isPro && UserPreferencesProvider.showEv100Of(context);
    final StringBuffer buffer = StringBuffer()
      ..writeAll([
        (showEv100 ? ev100 : ev).toStringAsFixed(1),
        '\n',
        S.of(context).ev,
        if (showEv100) _subscript100,
      ]);
    return buffer.toString();
  }
}
