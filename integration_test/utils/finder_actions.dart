import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/widget_bottom_controls.dart';
import 'package:lightmeter/screens/shared/animated_circular_button/widget_button_circular_animated.dart';

extension CommonFindersExtension on CommonFinders {
  Finder measureButton() => find.descendant(
        of: find.byType(MeteringBottomControls),
        matching: find.byType(AnimatedCircluarButton),
      );
}
