import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';

class _MockIAPStorageService extends Mock implements IAPStorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _MockIAPStorageService mockIAPStorageService;

  setUpAll(() {
    mockIAPStorageService = _MockIAPStorageService();
  });

  tearDown(() {
    reset(mockIAPStorageService);
  });

  Future<void> pumpTestWidget(WidgetTester tester, IAPProductStatus productStatus) async {
    await tester.pumpWidget(
      IAPProducts(
        products: [
          IAPProduct(
            storeId: IAPProductType.paidFeatures.storeId,
            status: productStatus,
          )
        ],
        child: FilmsProvider(
          storageService: mockIAPStorageService,
          availableFilms: mockFilms,
          child: const _Application(),
        ),
      ),
    );
  }

  void expectFilmsCount(int count) {
    expect(find.text('Films count: $count'), findsOneWidget);
  }

  void expectFilmsInUseCount(int count) {
    expect(find.text('Films in use count: $count'), findsOneWidget);
  }

  void expectSelectedFilmName(String name) {
    expect(find.text('Selected film: $name'), findsOneWidget);
  }

  group(
    'FilmsProvider dependency on IAPProductStatus',
    () {
      setUp(() {
        when(() => mockIAPStorageService.selectedFilm).thenReturn(mockFilms.first);
        when(() => mockIAPStorageService.filmsInUse).thenReturn(mockFilms);
      });

      testWidgets(
        'IAPProductStatus.purchased - show all saved films',
        (tester) async {
          await pumpTestWidget(tester, IAPProductStatus.purchased);
          expectFilmsCount(mockFilms.length + 1);
          expectFilmsInUseCount(mockFilms.length + 1);
          expectSelectedFilmName(mockFilms.first.name);
        },
      );

      testWidgets(
        'IAPProductStatus.purchasable - show only default',
        (tester) async {
          await pumpTestWidget(tester, IAPProductStatus.purchasable);
          expectFilmsCount(mockFilms.length + 1);
          expectFilmsInUseCount(1);
          expectSelectedFilmName('');
        },
      );

      testWidgets(
        'IAPProductStatus.pending - show only default',
        (tester) async {
          await pumpTestWidget(tester, IAPProductStatus.pending);
          expectFilmsCount(mockFilms.length + 1);
          expectFilmsInUseCount(1);
          expectSelectedFilmName('');
        },
      );
    },
  );

  group(
    'FilmsProvider CRUD',
    () {
      testWidgets(
        'Select films in use',
        (tester) async {
          when(() => mockIAPStorageService.selectedFilm).thenReturn(const Film.other());
          when(() => mockIAPStorageService.filmsInUse).thenReturn([]);

          /// Init
          await pumpTestWidget(tester, IAPProductStatus.purchased);
          expectFilmsCount(mockFilms.length + 1);
          expectFilmsInUseCount(1);
          expectSelectedFilmName('');

          /// Select all filmsInUse
          await tester.tap(find.byKey(_Application.saveFilmsButtonKey(0)));
          await tester.pumpAndSettle();
          expectFilmsCount(mockFilms.length + 1);
          expectFilmsInUseCount(mockFilms.length + 1);
          expectSelectedFilmName('');

          verify(() => mockIAPStorageService.filmsInUse = mockFilms.skip(0).toList()).called(1);
          verifyNever(() => mockIAPStorageService.selectedFilm = const Film.other());
        },
      );

      testWidgets(
        'Select film',
        (tester) async {
          when(() => mockIAPStorageService.selectedFilm).thenReturn(const Film.other());
          when(() => mockIAPStorageService.filmsInUse).thenReturn(mockFilms);

          /// Init
          await pumpTestWidget(tester, IAPProductStatus.purchased);
          expectFilmsCount(mockFilms.length + 1);
          expectFilmsInUseCount(mockFilms.length + 1);
          expectSelectedFilmName('');

          /// Select all filmsInUse
          await tester.tap(find.byKey(_Application.setFilmButtonKey(0)));
          await tester.pumpAndSettle();
          expectFilmsCount(mockFilms.length + 1);
          expectFilmsInUseCount(mockFilms.length + 1);
          expectSelectedFilmName(mockFilms.first.name);

          verifyNever(() => mockIAPStorageService.filmsInUse = any<List<Film>>());
          verify(() => mockIAPStorageService.selectedFilm = mockFilms.first).called(1);
        },
      );

      group(
        'Coming from free app',
        () {
          testWidgets(
            'Has selected film',
            (tester) async {
              when(() => mockIAPStorageService.selectedFilm).thenReturn(mockFilms[2]);
              when(() => mockIAPStorageService.filmsInUse).thenReturn([]);

              /// Init
              await pumpTestWidget(tester, IAPProductStatus.purchased);
              expectFilmsInUseCount(1);
              expectSelectedFilmName('');

              verifyNever(() => mockIAPStorageService.filmsInUse = any<List<Film>>());
              verify(() => mockIAPStorageService.selectedFilm = const Film.other()).called(1);
            },
          );

          testWidgets(
            'None film selected',
            (tester) async {
              when(() => mockIAPStorageService.selectedFilm).thenReturn(const Film.other());
              when(() => mockIAPStorageService.filmsInUse).thenReturn([]);

              /// Init
              await pumpTestWidget(tester, IAPProductStatus.purchased);
              expectFilmsInUseCount(1);
              expectSelectedFilmName('');

              verifyNever(() => mockIAPStorageService.filmsInUse = any<List<Film>>());
              verifyNever(() => mockIAPStorageService.selectedFilm = const Film.other());
            },
          );
        },
      );

      testWidgets(
        'Discard selected (by filmsInUse list update)',
        (tester) async {
          when(() => mockIAPStorageService.selectedFilm).thenReturn(mockFilms.first);
          when(() => mockIAPStorageService.filmsInUse).thenReturn(mockFilms);

          /// Init
          await pumpTestWidget(tester, IAPProductStatus.purchased);
          expectFilmsCount(mockFilms.length + 1);
          expectFilmsInUseCount(mockFilms.length + 1);
          expectSelectedFilmName(mockFilms.first.name);

          /// Select all filmsInUse except the first one
          await tester.tap(find.byKey(_Application.saveFilmsButtonKey(1)));
          await tester.pumpAndSettle();
          expectFilmsCount(mockFilms.length + 1);
          expectFilmsInUseCount((mockFilms.length - 1) + 1);
          expectSelectedFilmName('');

          verify(() => mockIAPStorageService.filmsInUse = mockFilms.skip(1).toList()).called(1);
          verify(() => mockIAPStorageService.selectedFilm = const Film.other()).called(1);
        },
      );
    },
  );
}

class _Application extends StatelessWidget {
  const _Application();

  static ValueKey saveFilmsButtonKey(int index) => ValueKey('saveFilmsButtonKey$index');
  static ValueKey setFilmButtonKey(int index) => ValueKey('setFilmButtonKey$index');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text("Films count: ${Films.of(context).length}"),
              Text("Films in use count: ${Films.inUseOf(context).length}"),
              Text("Selected film: ${Films.selectedOf(context).name}"),
              _filmRow(context, 0),
              _filmRow(context, 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filmRow(BuildContext context, int index) {
    return Row(
      children: [
        ElevatedButton(
          key: saveFilmsButtonKey(index),
          onPressed: () {
            FilmsProvider.of(context).saveFilms(mockFilms.skip(index).toList());
          },
          child: const Text("Save filmsInUse"),
        ),
        ElevatedButton(
          key: setFilmButtonKey(index),
          onPressed: () {
            FilmsProvider.of(context).setFilm(mockFilms[index]);
          },
          child: const Text("Set film"),
        ),
      ],
    );
  }
}

const mockFilms = [_MockFilm2x(), _MockFilm3x(), _MockFilm4x()];

class _MockFilm2x extends Film {
  const _MockFilm2x() : super('Mock film 2x', 400);

  @override
  double reciprocityFormula(double t) => t * 2;
}

class _MockFilm3x extends Film {
  const _MockFilm3x() : super('Mock film 3x', 800);

  @override
  double reciprocityFormula(double t) => t * 3;
}

class _MockFilm4x extends Film {
  const _MockFilm4x() : super('Mock film 4x', 1600);

  @override
  double reciprocityFormula(double t) => t * 4;
}
