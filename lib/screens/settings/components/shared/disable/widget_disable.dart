import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class Disable extends StatelessWidget {
  final bool disable;
  final Widget? child;

  const Disable({
    this.disable = true,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disable ? Dimens.disabledOpacity : Dimens.enabledOpacity,
      child: IgnorePointer(
        ignoring: disable,
        child: child,
      ),
    );
  }
}
