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

class _MockFilmsStorageService extends Mock implements IapStorageService {}

void main() {
  late final _MockFilmsStorageService mockFilmsStorageService;

  setUpAll(() {
    mockFilmsStorageService = _MockFilmsStorageService();
    when(() => mockFilmsStorageService.getPredefinedFilms()).thenAnswer(
      (_) => Future.value(Map.fromEntries(_films.map((e) => MapEntry(e.id, (value: e, isUsed: true))))),
    );
    when(() => mockFilmsStorageService.getCustomFilms()).thenAnswer(
      (_) => Future.value({}),
    );
  });

  Future<void> pumpApplication(WidgetTester tester) async {
    await tester.pumpWidget(
      MockIapProducts(
        isPro: true,
        child: FilmsProvider(
          storageService: mockFilmsStorageService,
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
      'FilmStub()',
      (tester) async {
        when(() => mockFilmsStorageService.selectedFilmId).thenReturn(const FilmStub().id);
        await pumpApplication(tester);
        expectReadingValueContainerText(S.current.film);
        expectReadingValueContainerText(S.current.none);
      },
    );

    testWidgets(
      'Film with the same ISO',
      (tester) async {
        when(() => mockFilmsStorageService.selectedFilmId).thenReturn(_films[1].id);
        await pumpApplication(tester);
        expectReadingValueContainerText(S.current.film);
        expectReadingValueContainerText(_films[1].name);
      },
    );

    testWidgets(
      'Film with greater ISO',
      (tester) async {
        when(() => mockFilmsStorageService.selectedFilmId).thenReturn(_films[2].id);
        await pumpApplication(tester);
        expectReadingValueContainerText(S.current.filmPull);
        expectReadingValueContainerText(_films[2].name);
      },
    );

    testWidgets(
      'Film with lower ISO',
      (tester) async {
        when(() => mockFilmsStorageService.selectedFilmId).thenReturn(_films[0].id);
        await pumpApplication(tester);
        expectReadingValueContainerText(S.current.filmPush);
        expectReadingValueContainerText(_films[0].name);
      },
    );
  });

  testWidgets(
    'Film picker shows only films in use',
    (tester) async {
      when(() => mockFilmsStorageService.selectedFilmId).thenReturn(_films[0].id);
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
  FilmExponential(id: '1', name: 'ISO 100 Film', iso: 100, exponent: 1.34),
  FilmExponential(id: '2', name: 'ISO 400 Film', iso: 400, exponent: 1.34),
  FilmExponential(id: '3', name: 'ISO 800 Film', iso: 800, exponent: 1.34),
  FilmExponential(id: '4', name: 'ISO 1600 Film', iso: 1600, exponent: 1.34),
];
