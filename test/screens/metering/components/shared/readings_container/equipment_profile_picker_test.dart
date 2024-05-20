import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/equipment_profile_picker/widget_picker_equipment_profiles.dart';
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
    when(() => mockIAPStorageService.equipmentProfiles).thenReturn(_mockEquipmentProfiles);
    when(() => mockIAPStorageService.selectedEquipmentProfileId).thenReturn('');
  });

  Future<void> pumpApplication(WidgetTester tester) async {
    await tester.pumpWidget(
      IAPProducts(
        products: [
          IAPProduct(
            storeId: IAPProductType.paidFeatures.storeId,
            status: IAPProductStatus.purchased,
          ),
        ],
        child: EquipmentProfileProvider(
          storageService: mockIAPStorageService,
          child: const WidgetTestApplicationMock(
            child: Row(children: [Expanded(child: EquipmentProfilePicker())]),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Check dialog icon and title consistency',
    (tester) async {
      await pumpApplication(tester);
      expectReadingValueContainerText(S.current.equipmentProfile);
      await tester.openAnimatedPicker<EquipmentProfilePicker>();
      expect(find.byIcon(Icons.camera_outlined), findsOneWidget);
      expectDialogPickerText<EquipmentProfile>(S.current.equipmentProfile);
    },
  );

  group(
    'Display selected value',
    () {
      testWidgets(
        'None',
        (tester) async {
          when(() => mockIAPStorageService.selectedEquipmentProfileId).thenReturn('');
          await pumpApplication(tester);
          expectReadingValueContainerText(S.current.none);
          await tester.openAnimatedPicker<EquipmentProfilePicker>();
          expectRadioListTile<EquipmentProfile>(S.current.none, isSelected: true);
        },
      );

      testWidgets(
        'Praktica + Zenitar',
        (tester) async {
          when(() => mockIAPStorageService.selectedEquipmentProfileId).thenReturn(_mockEquipmentProfiles.first.id);
          await pumpApplication(tester);
          expectReadingValueContainerText(_mockEquipmentProfiles.first.name);
          await tester.openAnimatedPicker<EquipmentProfilePicker>();
          expectRadioListTile<EquipmentProfile>(_mockEquipmentProfiles.first.name, isSelected: true);
        },
      );
    },
  );
}

final _mockEquipmentProfiles = [
  EquipmentProfile(
    id: '1',
    name: 'Praktica + Zenitar',
    apertureValues: ApertureValue.values.sublist(
      ApertureValue.values.indexOf(const ApertureValue(1.7, StopType.half)),
      ApertureValue.values.indexOf(const ApertureValue(16, StopType.full)) + 1,
    ),
    ndValues: NdValue.values.sublist(0, 3),
    shutterSpeedValues: ShutterSpeedValue.values.sublist(
      ShutterSpeedValue.values.indexOf(const ShutterSpeedValue(1000, true, StopType.full)),
      ShutterSpeedValue.values.indexOf(const ShutterSpeedValue(1, false, StopType.full)) + 1,
    ),
    isoValues: const [
      IsoValue(50, StopType.full),
      IsoValue(100, StopType.full),
      IsoValue(200, StopType.full),
      IsoValue(250, StopType.third),
      IsoValue(400, StopType.full),
      IsoValue(500, StopType.third),
      IsoValue(800, StopType.full),
      IsoValue(1600, StopType.full),
      IsoValue(3200, StopType.full),
    ],
  ),
  const EquipmentProfile(
    id: '2',
    name: 'Praktica + Jupiter',
    apertureValues: ApertureValue.values,
    ndValues: NdValue.values,
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: IsoValue.values,
  ),
];
