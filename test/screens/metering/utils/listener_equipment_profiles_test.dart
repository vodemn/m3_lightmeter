import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/screens/metering/utils/listener_equipment_profiles.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';

import '../../../function_mock.dart';

class _MockEquipmentProfilesStorageService extends Mock implements EquipmentProfilesStorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final storageService = _MockEquipmentProfilesStorageService();
  final onDidChangeDependencies = MockValueChanged<EquipmentProfile>();

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
    when(() => storageService.getProfiles()).thenAnswer((_) => Future.value(_customProfiles.toSelectableMap()));
  });

  tearDown(() {
    reset(onDidChangeDependencies);
    reset(storageService);
  });

  Future<void> pumpTestWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      IAPProducts(
        products: [
          IAPProduct(
            storeId: IAPProductType.paidFeatures.storeId,
            status: IAPProductStatus.purchased,
            price: '0.0\$',
          ),
        ],
        child: EquipmentProfilesProvider(
          storageService: storageService,
          child: MaterialApp(
            home: EquipmentProfileListener(
              onDidChangeDependencies: onDidChangeDependencies.onChanged,
              child: Builder(builder: (context) => Text(EquipmentProfiles.selectedOf(context).name)),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'Trigger `onDidChangeDependencies` by selecting a new profile',
    (tester) async {
      when(() => storageService.selectedEquipmentProfileId).thenReturn('');
      await pumpTestWidget(tester);

      tester.equipmentProfilesProvider.selectProfile(_customProfiles[0]);
      await tester.pump();
      verify(() => onDidChangeDependencies.onChanged(_customProfiles[0])).called(1);
    },
  );

  testWidgets(
    'Trigger `onDidChangeDependencies` by updating the selected profile',
    (tester) async {
      when(() => storageService.selectedEquipmentProfileId).thenReturn(_customProfiles[0].id);
      await pumpTestWidget(tester);

      final updatedProfile1 = _customProfiles[0].copyWith(name: 'Test 1 updated');
      await tester.equipmentProfilesProvider.updateProfile(updatedProfile1);
      await tester.pump();
      verify(() => onDidChangeDependencies.onChanged(updatedProfile1)).called(1);

      /// Verify that updating the not selected profile doesn't trigger the callback
      final updatedProfile2 = _customProfiles[1].copyWith(name: 'Test 2 updated');
      await tester.equipmentProfilesProvider.updateProfile(updatedProfile2);
      await tester.pump();
      verifyNever(() => onDidChangeDependencies.onChanged(updatedProfile2));
    },
  );

  testWidgets(
    "Don't trigger `onDidChangeDependencies` by updating the unselected profile",
    (tester) async {
      when(() => storageService.selectedEquipmentProfileId).thenReturn(_customProfiles[0].id);
      await pumpTestWidget(tester);

      final updatedProfile2 = _customProfiles[1].copyWith(name: 'Test 2 updated');
      await tester.equipmentProfilesProvider.updateProfile(updatedProfile2);
      await tester.pump();
      verifyNever(() => onDidChangeDependencies.onChanged(updatedProfile2));
    },
  );
}

extension on WidgetTester {
  EquipmentProfilesProviderState get equipmentProfilesProvider {
    final BuildContext context = element(find.byType(MaterialApp));
    return EquipmentProfilesProvider.of(context);
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
    apertureValues: ApertureValue.values,
    ndValues: NdValue.values,
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: IsoValue.values,
  ),
];
