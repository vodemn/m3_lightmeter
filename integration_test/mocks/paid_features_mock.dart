import 'package:flutter/material.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockSharedPreferences extends Mock implements SharedPreferences {}

class MockIAPProviders extends StatelessWidget {
  final IAPProductStatus purchaseStatus;
  final Widget child;

  const MockIAPProviders({
    required this.purchaseStatus,
    required this.child,
    super.key,
  });

  const MockIAPProviders.purchasable({
    required this.child,
    super.key,
  }) : purchaseStatus = IAPProductStatus.purchasable;

  const MockIAPProviders.purchased({
    required this.child,
    super.key,
  }) : purchaseStatus = IAPProductStatus.purchased;

  @override
  Widget build(BuildContext context) {
    if (purchaseStatus == IAPProductStatus.purchased) {
      return IAPProviders(
        sharedPreferences: _MockSharedPreferences(),
        child: EquipmentProfiles(
          selected: _mockEquipmentProfiles[0],
          values: _mockEquipmentProfiles,
          child: Films(
            selected: const Film('Ilford HP5+', 400),
            values: const [Film.other(), Film('Ilford HP5+', 400)],
            filmsInUse: const [Film.other(), Film('Ilford HP5+', 400)],
            child: child,
          ),
        ),
      );
    }
    return IAPProviders(
      sharedPreferences: _MockSharedPreferences(),
      child: EquipmentProfiles(
        selected: _defaultEquipmentProfile,
        values: const [_defaultEquipmentProfile],
        child: Films(
          selected: const Film.other(),
          values: const [Film.other()],
          filmsInUse: const [Film.other()],
          child: child,
        ),
      ),
    );
  }
}

const _defaultEquipmentProfile = EquipmentProfile(
  id: '',
  name: '',
  apertureValues: ApertureValue.values,
  ndValues: NdValue.values,
  shutterSpeedValues: ShutterSpeedValue.values,
  isoValues: IsoValue.values,
);

final _mockEquipmentProfiles = [
  _defaultEquipmentProfile,
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
      ShutterSpeedValue.values.indexOf(const ShutterSpeedValue(16, false, StopType.full)) + 1,
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
