import 'package:flutter/material.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';

class _MockIAPStorageService extends Mock implements IAPStorageService {}

class MockIAPProviders extends StatefulWidget {
  final String selectedEquipmentProfileId;
  final Film selectedFilm;
  final Widget child;

  const MockIAPProviders({
    this.selectedEquipmentProfileId = '',
    this.selectedFilm = const Film.other(),
    required this.child,
    super.key,
  });

  @override
  State<MockIAPProviders> createState() => _MockIAPProvidersState();
}

class _MockIAPProvidersState extends State<MockIAPProviders> {
  late final _MockIAPStorageService mockIAPStorageService;

  @override
  void initState() {
    super.initState();
    mockIAPStorageService = _MockIAPStorageService();
    when(() => mockIAPStorageService.equipmentProfiles).thenReturn(mockEquipmentProfiles);
    when(() => mockIAPStorageService.selectedEquipmentProfileId).thenReturn(widget.selectedEquipmentProfileId);
    when(() => mockIAPStorageService.filmsInUse).thenReturn(mockFilms);
    when(() => mockIAPStorageService.selectedFilm).thenReturn(widget.selectedFilm);
  }

  @override
  Widget build(BuildContext context) {
    return EquipmentProfileProvider(
      storageService: mockIAPStorageService,
      child: FilmsProvider(
        storageService: mockIAPStorageService,
        availableFilms: mockFilms,
        child: widget.child,
      ),
    );
  }
}

const defaultEquipmentProfile = EquipmentProfile(
  id: '',
  name: '',
  apertureValues: ApertureValue.values,
  ndValues: NdValue.values,
  shutterSpeedValues: ShutterSpeedValue.values,
  isoValues: IsoValue.values,
);

final mockEquipmentProfiles = [
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

const mockFilms = [_MockFilm(400, 2), _MockFilm(3, 800), _MockFilm(400, 1.5)];

class _MockFilm extends Film {
  final double reciprocityMultiplier;

  const _MockFilm(int iso, this.reciprocityMultiplier) : super('Mock film $iso x$reciprocityMultiplier', iso);

  @override
  double reciprocityFormula(double t) => t * reciprocityMultiplier;
}
