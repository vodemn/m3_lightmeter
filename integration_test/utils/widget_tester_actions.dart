import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/application.dart';
import 'package:lightmeter/application_wrapper.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import '../mocks/paid_features_mock.dart';
import 'platform_channel_mock.dart';

extension WidgetTesterCommonActions on WidgetTester {
  Future<void> pumpApplication({
    IAPProductStatus productStatus = IAPProductStatus.purchased,
    String selectedEquipmentProfileId = '',
    Film selectedFilm = const Film.other(),
  }) async {
    await pumpWidget(
      IAPProducts(
        products: [
          IAPProduct(
            storeId: IAPProductType.paidFeatures.storeId,
            status: productStatus,
          ),
        ],
        child: ApplicationWrapper(
          const Environment.dev(),
          child: MockIAPProviders(
            selectedEquipmentProfileId: selectedEquipmentProfileId,
            selectedFilm: selectedFilm,
            child: const Application(),
          ),
        ),
      ),
    );
    await pumpAndSettle();
  }

  Future<void> takePhoto() async {
    await tap(find.byType(MeteringMeasureButton));
    await pump(const Duration(seconds: 2)); // wait for circular progress indicator
    await pump(const Duration(seconds: 1)); // wait for circular progress indicator
    await pumpAndSettle();
  }

  Future<void> toggleIncidentMetering(double ev) async {
    await tap(find.byType(MeteringMeasureButton));
    await sendMockIncidentEv(ev);
    await tap(find.byType(MeteringMeasureButton));
    await pumpAndSettle();
  }

  Future<void> openAnimatedPicker<T>() async {
    await tap(find.byType(T));
    await pumpAndSettle(Dimens.durationL);
  }
}

extension WidgetTesterListTileActions on WidgetTester {
  /// Useful for tapping a specific [ListTile] inside a specific screen or dialog
  Future<void> tapDescendantTextOf<T>(String text) async {
    await tap(find.descendant(of: find.byType(T), matching: find.text(text)));
    await pumpAndSettle();
  }
}

extension WidgetTesterTextButtonActions on WidgetTester {
  Future<void> tapSelectButton() => _tapTextButton(S.current.select);

  Future<void> tapCancelButton() => _tapTextButton(S.current.cancel);

  Future<void> tapSaveButton() => _tapTextButton(S.current.save);

  Future<void> _tapTextButton(String text) async {
    final button = find.byWidgetPredicate(
      (widget) => widget is TextButton && widget.child is Text && (widget.child as Text?)?.data == text,
    );
    expect(button, findsOneWidget);
    await tap(button);
    await pumpAndSettle();
  }
}
