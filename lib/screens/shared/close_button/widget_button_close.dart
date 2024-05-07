import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: Navigator.of(context).pop,
      icon: const Icon(Icons.close),
      tooltip: S.of(context).tooltipClose,
    );
  }
}
