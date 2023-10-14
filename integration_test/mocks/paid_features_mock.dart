import 'package:flutter/material.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';

class _MockIAPStorageService extends Mock implements IAPStorageService {}

class MockIAPProviders extends StatefulWidget {
  final IAPProductStatus purchaseStatus;
  final String selectedEquipmentProfileId;
  final Film selectedFilm;
  final Widget child;

  const MockIAPProviders({
    this.selectedEquipmentProfileId = '',
    this.selectedFilm = const Film.other(),
    required this.purchaseStatus,
    required this.child,
    super.key,
  });

  const MockIAPProviders.purchasable({
    this.selectedEquipmentProfileId = '',
    this.selectedFilm = const Film.other(),
    required this.child,
    super.key,
  }) : purchaseStatus = IAPProductStatus.purchasable;

  const MockIAPProviders.purchased({
    this.selectedEquipmentProfileId = '',
    this.selectedFilm = const Film.other(),
    required this.child,
    super.key,
  }) : purchaseStatus = IAPProductStatus.purchased;

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
    when(() => mockIAPStorageService.selectedEquipmentProfileId)
        .thenReturn(widget.selectedEquipmentProfileId);
    when(() => mockIAPStorageService.filmsInUse).thenReturn(mockFilms);
    when(() => mockIAPStorageService.selectedFilm).thenReturn(widget.selectedFilm);
  }

  @override
  Widget build(BuildContext context) {
    return IAPProductsProvider(
      child: IAPProducts(
        products: [
          IAPProduct(
            storeId: IAPProductType.paidFeatures.storeId,
            status: widget.purchaseStatus,
          )
        ],
        child: EquipmentProfileProvider(
          storageService: mockIAPStorageService,
          child: FilmsProvider(
            storageService: mockIAPStorageService,
            availableFilms: mockFilms,
            child: widget.child,
          ),
        ),
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

const mockFilms = [_MockFilm2x(), _MockFilm3x()];

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
