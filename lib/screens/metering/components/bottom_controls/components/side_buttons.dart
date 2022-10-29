import 'package:flutter/material.dart';
import 'package:lightmeter/screens/metering/components/shared/filled_circle.dart';

class MeteringBottomControlsSideButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const MeteringBottomControlsSideButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledCircle(
      color: Theme.of(context).colorScheme.surfaceVariant,
      size: 48,
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          color: Theme.of(context).colorScheme.onSurface,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
