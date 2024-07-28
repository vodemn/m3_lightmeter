import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/shared/animated_circular_button/widget_button_circular_animated.dart';
import 'package:lightmeter/screens/shared/bottom_controls_bar/widget_bottom_controls_bar.dart';
import 'package:lightmeter/utils/context_utils.dart';

class MeteringBottomControls extends StatelessWidget {
  final double? ev;
  final double? ev100;
  final bool isMetering;
  final VoidCallback? onSwitchEvSourceType;
  final VoidCallback onMeasure;
  final VoidCallback onSettings;

  const MeteringBottomControls({
    required this.ev,
    required this.ev100,
    required this.isMetering,
    required this.onSwitchEvSourceType,
    required this.onMeasure,
    required this.onSettings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomControlsBar(
      left: onSwitchEvSourceType != null
          ? IconButton.filledTonal(
              onPressed: onSwitchEvSourceType,
              icon: Icon(
                UserPreferencesProvider.evSourceTypeOf(context) != EvSourceType.camera
                    ? Icons.camera_rear_outlined
                    : Icons.wb_incandescent_outlined,
              ),
              tooltip: UserPreferencesProvider.evSourceTypeOf(context) != EvSourceType.camera
                  ? S.of(context).tooltipUseCamera
                  : S.of(context).tooltipUseLightSensor,
            )
          : null,
      center: AnimatedCircluarButton(
        progress: isMetering ? null : 1.0,
        isPressed: isMetering,
        onPressed: onMeasure,
        child: ev != null ? _EvValueText(ev: ev!, ev100: ev100!) : null,
      ),
      right: IconButton.filledTonal(
        onPressed: onSettings,
        icon: const Icon(Icons.settings_outlined),
        tooltip: S.of(context).tooltipOpenSettings,
      ),
    );
  }
}

class _EvValueText extends StatelessWidget {
  static const String _subscript100 = '\u2081\u2080\u2080';
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
