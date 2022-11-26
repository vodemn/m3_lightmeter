import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/settings_screen.dart';

class SettingsPageRouteBuilder extends PageRouteBuilder<void> {
  SettingsPageRouteBuilder()
      : super(
          transitionDuration:
              Dimens.durationM + Dimens.durationM, // wait for `MeteringScreenAnimatedSurface`s to expand
          reverseTransitionDuration: Dimens.durationM,
          pageBuilder: (context, animation, secondaryAnimation) => const SettingsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final didPop = !(animation.value != 0.0 && secondaryAnimation.value == 0.0);
            final tween = Tween(begin: 0.0, end: 1.0);
            late Interval interval;
            if (didPop) {
              interval = const Interval(
                0,
                1.0,
                curve: Curves.linear,
              );
            } else {
              interval = Interval(
                Dimens.durationM.inMilliseconds / (Dimens.durationM + Dimens.durationM).inMilliseconds,
                1.0,
                curve: Curves.linear,
              );
            }

            final animatable = tween.chain(CurveTween(curve: interval));
            return Opacity(
              opacity: (didPop ? secondaryAnimation : animation).drive(animatable).value,
              child: child,
            );
          },
        );
}
