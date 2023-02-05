import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

class EmptyExposurePairsList extends StatelessWidget {
  const EmptyExposurePairsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.not_interested,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          const SizedBox(height: Dimens.grid8),
          Text(
            S.of(context).noExposurePairs,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
