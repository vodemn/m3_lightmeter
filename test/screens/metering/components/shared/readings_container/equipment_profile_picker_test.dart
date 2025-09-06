import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/equipment_profile_picker/widget_picker_equipment_profiles.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../application_mock.dart';
import 'utils.dart';

class _MockEquipmentProfilesStorageService extends Mock implements IapStorageService {}

void main() {
  late final _MockEquipmentProfilesStorageService storageService;

  setUpAll(() {
    storageService = _MockEquipmentProfilesStorageService();
    when(() => storageService.getEquipmentProfiles())
        .thenAnswer((_) async => _mockEquipmentProfiles.toList().toTogglableMap());
    when(() => storageService.getPinholeEquipmentProfiles())
        .thenAnswer((_) async => _mockPinholeEquipmentProfiles.toList().toTogglableMap());
    when(() => storageService.selectedEquipmentProfileId).thenReturn('');
  });

  Future<void> pumpApplication(WidgetTester tester) async {
    await tester.pumpWidget(
      IAPProducts(
        isPro: true,
        child: EquipmentProfilesProvider(
          storageService: storageService,
          child: WidgetTestApplicationMock(
            child: BlocProvider(
              create: (_) => MeteringCommunicationBloc(),
              child: const Row(children: [Expanded(child: EquipmentProfilePicker())]),
            ),
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
      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
      expectDialogPickerText<IEquipmentProfile>(S.current.equipmentProfile);
    },
  );

  group(
    'Display selected value',
    () {
      testWidgets(
        'None',
        (tester) async {
          when(() => storageService.selectedEquipmentProfileId).thenReturn('');
          await pumpApplication(tester);
          expectReadingValueContainerText(S.current.none);
          await tester.openAnimatedPicker<EquipmentProfilePicker>();
          expectRadioListTile<IEquipmentProfile>(S.current.none, isSelected: true);
        },
      );

      testWidgets(
        'Praktica + Zenitar',
        (tester) async {
          when(() => storageService.selectedEquipmentProfileId).thenReturn(_mockEquipmentProfiles.first.id);
          await pumpApplication(tester);
          expectReadingValueContainerText(_mockEquipmentProfiles.first.name);
          await tester.openAnimatedPicker<EquipmentProfilePicker>();
          expectRadioListTile<IEquipmentProfile>(_mockEquipmentProfiles.first.name, isSelected: true);
        },
      );

      testWidgets(
        'Pinhole Camera f/64',
        (tester) async {
          when(() => storageService.selectedEquipmentProfileId).thenReturn(_mockPinholeEquipmentProfiles.first.id);
          await pumpApplication(tester);
          expectReadingValueContainerText(_mockPinholeEquipmentProfiles.first.name);
          await tester.openAnimatedPicker<EquipmentProfilePicker>();
          expectRadioListTile<IEquipmentProfile>(_mockPinholeEquipmentProfiles.first.name, isSelected: true);
        },
      );
    },
  );

  testWidgets(
    'Equipment profile picker shows only profiles in use',
    (tester) async {
      when(() => storageService.getEquipmentProfiles())
          .thenAnswer((_) async => _mockEquipmentProfiles.skip(1).toList().toTogglableMap());
      when(() => storageService.getPinholeEquipmentProfiles())
          .thenAnswer((_) async => _mockPinholeEquipmentProfiles.skip(1).toList().toTogglableMap());
      await pumpApplication(tester);
      await tester.openAnimatedPicker<EquipmentProfilePicker>();
      expectRadioListTile<IEquipmentProfile>(S.current.none, isSelected: true);
      expectRadioListTile<IEquipmentProfile>(_mockEquipmentProfiles[1].name);
      expectRadioListTile<IEquipmentProfile>(_mockPinholeEquipmentProfiles[1].name);
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

final _mockPinholeEquipmentProfiles = [
  const PinholeEquipmentProfile(
    id: '3',
    name: 'Pinhole Camera f/64',
    aperture: 64.0,
    isoValues: [
      IsoValue(100, StopType.full),
      IsoValue(200, StopType.full),
      IsoValue(400, StopType.full),
      IsoValue(800, StopType.full),
    ],
    ndValues: [
      NdValue(0),
      NdValue(2),
      NdValue(4),
    ],
  ),
  const PinholeEquipmentProfile(
    id: '4',
    name: 'Pinhole Camera f/128',
    aperture: 128.0,
    isoValues: [
      IsoValue(50, StopType.full),
      IsoValue(100, StopType.full),
      IsoValue(200, StopType.full),
      IsoValue(400, StopType.full),
      IsoValue(800, StopType.full),
      IsoValue(1600, StopType.full),
    ],
    ndValues: [
      NdValue(0),
      NdValue(1),
      NdValue(2),
      NdValue(4),
      NdValue(8),
    ],
  ),
];
