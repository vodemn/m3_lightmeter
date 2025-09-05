import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lightmeter/data/geolocation_service.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/providers/logbook_photos_provider.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';

class _MockIapStorageService extends Mock implements IapStorageService {}

class _MockGeolocationService extends Mock implements GeolocationService {}

class MockIAPProviders extends StatefulWidget {
  final TogglableMap<EquipmentProfile> equipmentProfiles;
  final TogglableMap<PinholeEquipmentProfile> pinholeEquipmentProfiles;
  final String selectedEquipmentProfileId;
  final TogglableMap<Film> predefinedFilms;
  final TogglableMap<FilmExponential> customFilms;
  final String selectedFilmId;
  final Widget child;

  MockIAPProviders({
    TogglableMap<EquipmentProfile>? equipmentProfiles,
    TogglableMap<PinholeEquipmentProfile>? pinholeEquipmentProfiles,
    this.selectedEquipmentProfileId = '',
    TogglableMap<Film>? predefinedFilms,
    TogglableMap<FilmExponential>? customFilms,
    String? selectedFilmId,
    required this.child,
    super.key,
  })  : equipmentProfiles = equipmentProfiles ?? mockEquipmentProfiles.toTogglableMap(),
        pinholeEquipmentProfiles = pinholeEquipmentProfiles ?? mockPinholeEquipmentProfiles.toTogglableMap(),
        predefinedFilms = predefinedFilms ?? mockFilms.toTogglableMap(),
        customFilms = customFilms ?? mockFilms.toTogglableMap(),
        selectedFilmId = selectedFilmId ?? const FilmStub().id;

  @override
  State<MockIAPProviders> createState() => _MockIAPProvidersState();
}

class _MockIAPProvidersState extends State<MockIAPProviders> {
  late final _MockIapStorageService mockIapStorageService;
  late final mockGeolocationService = _MockGeolocationService();

  @override
  void initState() {
    super.initState();
    registerFallbackValue(defaultEquipmentProfile);
    registerFallbackValue(mockPinholeEquipmentProfiles.first);
    registerFallbackValue(defaultCustomPhotos.first);
    registerFallbackValue(ApertureValue.values.first);
    registerFallbackValue(ShutterSpeedValue.values.first);
    mockIapStorageService = _MockIapStorageService();
    when(() => mockIapStorageService.init()).thenAnswer((_) async {});

    when(() => mockIapStorageService.selectedEquipmentProfileId).thenReturn(widget.selectedEquipmentProfileId);
    when(() => mockIapStorageService.getEquipmentProfiles()).thenAnswer((_) => Future.value(widget.equipmentProfiles));
    when(() => mockIapStorageService.getPinholeEquipmentProfiles())
        .thenAnswer((_) => Future.value(widget.pinholeEquipmentProfiles));
    when(() => mockIapStorageService.addEquipmentProfile(any<EquipmentProfile>())).thenAnswer((_) async {});
    when(() => mockIapStorageService.addPinholeEquipmentProfile(any<PinholeEquipmentProfile>()))
        .thenAnswer((_) async {});
    when(
      () => mockIapStorageService.updateEquipmentProfile(
        id: any<String>(named: 'id'),
        name: any<String>(named: 'name'),
        isUsed: any<bool>(named: 'isUsed'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockIapStorageService.updatePinholeEquipmentProfile(
        id: any<String>(named: 'id'),
        name: any<String>(named: 'name'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockIapStorageService.deleteEquipmentProfile(any<String>())).thenAnswer((_) async {});
    when(() => mockIapStorageService.deletePinholeEquipmentProfile(any<String>())).thenAnswer((_) async {});

    when(() => mockIapStorageService.getPredefinedFilms()).thenAnswer((_) => Future.value(widget.predefinedFilms));
    when(() => mockIapStorageService.getCustomFilms()).thenAnswer((_) => Future.value(widget.customFilms));
    when(() => mockIapStorageService.selectedFilmId).thenReturn(widget.selectedFilmId);

    when(() => mockIapStorageService.getPhotos()).thenAnswer((_) async => []);
    when(() => mockIapStorageService.addPhoto(any())).thenAnswer((_) async {});
    when(
      () => mockIapStorageService.updatePhoto(
        id: any(named: 'id'),
        note: any(named: 'note'),
        apertureValue: any(named: 'apertureValue'),
        shutterSpeedValue: any(named: 'shutterSpeedValue'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockIapStorageService.deletePhoto(any())).thenAnswer((_) async {});

    when(() => mockGeolocationService.getCurrentPosition()).thenAnswer((_) => Future.value());
  }

  @override
  Widget build(BuildContext context) {
    return EquipmentProfilesProvider(
      storageService: mockIapStorageService,
      child: FilmsProvider(
        storageService: mockIapStorageService,
        child: LogbookPhotosProvider(
          storageService: mockIapStorageService,
          geolocationService: mockGeolocationService,
          child: widget.child,
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
    ndValues: const [
      NdValue(0),
      NdValue(2),
      NdValue(4),
      NdValue(8),
    ],
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
    lensZoom: Platform.isAndroid
        ? 2.083333 // Pixel 6
        : 1.923, // iPhone 13 Pro
  ),
  EquipmentProfile(
    id: '2',
    name: 'Praktica + Jupiter',
    apertureValues: ApertureValue.values.sublist(
      ApertureValue.values.indexOf(const ApertureValue(3.5, StopType.third)),
      ApertureValue.values.indexOf(const ApertureValue(22, StopType.full)) + 1,
    ),
    ndValues: const [
      NdValue(0),
      NdValue(2),
      NdValue(4),
      NdValue(8),
    ],
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
    lensZoom: Platform.isAndroid
        ? 5.625 // Pixel 6
        : 5.1923, // iPhone 13 Pro
  ),
];

final mockPinholeEquipmentProfiles = [
  PinholeEquipmentProfile(
    id: '3',
    name: 'Pinhole Camera f/64',
    aperture: 64.0,
    isoValues: [
      IsoValue.values[1],
      IsoValue.values[2],
      IsoValue.values[3],
    ],
    ndValues: const [NdValue(0)],
  ),
  PinholeEquipmentProfile(
    id: '4',
    name: 'Pinhole Camera f/128',
    aperture: 128.0,
    isoValues: [
      IsoValue.values[1],
      IsoValue.values[2],
      IsoValue.values[3],
    ],
    ndValues: const [NdValue(0)],
  ),
];

const mockFilms = [
  _FilmMultiplying(id: '1', name: 'Mock film 1', iso: 100, reciprocityMultiplier: 2),
  _FilmMultiplying(id: '2', name: 'Mock film 2', iso: 400, reciprocityMultiplier: 2),
  _FilmMultiplying(id: '3', name: 'Mock film 3', iso: 800, reciprocityMultiplier: 3),
  _FilmMultiplying(id: '4', name: 'Mock film 4', iso: 1200, reciprocityMultiplier: 1.5),
];

class _FilmMultiplying extends FilmExponential {
  final double reciprocityMultiplier;

  const _FilmMultiplying({
    String? id,
    required String name,
    required super.iso,
    required this.reciprocityMultiplier,
  }) : super(id: id ?? name, name: 'Mock film $iso x$reciprocityMultiplier', exponent: 1);

  @override
  ShutterSpeedValue reciprocityFailure(ShutterSpeedValue shutterSpeed) {
    if (shutterSpeed.isFraction) {
      return shutterSpeed;
    } else {
      return ShutterSpeedValue(
        shutterSpeed.rawValue * reciprocityMultiplier,
        shutterSpeed.isFraction,
        shutterSpeed.stopType,
      );
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is _FilmMultiplying &&
        other.id == id &&
        other.name == name &&
        other.iso == iso &&
        other.reciprocityMultiplier == reciprocityMultiplier;
  }

  @override
  int get hashCode => Object.hash(id, name, iso, reciprocityMultiplier, runtimeType);
}

final List<LogbookPhoto> defaultCustomPhotos = [
  LogbookPhoto(
    id: '1',
    name: 'test_photo_1.jpg',
    timestamp: DateTime(2024, 1, 1, 12),
    ev: 12.0,
    iso: 100,
    nd: 0,
    note: 'Test photo 1',
  ),
  LogbookPhoto(
    id: '2',
    name: 'test_photo_2.jpg',
    timestamp: DateTime(2024, 1, 2, 12),
    ev: 13.0,
    iso: 200,
    nd: 1,
    note: 'Test photo 2',
  ),
];
