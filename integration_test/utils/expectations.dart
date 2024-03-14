import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/components/exposure_pairs_list_item/widget_item_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/widget_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/extreme_exposure_pairs_container/widget_container_extreme_exposure_pairs.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

void expectPickerTitle<P extends Widget>(String title, {String? reason}) {
  expect(find.descendant(of: find.byType(P), matching: find.text(title)), findsOneWidget, reason: reason);
}

void expectExtremeExposurePairs(String fastest, String slowest, {String? reason}) {
  final pickerFinder = find.byType(ExtremeExposurePairsContainer);
  expect(find.descendant(of: pickerFinder, matching: find.text(fastest)), findsOneWidget, reason: reason);
  expect(find.descendant(of: pickerFinder, matching: find.text(slowest)), findsOneWidget, reason: reason);
}

void expectExposurePairsListItem(WidgetTester tester, String aperture, String shutterSpeed, {String? reason}) {
  Key? findKey<T extends PhotographyStopValue<num>>(String value) => tester
      .widget<Row>(
        find.ancestor(
          of: find.ancestor(
            of: find.text(value),
            matching: find.byType(ExposurePairsListItem<T>),
          ),
          matching: find.descendant(of: find.byType(ExposurePairsList), matching: find.byType(Row)),
        ),
      )
      .key;
  expect(
    findKey<ApertureValue>(aperture),
    findKey<ShutterSpeedValue>(shutterSpeed),
    reason: reason,
  );
}
