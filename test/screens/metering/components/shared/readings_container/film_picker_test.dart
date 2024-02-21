import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/film_picker/widget_picker_film.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../application_mock.dart';
import 'utils.dart';

class _MockIAPStorageService extends Mock implements IAPStorageService {}

void main() {
  late final _MockIAPStorageService mockIAPStorageService;

  setUpAll(() {
    mockIAPStorageService = _MockIAPStorageService();
    when(() => mockIAPStorageService.filmsInUse).thenReturn(_films);
  });

  Future<void> pumpApplication(WidgetTester tester) async {
    await tester.pumpWidget(
      IAPProducts(
        products: [
          IAPProduct(
            storeId: IAPProductType.paidFeatures.storeId,
            status: IAPProductStatus.purchased,
          )
        ],
        child: FilmsProvider(
          storageService: mockIAPStorageService,
          child: const WidgetTestApplicationMock(
            child: Row(
              children: [
                Expanded(
                  child: FilmPicker(selectedIso: IsoValue(400, StopType.full)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Film push/pull label', () {
    testWidgets(
      'Film.other()',
      (tester) async {
        when(() => mockIAPStorageService.selectedFilm).thenReturn(const Film.other());
        await pumpApplication(tester);
        expectReadingValueContainerText(S.current.film);
        expectReadingValueContainerText(S.current.none);
      },
    );

    testWidgets(
      'Film with the same ISO',
      (tester) async {
        when(() => mockIAPStorageService.selectedFilm).thenReturn(_films[1]);
        await pumpApplication(tester);
        expectReadingValueContainerText(S.current.film);
        expectReadingValueContainerText(_films[1].name);
      },
    );

    testWidgets(
      'Film with greater ISO',
      (tester) async {
        when(() => mockIAPStorageService.selectedFilm).thenReturn(_films[2]);
        await pumpApplication(tester);
        expectReadingValueContainerText(S.current.filmPull);
        expectReadingValueContainerText(_films[2].name);
      },
    );

    testWidgets(
      'Film with lower ISO',
      (tester) async {
        when(() => mockIAPStorageService.selectedFilm).thenReturn(_films[0]);
        await pumpApplication(tester);
        expectReadingValueContainerText(S.current.filmPush);
        expectReadingValueContainerText(_films[0].name);
      },
    );
  });

  testWidgets(
    'Film picker shows only films in use',
    (tester) async {
      when(() => mockIAPStorageService.selectedFilm).thenReturn(_films[0]);
      await pumpApplication(tester);
      await tester.openAnimatedPicker<FilmPicker>();
      expectRadioListTile<Film>(S.current.none, isSelected: true);
      expectRadioListTile<Film>(_films[1].name);
      expectRadioListTile<Film>(_films[2].name);
      expectRadioListTile<Film>(_films[3].name);
    },
  );
}

const _films = [
  Film('ISO 100 Film', 100),
  Film('ISO 400 Film', 400),
  Film('ISO 800 Film', 800),
  Film('ISO 1600 Film', 1600),
];
