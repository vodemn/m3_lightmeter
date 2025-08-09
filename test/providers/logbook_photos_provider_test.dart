import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/geolocation_service.dart';
import 'package:lightmeter/providers/logbook_photos_provider.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';

class _MockLogbookPhotosStorageService extends Mock implements IapStorageService {}

class _MockGeolocationService extends Mock implements GeolocationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _MockLogbookPhotosStorageService storageService;
  late _MockGeolocationService geolocationService;

  setUpAll(() {
    storageService = _MockLogbookPhotosStorageService();
    geolocationService = _MockGeolocationService();
    registerFallbackValue(ApertureValue.values.first);
    registerFallbackValue(_customPhotos.first);
    registerFallbackValue(ShutterSpeedValue.values.first);
  });

  setUp(() {
    when(() => storageService.addPhoto(any<LogbookPhoto>())).thenAnswer((_) async {});
    when(
      () => storageService.updatePhoto(
        id: any<String>(named: 'id'),
        note: any<String>(named: 'note'),
        apertureValue: any<Optional<ApertureValue>?>(named: 'apertureValue'),
        shutterSpeedValue: any<Optional<ShutterSpeedValue>?>(named: 'shutterSpeedValue'),
      ),
    ).thenAnswer((_) async {});
    when(() => storageService.deletePhoto(any<String>())).thenAnswer((_) async {});
    when(() => storageService.getPhotos()).thenAnswer((_) => Future.value(_customPhotos));

    when(() => geolocationService.getCurrentPosition()).thenAnswer((_) => Future.value());
  });

  tearDown(() {
    reset(storageService);
  });

  Future<void> pumpTestWidget(WidgetTester tester, bool isPro) async {
    await tester.pumpWidget(
      IAPProducts(
        isPro: isPro,
        child: LogbookPhotosProvider(
          storageService: storageService,
          geolocationService: geolocationService,
          child: const _Application(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  void expectLogbookPhotosCount(int count) {
    expect(find.text(_LogbookPhotosCount.text(count)), findsOneWidget);
  }

  void expectLogbookPhotosEnabled(bool enabled) {
    expect(find.text(_LogbookPhotosEnabled.text(enabled)), findsOneWidget);
  }

  group(
    'LogbookPhotosProvider dependency on IAPProductStatus',
    () {
      setUp(() {
        when(() => storageService.getPhotos()).thenAnswer((_) => Future.value(_customPhotos));
      });

      testWidgets(
        'Pro - show all saved photos',
        (tester) async {
          await pumpTestWidget(tester, true);
          expectLogbookPhotosCount(_customPhotos.length);
          expectLogbookPhotosEnabled(true);
        },
      );

      testWidgets(
        'Not Pro - show empty list',
        (tester) async {
          await pumpTestWidget(tester, false);
          expectLogbookPhotosCount(0);
          expectLogbookPhotosEnabled(true);
        },
      );
    },
  );

  testWidgets(
    'saveLogbookPhotos',
    (tester) async {
      when(() => storageService.getPhotos()).thenAnswer((_) => Future.value(_customPhotos));
      await pumpTestWidget(tester, true);
      expectLogbookPhotosCount(_customPhotos.length);
      expectLogbookPhotosEnabled(true);

      tester.logbookPhotosProvider.saveLogbookPhotos(false);
      await tester.pump();
      expectLogbookPhotosCount(_customPhotos.length);
      expectLogbookPhotosEnabled(false);

      tester.logbookPhotosProvider.saveLogbookPhotos(true);
      await tester.pump();
      expectLogbookPhotosCount(_customPhotos.length);
      expectLogbookPhotosEnabled(true);
    },
  );

  testWidgets(
    'LogbookPhotosProvider CRUD',
    (tester) async {
      when(() => storageService.getPhotos()).thenAnswer((_) async => []);

      await pumpTestWidget(tester, true);
      expectLogbookPhotosCount(0);
      expectLogbookPhotosEnabled(true);

      /// Create a photo
      final photo = await tester.logbookPhotosProvider.addPhotoIfPossible(
        _customPhotos.first.name,
        ev100: _customPhotos.first.ev,
        iso: _customPhotos.first.iso,
        nd: _customPhotos.first.nd,
      );

      /// Update a photo
      final updatedPhoto = photo!.copyWith(note: 'Updated note');
      await tester.logbookPhotosProvider.updateLogbookPhoto(updatedPhoto);
      await tester.pump();
      expectLogbookPhotosCount(1); // No photos loaded initially
      verify(
        () => storageService.updatePhoto(
          id: updatedPhoto.id,
          note: 'Updated note',
        ),
      ).called(1);

      /// Delete a photo
      await tester.logbookPhotosProvider.deleteLogbookPhoto(updatedPhoto);
      await tester.pump();
      expectLogbookPhotosCount(0);
      verify(() => storageService.deletePhoto(updatedPhoto.id)).called(1);
    },
  );

  testWidgets(
    'addPhotoIfPossible when disabled',
    (tester) async {
      when(() => storageService.getPhotos()).thenAnswer((_) async => []);
      await pumpTestWidget(tester, true);

      // Disable logbook photos
      tester.logbookPhotosProvider.saveLogbookPhotos(false);
      await tester.pump();

      // Try to add photo when disabled
      await tester.logbookPhotosProvider.addPhotoIfPossible(
        'assets/camera_stub_image.jpg',
        ev100: 12.0,
        iso: 100,
        nd: 0,
      );
      await tester.pump();

      // Should not add photo when disabled
      expectLogbookPhotosCount(0);
      verifyNever(() => storageService.addPhoto(any<LogbookPhoto>()));
    },
  );
}

extension on WidgetTester {
  LogbookPhotosProviderState get logbookPhotosProvider {
    final BuildContext context = element(find.byType(_Application));
    return LogbookPhotosProvider.of(context);
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
              _LogbookPhotosCount(),
              _LogbookPhotosEnabled(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogbookPhotosCount extends StatelessWidget {
  static String text(int count) => "Photos count: $count";

  const _LogbookPhotosCount();

  @override
  Widget build(BuildContext context) {
    return Text(text(LogbookPhotos.of(context).length));
  }
}

class _LogbookPhotosEnabled extends StatelessWidget {
  static String text(bool enabled) => "Photos enabled: $enabled";

  const _LogbookPhotosEnabled();

  @override
  Widget build(BuildContext context) {
    return Text(text(LogbookPhotos.isEnabledOf(context)));
  }
}

final List<LogbookPhoto> _customPhotos = [
  LogbookPhoto(
    id: '1',
    name: 'assets/camera_stub_image.jpg',
    timestamp: DateTime(2024, 1, 1, 12),
    ev: 12.0,
    iso: 100,
    nd: 0,
    note: 'Test photo 1',
  ),
  LogbookPhoto(
    id: '2',
    name: 'assets/camera_stub_image.jpg',
    timestamp: DateTime(2024, 1, 2, 12),
    ev: 13.0,
    iso: 200,
    nd: 1,
    note: 'Test photo 2',
  ),
];
