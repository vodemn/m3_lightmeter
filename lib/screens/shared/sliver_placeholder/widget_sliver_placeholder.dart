import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/icon_placeholder/widget_icon_placeholder.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';

class SliverPlaceholder extends StatelessWidget {
  final VoidCallback onTap;

  const SliverPlaceholder({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sliverScreenBottomHeight =
        context.findAncestorWidgetOfExactType<SliverScreen>()?.bottom?.preferredSize.height ?? 0.0;
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: Dimens.sliverAppBarExpandedHeight - sliverScreenBottomHeight),
        child: FractionallySizedBox(
          widthFactor: 1 / 1.618,
          child: Center(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(Dimens.paddingL),
                child: IconPlaceholder(
                  icon: Icons.add_outlined,
                  text: S.of(context).tapToAdd,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
