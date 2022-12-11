import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/measure_button.dart';
import 'components/side_buttons.dart';

class MeteringBottomControls extends StatelessWidget {
  final VoidCallback onSourceChanged;
  final VoidCallback onMeasure;
  final VoidCallback onSettings;

  const MeteringBottomControls({
    required this.onSourceChanged,
    required this.onMeasure,
    required this.onSettings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(Dimens.borderRadiusL),
        topRight: Radius.circular(Dimens.borderRadiusL),
      ),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimens.paddingL),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MeteringBottomControlsSideButton(
                  onPressed: onSourceChanged,
                  icon: Icons.flip_camera_android,
                ),
                MeteringMeasureButton(
                  onTap: onMeasure,
                ),
                MeteringBottomControlsSideButton(
                  onPressed: onSettings,
                  icon: Icons.settings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
