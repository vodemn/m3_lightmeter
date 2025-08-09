import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

class FilledButtonLarge extends StatelessWidget {
  const FilledButtonLarge({
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: Theme.of(context)
          .filledButtonTheme
          .style!
          .copyWith(textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.titleMedium)),
      onPressed: onPressed,
      child: Text(S.of(context).continuePurchase),
    );
  }
}
