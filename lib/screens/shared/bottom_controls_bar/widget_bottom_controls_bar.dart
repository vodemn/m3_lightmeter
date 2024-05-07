import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class BottomControlsBar extends StatelessWidget {
  final Widget center;
  final Widget? left;
  final Widget? right;

  const BottomControlsBar({
    required this.center,
    this.left,
    this.right,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButtonTheme(
      data: IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(scheme.surface),
          elevation: const MaterialStatePropertyAll(4),
          iconColor: MaterialStatePropertyAll(scheme.onSurface),
          shadowColor: const MaterialStatePropertyAll(Colors.transparent),
          surfaceTintColor: MaterialStatePropertyAll(scheme.surfaceTint),
          fixedSize: const MaterialStatePropertyAll(Size(Dimens.grid48, Dimens.grid48)),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimens.borderRadiusL),
          topRight: Radius.circular(Dimens.borderRadiusL),
        ),
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.paddingL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (left != null) Expanded(child: Center(child: left)) else const Spacer(),
                  SizedBox.fromSize(
                    size: const Size.square(Dimens.grid72),
                    child: center,
                  ),
                  if (right != null) Expanded(child: Center(child: right)) else const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
