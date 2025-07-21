import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';

class _MockFilmsStorageService extends Mock implements IapStorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _MockFilmsStorageService storageService;

  setUpAll(() {
    storageService = _MockFilmsStorageService();
  });

  setUp(() {
    registerFallbackValue(mockCustomFilms.first);
    when(() => storageService.toggleFilm(any<Film>(), any<bool>())).thenAnswer((_) async {});
    // ignore: avoid_redundant_argument_values
    when(() => storageService.addFilm(any<FilmExponential>(), isUsed: true)).thenAnswer((_) async {});
    when(() => storageService.updateFilm(any<FilmExponential>())).thenAnswer((_) async {});
    when(() => storageService.deleteFilm(any<FilmExponential>())).thenAnswer((_) async {});
    when(() => storageService.getPredefinedFilms()).thenAnswer((_) => Future.value(mockPredefinedFilms.toFilmsMap()));
    when(() => storageService.getCustomFilms()).thenAnswer((_) => Future.value(mockCustomFilms.toFilmsMap()));
  });

  tearDown(() {
    reset(storageService);
  });

  Future<void> pumpTestWidget(WidgetTester tester, IAPProductStatus productStatus) async {
    await tester.pumpWidget(
      IAPProducts(
        products: [
          IAPProduct(
            storeId: IAPProductType.paidFeatures.storeId,
            status: productStatus,
            price: '0.0\$',
          ),
        ],
        child: FilmsProvider(
          storageService: storageService,
          child: const _Application(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  void expectPredefinedFilmsCount(int count) {
    expect(find.text(_PredefinedFilmsCount.text(count)), findsOneWidget);
  }

  void expectCustomFilmsCount(int count) {
    expect(find.text(_CustomFilmsCount.text(count)), findsOneWidget);
  }

  void expectFilmsInUseCount(int count) {
    expect(find.text(_FilmsInUseCount.text(count)), findsOneWidget);
  }

  void expectSelectedFilmName(String name) {
    expect(find.text(_SelectedFilm.text(name)), findsOneWidget);
  }

  group(
    'FilmsProvider dependency on IAPProductStatus',
    () {
      setUp(() {
        when(() => storageService.selectedFilmId).thenReturn(mockPredefinedFilms.first.id);
        when(() => storageService.getPredefinedFilms())
            .thenAnswer((_) => Future.value(mockPredefinedFilms.toFilmsMap()));
        when(() => storageService.getCustomFilms()).thenAnswer((_) => Future.value(mockCustomFilms.toFilmsMap()));
      });

      testWidgets(
        'IAPProductStatus.purchased - show all saved films',
        (tester) async {
          await pumpTestWidget(tester, IAPProductStatus.purchased);
          expectPredefinedFilmsCount(mockPredefinedFilms.length);
          expectCustomFilmsCount(mockCustomFilms.length);
          expectFilmsInUseCount(mockPredefinedFilms.length + mockCustomFilms.length + 1);
          expectSelectedFilmName(mockPredefinedFilms.first.name);
        },
      );

      testWidgets(
        'IAPProductStatus.purchasable - show only default',
        (tester) async {
          await pumpTestWidget(tester, IAPProductStatus.purchasable);
          expectPredefinedFilmsCount(0);
          expectCustomFilmsCount(0);
          expectFilmsInUseCount(1);
          expectSelectedFilmName('');
        },
      );

      testWidgets(
        'IAPProductStatus.pending - show only default',
        (tester) async {
          await pumpTestWidget(tester, IAPProductStatus.pending);
          expectPredefinedFilmsCount(0);
          expectCustomFilmsCount(0);
          expectFilmsInUseCount(1);
          expectSelectedFilmName('');
        },
      );
    },
  );

  group(
    'toggleFilm',
    () {
      testWidgets(
        'toggle predefined film',
        (tester) async {
          when(() => storageService.selectedFilmId).thenReturn(mockPredefinedFilms.first.id);
          await pumpTestWidget(tester, IAPProductStatus.purchased);
          expectPredefinedFilmsCount(mockPredefinedFilms.length);
          expectCustomFilmsCount(mockCustomFilms.length);
          expectFilmsInUseCount(mockPredefinedFilms.length + mockCustomFilms.length + 1);
          expectSelectedFilmName(mockPredefinedFilms.first.name);

          await tester.filmsProvider.toggleFilm(mockPredefinedFilms.first, false);
          await tester.pump();
          expectPredefinedFilmsCount(mockPredefinedFilms.length);
          expectCustomFilmsCount(mockCustomFilms.length);
          expectFilmsInUseCount(mockPredefinedFilms.length - 1 + mockCustomFilms.length + 1);
          expectSelectedFilmName('');

          verify(() => storageService.toggleFilm(mockPredefinedFilms.first, false)).called(1);
          verify(() => storageService.selectedFilmId = '').called(1);
        },
      );

      testWidgets(
        'toggle custom film',
        (tester) async {
          when(() => storageService.selectedFilmId).thenReturn(mockCustomFilms.first.id);
          await pumpTestWidget(tester, IAPProductStatus.purchased);
          expectPredefinedFilmsCount(mockPredefinedFilms.length);
          expectCustomFilmsCount(mockCustomFilms.length);
          expectFilmsInUseCount(mockPredefinedFilms.length + mockCustomFilms.length + 1);
          expectSelectedFilmName(mockCustomFilms.first.name);

          await tester.filmsProvider.toggleFilm(mockCustomFilms.first, false);
          await tester.pump();
          expectPredefinedFilmsCount(mockPredefinedFilms.length);
          expectCustomFilmsCount(mockCustomFilms.length);
          expectFilmsInUseCount(mockPredefinedFilms.length - 1 + mockCustomFilms.length + 1);
          expectSelectedFilmName('');

          verify(() => storageService.toggleFilm(mockCustomFilms.first, false)).called(1);
          verify(() => storageService.selectedFilmId = '').called(1);
        },
      );
    },
  );

  testWidgets(
    'selectFilm',
    (tester) async {
      when(() => storageService.selectedFilmId).thenReturn('');
      await pumpTestWidget(tester, IAPProductStatus.purchased);
      expectSelectedFilmName('');

      tester.filmsProvider.selectFilm(mockPredefinedFilms.first);
      await tester.pump();
      expectSelectedFilmName(mockPredefinedFilms.first.name);

      tester.filmsProvider.selectFilm(mockCustomFilms.first);
      await tester.pump();
      expectSelectedFilmName(mockCustomFilms.first.name);

      verify(() => storageService.selectedFilmId = mockPredefinedFilms.first.id).called(1);
      verify(() => storageService.selectedFilmId = mockCustomFilms.first.id).called(1);
    },
  );

  testWidgets(
    'Custom film CRUD',
    (tester) async {
      when(() => storageService.selectedFilmId).thenReturn('');
      when(() => storageService.getCustomFilms()).thenAnswer((_) => Future.value({}));
      await pumpTestWidget(tester, IAPProductStatus.purchased);
      expectPredefinedFilmsCount(mockPredefinedFilms.length);
      expectCustomFilmsCount(0);
      expectFilmsInUseCount(mockPredefinedFilms.length + 0 + 1);
      expectSelectedFilmName('');

      await tester.filmsProvider.addCustomFilm(mockCustomFilms.first);
      await tester.filmsProvider.toggleFilm(mockCustomFilms.first, true);
      tester.filmsProvider.selectFilm(mockCustomFilms.first);
      await tester.pump();
      expectPredefinedFilmsCount(mockPredefinedFilms.length);
      expectCustomFilmsCount(1);
      expectFilmsInUseCount(mockPredefinedFilms.length + 1 + 1);
      expectSelectedFilmName(mockCustomFilms.first.name);
      verify(() => storageService.addFilm(mockCustomFilms.first)).called(1);
      verify(() => storageService.toggleFilm(mockCustomFilms.first, true)).called(1);
      verify(() => storageService.selectedFilmId = mockCustomFilms.first.id).called(1);

      const editedFilmName = 'Edited custom film 2x';
      final editedFilm = mockCustomFilms.first.copyWith(name: editedFilmName);
      await tester.filmsProvider.updateCustomFilm(editedFilm);
      await tester.pump();
      expectSelectedFilmName(editedFilm.name);
      verify(() => storageService.updateFilm(editedFilm)).called(1);

      await tester.filmsProvider.deleteCustomFilm(editedFilm);
      await tester.pump();
      expectPredefinedFilmsCount(mockPredefinedFilms.length);
      expectCustomFilmsCount(0);
      expectFilmsInUseCount(mockPredefinedFilms.length + 0 + 1);
      expectSelectedFilmName('');
      verify(() => storageService.deleteFilm(editedFilm)).called(1);
      verify(() => storageService.selectedFilmId = '').called(1);
    },
  );
}

extension on WidgetTester {
  FilmsProviderState get filmsProvider {
    final BuildContext context = element(find.byType(_Application));
    return FilmsProvider.of(context);
  }
}

class _Application extends StatelessWidget {
  const _Application();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              _PredefinedFilmsCount(),
              _CustomFilmsCount(),
              _FilmsInUseCount(),
              _SelectedFilm(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PredefinedFilmsCount extends StatelessWidget {
  static String text(int count) => "Predefined films count: $count";

  const _PredefinedFilmsCount();

  @override
  Widget build(BuildContext context) {
    return Text(text(Films.predefinedFilmsOf(context).length));
  }
}

class _CustomFilmsCount extends StatelessWidget {
  static String text(int count) => "Custom films count: $count";

  const _CustomFilmsCount();

  @override
  Widget build(BuildContext context) {
    return Text(text(Films.customFilmsOf(context).length));
  }
}

class _FilmsInUseCount extends StatelessWidget {
  static String text(int count) => "Films in use count: $count";

  const _FilmsInUseCount();

  @override
  Widget build(BuildContext context) {
    return Text(text(Films.inUseOf(context).length));
  }
}

class _SelectedFilm extends StatelessWidget {
  static String text(String name) => "Selected film: $name}";

  const _SelectedFilm();

  @override
  Widget build(BuildContext context) {
    return Text(text(Films.selectedOf(context).name));
  }
}

const mockPredefinedFilms = [
  FilmExponential(id: '1', name: 'Mock film 2x', iso: 400, exponent: 1.34),
  FilmExponential(id: '2', name: 'Mock film 3x', iso: 800, exponent: 1.34),
  FilmExponential(id: '3', name: 'Mock film 4x', iso: 1200, exponent: 1.34),
];

const mockCustomFilms = [
  FilmExponential(id: '1abc', name: 'Mock custom film 2x', iso: 400, exponent: 1.34),
  FilmExponential(id: '2abc', name: 'Mock custom film 3x', iso: 800, exponent: 1.34),
];

extension on List<Film> {
  Map<String, ({T value, bool isUsed})> toFilmsMap<T extends Film>() =>
      Map.fromEntries(map((e) => MapEntry(e.id, (value: e as T, isUsed: true))));
}
