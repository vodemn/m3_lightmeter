import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/shared/widget_circle_filled.dart';

class MeteringSecondaryButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const MeteringSecondaryButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledCircle(
        color: Theme.of(context).colorScheme.surfaceVariant,
        size: Dimens.grid48,
        child: Center(
          child: IconButton(
            onPressed: onPressed,
            color: Theme.of(context).colorScheme.onSurface,
            icon: Icon(icon),
          ),
        ),
      ),
    );
  }
}
