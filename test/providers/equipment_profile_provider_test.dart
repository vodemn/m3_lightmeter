import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';

class _MockIAPStorageService extends Mock implements IAPStorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _MockIAPStorageService storageService;

  setUpAll(() {
    storageService = _MockIAPStorageService();
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
        child: EquipmentProfileProvider(
          storageService: storageService,
          child: const _Application(),
        ),
      ),
    );
  }

  void expectEquipmentProfilesCount(int count) {
    expect(find.text('Equipment profiles count: $count'), findsOneWidget);
  }

  void expectSelectedEquipmentProfileName(String name) {
    expect(find.text('Selected equipment profile: $name'), findsOneWidget);
  }

  group(
    'EquipmentProfileProvider dependency on IAPProductStatus',
    () {
      setUp(() {
        when(() => storageService.selectedEquipmentProfileId).thenReturn(_customProfiles.first.id);
        when(() => storageService.equipmentProfiles).thenReturn(_customProfiles);
      });

      testWidgets(
        'IAPProductStatus.purchased - show all saved profiles',
        (tester) async {
          await pumpTestWidget(tester, IAPProductStatus.purchased);
          expectEquipmentProfilesCount(3);
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

  group('EquipmentProfileProvider CRUD', () {
    testWidgets(
      'Add',
      (tester) async {
        when(() => storageService.equipmentProfiles).thenReturn([]);
        when(() => storageService.selectedEquipmentProfileId).thenReturn('');

        await pumpTestWidget(tester, IAPProductStatus.purchased);
        expectEquipmentProfilesCount(1);
        expectSelectedEquipmentProfileName('');

        await tester.tap(find.byKey(_Application.addProfileButtonKey));
        await tester.pump();
        expectEquipmentProfilesCount(2);
        expectSelectedEquipmentProfileName('');

        verifyNever(() => storageService.selectedEquipmentProfileId = '');
        verify(() => storageService.equipmentProfiles = any<List<EquipmentProfile>>()).called(1);
      },
    );

    testWidgets(
      'Add from',
      (tester) async {
        when(() => storageService.equipmentProfiles).thenReturn(List.from(_customProfiles));
        when(() => storageService.selectedEquipmentProfileId).thenReturn('');

        await pumpTestWidget(tester, IAPProductStatus.purchased);
        expectEquipmentProfilesCount(3);
        expectSelectedEquipmentProfileName('');

        await tester.tap(find.byKey(_Application.addFromProfileButtonKey(_customProfiles[0].id)));
        await tester.pump();
        expectEquipmentProfilesCount(4);
        expectSelectedEquipmentProfileName('');

        verifyNever(() => storageService.selectedEquipmentProfileId = '');
        verify(() => storageService.equipmentProfiles = any<List<EquipmentProfile>>()).called(1);
      },
    );

    testWidgets(
      'Edit selected',
      (tester) async {
        when(() => storageService.equipmentProfiles).thenReturn(List.from(_customProfiles));
        when(() => storageService.selectedEquipmentProfileId).thenReturn(_customProfiles[0].id);

        await pumpTestWidget(tester, IAPProductStatus.purchased);

        /// Change the name & limit ISO values of the both added profiles
        await tester.tap(find.byKey(_Application.updateProfileButtonKey(_customProfiles[0].id)));
        await tester.pumpAndSettle();
        expectEquipmentProfilesCount(3);
        expectSelectedEquipmentProfileName("${_customProfiles[0].name} updated");

        verifyNever(() => storageService.selectedEquipmentProfileId = _customProfiles[0].id);
        verify(() => storageService.equipmentProfiles = any<List<EquipmentProfile>>()).called(1);
      },
    );

    testWidgets(
      'Delete selected',
      (tester) async {
        when(() => storageService.equipmentProfiles).thenReturn(List.from(_customProfiles));
        when(() => storageService.selectedEquipmentProfileId).thenReturn(_customProfiles[0].id);

        await pumpTestWidget(tester, IAPProductStatus.purchased);
        expectEquipmentProfilesCount(3);
        expectSelectedEquipmentProfileName(_customProfiles[0].name);

        /// Delete the selected profile
        await tester.tap(find.byKey(_Application.deleteProfileButtonKey(_customProfiles[0].id)));
        await tester.pumpAndSettle();
        expectEquipmentProfilesCount(2);
        expectSelectedEquipmentProfileName('');

        verify(() => storageService.selectedEquipmentProfileId = '').called(1);
        verify(() => storageService.equipmentProfiles = any<List<EquipmentProfile>>()).called(1);
      },
    );

    testWidgets(
      'Delete not selected',
      (tester) async {
        when(() => storageService.equipmentProfiles).thenReturn(List.from(_customProfiles));
        when(() => storageService.selectedEquipmentProfileId).thenReturn(_customProfiles[0].id);

        await pumpTestWidget(tester, IAPProductStatus.purchased);
        expectEquipmentProfilesCount(3);
        expectSelectedEquipmentProfileName(_customProfiles[0].name);

        /// Delete the not selected profile
        await tester.tap(find.byKey(_Application.deleteProfileButtonKey(_customProfiles[1].id)));
        await tester.pumpAndSettle();
        expectEquipmentProfilesCount(2);
        expectSelectedEquipmentProfileName(_customProfiles[0].name);

        verifyNever(() => storageService.selectedEquipmentProfileId = '');
        verify(() => storageService.equipmentProfiles = any<List<EquipmentProfile>>()).called(1);
      },
    );

    testWidgets(
      'Select',
      (tester) async {
        when(() => storageService.equipmentProfiles).thenReturn(List.from(_customProfiles));
        when(() => storageService.selectedEquipmentProfileId).thenReturn('');

        await pumpTestWidget(tester, IAPProductStatus.purchased);
        expectEquipmentProfilesCount(3);
        expectSelectedEquipmentProfileName('');

        /// Select the 1st custom profile
        await tester.tap(find.byKey(_Application.setProfileButtonKey(_customProfiles[0].id)));
        await tester.pumpAndSettle();
        expectEquipmentProfilesCount(3);
        expectSelectedEquipmentProfileName(_customProfiles[0].name);

        verify(() => storageService.selectedEquipmentProfileId = _customProfiles[0].id).called(1);
        verifyNever(() => storageService.equipmentProfiles = any<List<EquipmentProfile>>());
      },
    );
  });
}

class _Application extends StatelessWidget {
  const _Application();

  static ValueKey get addProfileButtonKey => const ValueKey('addProfileButtonKey');
  static ValueKey addFromProfileButtonKey(String id) => ValueKey('addFromProfileButtonKey$id');
  static ValueKey setProfileButtonKey(String id) => ValueKey('setProfileButtonKey$id');
  static ValueKey updateProfileButtonKey(String id) => ValueKey('updateProfileButtonKey$id');
  static ValueKey deleteProfileButtonKey(String id) => ValueKey('deleteProfileButtonKey$id');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('IAPProviders test')),
        body: Center(
          child: Column(
            children: [
              Text("Equipment profiles count: ${EquipmentProfiles.of(context).length}"),
              Text("Selected equipment profile: ${EquipmentProfiles.selectedOf(context).name}"),
              ElevatedButton(
                key: addProfileButtonKey,
                onPressed: () {
                  EquipmentProfileProvider.of(context).addProfile('Test added');
                },
                child: const Text("Add"),
              ),
              ...EquipmentProfiles.of(context).map((e) => _equipmentProfilesCrudRow(context, e)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _equipmentProfilesCrudRow(BuildContext context, EquipmentProfile profile) {
    return Row(
      children: [
        ElevatedButton(
          key: setProfileButtonKey(profile.id),
          onPressed: () {
            EquipmentProfileProvider.of(context).setProfile(profile);
          },
          child: const Text("Set"),
        ),
        ElevatedButton(
          key: addFromProfileButtonKey(profile.id),
          onPressed: () {
            EquipmentProfileProvider.of(context).addProfile('Test from ${profile.name}', profile);
          },
          child: const Text("Add from"),
        ),
        ElevatedButton(
          key: updateProfileButtonKey(profile.id),
          onPressed: () {
            EquipmentProfileProvider.of(context).updateProfile(
              profile.copyWith(
                name: '${profile.name} updated',
                isoValues: _customProfiles.first.isoValues,
              ),
            );
          },
          child: const Text("Update"),
        ),
        ElevatedButton(
          key: deleteProfileButtonKey(profile.id),
          onPressed: () {
            EquipmentProfileProvider.of(context).deleteProfile(profile);
          },
          child: const Text("Delete"),
        ),
      ],
    );
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
