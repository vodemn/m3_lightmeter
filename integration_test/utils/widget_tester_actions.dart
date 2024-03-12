import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/application.dart';
import 'package:lightmeter/application_wrapper.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/widget_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/screen_metering.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import '../mocks/iap_products_mock.dart';
import '../mocks/paid_features_mock.dart';
import 'platform_channel_mock.dart';

const mockPhotoEv100 = 8.3;

extension WidgetTesterCommonActions on WidgetTester {
  Future<void> pumpApplication({
    IAPProductStatus productStatus = IAPProductStatus.purchased,
    List<EquipmentProfile>? equipmentProfiles,
    String selectedEquipmentProfileId = '',
    List<Film>? films,
    Film selectedFilm = const Film.other(),
  }) async {
    await pumpWidget(
      MockIAPProductsProvider(
        initialyPurchased: productStatus == IAPProductStatus.purchased,
        child: ApplicationWrapper(
          const Environment.dev(),
          child: MockIAPProviders(
            equipmentProfiles: equipmentProfiles,
            selectedEquipmentProfileId: selectedEquipmentProfileId,
            films: films,
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

  Future<void> openSettings() async {
    await tap(find.byTooltip(S.current.tooltipOpenSettings));
    await pumpAndSettle();
  }

  Future<void> navigatorPop() async {
    (state(find.byType(Navigator)) as NavigatorState).pop();
    await pumpAndSettle(Dimens.durationML);
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

extension WidgetTesterExposurePairsListActions on WidgetTester {
  Future<void> scrollToTheLastExposurePair({
    double ev = mockPhotoEv100,
    StopType stopType = StopType.third,
    EquipmentProfile equipmentProfile = defaultEquipmentProfile,
  }) async {
    final exposurePairs = MeteringContainerBuidler.buildExposureValues(
      ev,
      StopType.third,
      equipmentProfile,
    );
    await scrollUntilVisible(
      find.byWidgetPredicate((widget) => widget is Row && widget.key == ValueKey(exposurePairs.length - 1)),
      56,
      scrollable: find.descendant(of: find.byType(ExposurePairsList), matching: find.byType(Scrollable)),
    );
  }
}
