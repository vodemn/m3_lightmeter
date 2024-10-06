import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/extreme_exposure_pairs_container/widget_container_extreme_exposure_pairs.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import '../../../../../application_mock.dart';

void main() {
  testWidgets(
    'No exposure pairs',
    (tester) async {
      await tester.pumpApplication(
        fastest: null,
        slowest: null,
      );

      final pickerFinder = find.byType(ExtremeExposurePairsContainer);
      expect(pickerFinder, findsOneWidget);
      expect(find.descendant(of: pickerFinder, matching: find.text(S.current.fastestExposurePair)), findsOneWidget);
      expect(find.descendant(of: pickerFinder, matching: find.text(S.current.slowestExposurePair)), findsOneWidget);
      expect(find.descendant(of: pickerFinder, matching: find.text('-')), findsNWidgets(2));
    },
  );

  testWidgets(
    'Has pairs',
    (tester) async {
      await tester.pumpApplication(
        fastest: ExposurePair(ApertureValue.values.first, ShutterSpeedValue.values.first),
        slowest: ExposurePair(ApertureValue.values.last, ShutterSpeedValue.values.last),
      );

      final pickerFinder = find.byType(ExtremeExposurePairsContainer);
      expect(pickerFinder, findsOneWidget);
      expect(find.descendant(of: pickerFinder, matching: find.text(S.current.fastestExposurePair)), findsOneWidget);
      expect(find.descendant(of: pickerFinder, matching: find.text(S.current.slowestExposurePair)), findsOneWidget);
      expect(find.descendant(of: pickerFinder, matching: find.text('f/1.0 - 1/4000')), findsOneWidget);
      expect(find.descendant(of: pickerFinder, matching: find.text('f/45 - 1"')), findsOneWidget);
    },
  );
}

extension WidgetTesterActions on WidgetTester {
  Future<void> pumpApplication({
    required ExposurePair? fastest,
    required ExposurePair? slowest,
  }) async {
    await pumpWidget(
      Films(
        values: const [FilmStub()],
        filmsInUse: const [FilmStub()],
        selected: const FilmStub(),
        child: WidgetTestApplicationMock(
          child: Row(
            children: [
              Expanded(
                child: ExtremeExposurePairsContainer(
                  fastest: fastest,
                  slowest: slowest,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await pumpAndSettle();
  }
}
