import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool enabled;

  const SettingsSection({
    required this.title,
    required this.children,
    this.enabled = true,
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
          child: Opacity(
            opacity: enabled ? Dimens.enabledOpacity : Dimens.disabledOpacity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const Spacer(),
                      if (!enabled)
                        const Icon(
                          Icons.lock,
                          size: Dimens.grid16,
                        ),
                    ],
                  ),
                ),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
