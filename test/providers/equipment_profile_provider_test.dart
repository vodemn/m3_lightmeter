import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';

import '../../integration_test/mocks/paid_features_mock.dart';

class _MockEquipmentProfilesStorageService extends Mock implements EquipmentProfilesStorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _MockEquipmentProfilesStorageService storageService;

  setUpAll(() {
    storageService = _MockEquipmentProfilesStorageService();
  });

  setUp(() {
    registerFallbackValue(_customProfiles.first);
    when(() => storageService.addProfile(any<EquipmentProfile>())).thenAnswer((_) async {});
    when(
      () => storageService.updateProfile(
        id: any<String>(named: 'id'),
        name: any<String>(named: 'name'),
      ),
    ).thenAnswer((_) async {});
    when(() => storageService.deleteProfile(any<String>())).thenAnswer((_) async {});
    when(() => storageService.getProfiles()).thenAnswer((_) => Future.value(_customProfiles.toProfilesMap()));
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
        child: EquipmentProfilesProvider(
          storageService: storageService,
          child: const _Application(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  void expectEquipmentProfilesCount(int count) {
    expect(find.text(_EquipmentProfilesCount.text(count)), findsOneWidget);
  }

  void expectSelectedEquipmentProfileName(String name) {
    expect(find.text(_SelectedEquipmentProfile.text(name)), findsOneWidget);
  }

  group(
    'EquipmentProfilesProvider dependency on IAPProductStatus',
    () {
      setUp(() {
        when(() => storageService.selectedEquipmentProfileId).thenReturn(_customProfiles.first.id);
        when(() => storageService.getProfiles()).thenAnswer((_) => Future.value(_customProfiles.toProfilesMap()));
      });

      testWidgets(
        'IAPProductStatus.purchased - show all saved profiles',
        (tester) async {
          await pumpTestWidget(tester, IAPProductStatus.purchased);
          expectEquipmentProfilesCount(_customProfiles.length + 1);
          expectSelectedEquipmentProfileName(_customProfiles.first.name);
        },
      );

      testWidgets(
        'IAPProductStatus.purchasable - show only default',
        (tester) async {
          await pumpTestWidget(tester, IAPProductStatus.purchasable);
          expectEquipmentProfilesCount(1);
          expectSelectedEquipmentProfileName('');
        },
      );

      testWidgets(
        'IAPProductStatus.pending - show only default',
        (tester) async {
          await pumpTestWidget(tester, IAPProductStatus.pending);
          expectEquipmentProfilesCount(1);
          expectSelectedEquipmentProfileName('');
        },
      );
    },
  );

  testWidgets(
    'EquipmentProfilesProvider CRUD',
    (tester) async {
      when(() => storageService.getProfiles()).thenAnswer((_) async => {});
      when(() => storageService.selectedEquipmentProfileId).thenReturn('');

      await pumpTestWidget(tester, IAPProductStatus.purchased);
      expectEquipmentProfilesCount(1);
      expectSelectedEquipmentProfileName('');

      /// Add first profile and verify
      await tester.equipmentProfilesProvider.addProfile(_customProfiles.first);
      await tester.pump();
      expectEquipmentProfilesCount(2);
      expectSelectedEquipmentProfileName('');
      verify(() => storageService.addProfile(any<EquipmentProfile>())).called(1);

      /// Add the other profiles and select the 1st one
      for (final profile in _customProfiles.skip(1)) {
        await tester.equipmentProfilesProvider.addProfile(profile);
      }
      tester.equipmentProfilesProvider.selectProfile(_customProfiles.first);
      await tester.pump();
      expectEquipmentProfilesCount(1 + _customProfiles.length);
      expectSelectedEquipmentProfileName(_customProfiles.first.name);

      /// Edit the selected profile
      final updatedName = "${_customProfiles.first} updated";
      await tester.equipmentProfilesProvider.updateProfile(_customProfiles.first.copyWith(name: updatedName));
      await tester.pump();
      expectEquipmentProfilesCount(1 + _customProfiles.length);
      expectSelectedEquipmentProfileName(updatedName);
      verify(() => storageService.updateProfile(id: _customProfiles.first.id, name: updatedName)).called(1);

      /// Delete a non-selected profile
      await tester.equipmentProfilesProvider.deleteProfile(_customProfiles.last);
      await tester.pump();
      expectEquipmentProfilesCount(1 + _customProfiles.length - 1);
      expectSelectedEquipmentProfileName(updatedName);
      verifyNever(() => storageService.selectedEquipmentProfileId = '');
      verify(() => storageService.deleteProfile(_customProfiles.last.id)).called(1);

      /// Delete the selected profile
      await tester.equipmentProfilesProvider.deleteProfile(_customProfiles.first);
      await tester.pump();
      expectEquipmentProfilesCount(1 + _customProfiles.length - 2);
      expectSelectedEquipmentProfileName('');
      verify(() => storageService.selectedEquipmentProfileId = '').called(1);
      verify(() => storageService.deleteProfile(_customProfiles.first.id)).called(1);
    },
  );
}

extension on WidgetTester {
  EquipmentProfilesProviderState get equipmentProfilesProvider {
    final BuildContext context = element(find.byType(_Application));
    return EquipmentProfilesProvider.of(context);
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
              _EquipmentProfilesCount(),
              _SelectedEquipmentProfile(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EquipmentProfilesCount extends StatelessWidget {
  static String text(int count) => "Profiles count: $count";

  const _EquipmentProfilesCount();

  @override
  Widget build(BuildContext context) {
    return Text(text(EquipmentProfiles.of(context).length));
  }
}

class _SelectedEquipmentProfile extends StatelessWidget {
  static String text(String name) => "Selected profile: $name}";

  const _SelectedEquipmentProfile();

  @override
  Widget build(BuildContext context) {
    return Text(text(EquipmentProfiles.selectedOf(context).name));
  }
}

final List<EquipmentProfile> _customProfiles = [
  const EquipmentProfile(
    id: '1',
    name: 'Test 1',
    apertureValues: [
      ApertureValue(4.0, StopType.full),
      ApertureValue(4.5, StopType.third),
      ApertureValue(4.8, StopType.half),
      ApertureValue(5.0, StopType.third),
      ApertureValue(5.6, StopType.full),
      ApertureValue(6.3, StopType.third),
      ApertureValue(6.7, StopType.half),
      ApertureValue(7.1, StopType.third),
      ApertureValue(8, StopType.full),
    ],
    ndValues: [
      NdValue(0),
      NdValue(2),
      NdValue(4),
      NdValue(8),
      NdValue(16),
      NdValue(32),
      NdValue(64),
    ],
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: [
      IsoValue(100, StopType.full),
      IsoValue(125, StopType.third),
      IsoValue(160, StopType.third),
      IsoValue(200, StopType.full),
      IsoValue(250, StopType.third),
      IsoValue(320, StopType.third),
      IsoValue(400, StopType.full),
    ],
  ),
  const EquipmentProfile(
    id: '2',
    name: 'Test 2',
    apertureValues: [
      ApertureValue(4.0, StopType.full),
      ApertureValue(4.5, StopType.third),
      ApertureValue(4.8, StopType.half),
      ApertureValue(5.0, StopType.third),
      ApertureValue(5.6, StopType.full),
      ApertureValue(6.3, StopType.third),
      ApertureValue(6.7, StopType.half),
      ApertureValue(7.1, StopType.third),
      ApertureValue(8, StopType.full),
    ],
    ndValues: [
      NdValue(0),
      NdValue(2),
      NdValue(4),
      NdValue(8),
      NdValue(16),
      NdValue(32),
      NdValue(64),
    ],
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: [
      IsoValue(100, StopType.full),
      IsoValue(125, StopType.third),
      IsoValue(160, StopType.third),
      IsoValue(200, StopType.full),
      IsoValue(250, StopType.third),
      IsoValue(320, StopType.third),
      IsoValue(400, StopType.full),
    ],
  ),
];
