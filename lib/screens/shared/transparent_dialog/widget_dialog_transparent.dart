import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/utils/text_height.dart';

class TransparentDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget content;
  final bool scrollableContent;
  final List<Widget> actions;

  const TransparentDialog({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.content,
    required this.scrollableContent,
    this.actions = const [],
    super.key,
  });

  static double height(
    BuildContext context, {
    required String title,
    String? subtitle,
    required double contextHeight,
    bool scrollableContent = false,
  }) {
    double height = IconTheme.of(context).size! + Dimens.dialogTitlePadding.vertical;
    height += dialogTextHeight(
          context,
          title,
          Theme.of(context).textTheme.headlineSmall,
          Dimens.dialogIconTitlePadding.horizontal,
        ) +
        Dimens.dialogIconTitlePadding.vertical;
    if (subtitle != null) {
      height += dialogTextHeight(
            context,
            subtitle,
            Theme.of(context).textTheme.bodyMedium,
            Dimens.dialogIconTitlePadding.horizontal,
          ) +
          Dimens.dialogIconTitlePadding.vertical;
    }
    height += contextHeight;
    if (scrollableContent) height += 1;
    return height += 48 + Dimens.dialogActionsPadding.vertical;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: Dimens.dialogTitlePadding,
              child: Icon(icon),
            ),
            Padding(
              padding: Dimens.dialogIconTitlePadding,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: Dimens.dialogIconTitlePadding,
                child: Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        if (scrollableContent) const Divider(),
        content,
        if (scrollableContent) const Divider(),
        Padding(
          padding: Dimens.dialogActionsPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _actions().toList(),
          ),
        ),
      ],
    );
  }

  Iterable<Widget> _actions() sync* {
    for (int i = 0; i < actions.length; i++) {
      yield i == 0 ? const Spacer() : const SizedBox(width: Dimens.grid16);
      yield actions[i];
    }
  }
}
