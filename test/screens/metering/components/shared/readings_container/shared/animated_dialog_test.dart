import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import '../../../../../../application_mock.dart';
import '../utils.dart';

void main() {
  group(
    'Open & close tests',
    () {
      testWidgets(
        'Open & close with select',
        (tester) async {
          await tester.pumpApplication();
          await tester.openAnimatedPicker<IsoValuePicker>();
          expect(find.byType(DialogPicker<IsoValue>), findsOneWidget);
          await tester.tapSelectButton();
          expect(find.byType(DialogPicker<IsoValue>), findsNothing);
        },
      );

      testWidgets(
        'Open & close with cancel',
        (tester) async {
          await tester.pumpApplication();
          await tester.openAnimatedPicker<IsoValuePicker>();
          expect(find.byType(DialogPicker<IsoValue>), findsOneWidget);
          await tester.tapCancelButton();
          expect(find.byType(DialogPicker<IsoValue>), findsNothing);
        },
      );

      testWidgets(
        'Open & close with tap outside',
        (tester) async {
          await tester.pumpApplication();
          await tester.openAnimatedPicker<IsoValuePicker>();
          expect(find.byType(DialogPicker<IsoValue>), findsOneWidget);

          /// tester taps the center of the found widget,
          /// which results in tap on the dialog instead of the underlying barrier
          /// therefore just tap at offset outside the dialog
          await tester.longPressAt(const Offset(16, 16));
          await tester.pumpAndSettle(Dimens.durationML);
          expect(find.byType(DialogPicker<IsoValue>), findsNothing);
        },
      );

      testWidgets(
        'Open & close with back gesture',
        (tester) async {
          await tester.pumpApplication();
          await tester.openAnimatedPicker<IsoValuePicker>();
          expect(find.byType(DialogPicker<IsoValue>), findsOneWidget);

          //// https://github.com/flutter/flutter/blob/master/packages/flutter/test/widgets/router_test.dart#L970-L971
          //// final ByteData message = const JSONMethodCodec().encodeMethodCall(const MethodCall('popRoute'));
          //// await tester.binding.defaultBinaryMessenger.handlePlatformMessage('flutter/navigation', message, (_) {});
          /// https://github.com/flutter/packages/blob/main/packages/animations/test/open_container_test.dart#L234
          (tester.state(find.byType(Navigator)) as NavigatorState).pop();
          await tester.pumpAndSettle(Dimens.durationML);
          expect(find.byType(DialogPicker<IsoValue>), findsNothing);
        },
      );
    },
  );
}

extension WidgetTesterActions on WidgetTester {
  Future<void> pumpApplication() async {
    await pumpWidget(
      WidgetTestApplicationMock(
        child: Row(
          children: [
            Expanded(
              child: IsoValuePicker(
                selectedValue: const IsoValue(400, StopType.full),
                values: IsoValue.values,
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ),
    );
    await pumpAndSettle();
  }

  Future<void> tapSelectButton() async {
    final cancelButton = find.byWidgetPredicate(
      (widget) => widget is TextButton && widget.child is Text && (widget.child as Text?)?.data == S.current.select,
    );
    expect(cancelButton, findsOneWidget);
    await tap(cancelButton);
    await pumpAndSettle(Dimens.durationML);
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.byWidgetPredicate(
      (widget) => widget is TextButton && widget.child is Text && (widget.child as Text?)?.data == S.current.cancel,
    );
    expect(cancelButton, findsOneWidget);
    await tap(cancelButton);
    await pumpAndSettle(Dimens.durationML);
  }
}
