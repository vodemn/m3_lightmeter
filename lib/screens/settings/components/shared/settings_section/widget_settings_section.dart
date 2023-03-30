import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    required this.title,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimens.paddingM,
        0,
        Dimens.paddingM,
        Dimens.paddingM,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
