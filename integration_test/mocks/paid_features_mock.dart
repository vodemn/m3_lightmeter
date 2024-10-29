import 'package:flutter/material.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';

class _MockIAPStorageService extends Mock implements IAPStorageService {}

class _MockFilmsStorageService extends Mock implements FilmsStorageService {}

class MockIAPProviders extends StatefulWidget {
  final List<EquipmentProfile>? equipmentProfiles;
  final String selectedEquipmentProfileId;
  final Map<String, SelectableFilm<Film>> predefinedFilms;
  final Map<String, SelectableFilm<FilmExponential>> customFilms;
  final String selectedFilmId;
  final Widget child;

  MockIAPProviders({
    this.equipmentProfiles = const [],
    this.selectedEquipmentProfileId = '',
    Map<String, SelectableFilm<Film>>? predefinedFilms,
    Map<String, SelectableFilm<FilmExponential>>? customFilms,
    String? selectedFilmId,
    required this.child,
    super.key,
  })  : predefinedFilms = predefinedFilms ?? mockFilms.toFilmsMap(),
        customFilms = customFilms ?? mockFilms.toFilmsMap(),
        selectedFilmId = selectedFilmId ?? const FilmStub().id;

  @override
  State<MockIAPProviders> createState() => _MockIAPProvidersState();
}

class _MockIAPProvidersState extends State<MockIAPProviders> {
  late final _MockIAPStorageService mockIAPStorageService;
  late final _MockFilmsStorageService mockFilmsStorageService;

  @override
  void initState() {
    super.initState();
    mockIAPStorageService = _MockIAPStorageService();
    when(() => mockIAPStorageService.equipmentProfiles).thenReturn(widget.equipmentProfiles ?? mockEquipmentProfiles);
    when(() => mockIAPStorageService.selectedEquipmentProfileId).thenReturn(widget.selectedEquipmentProfileId);

    mockFilmsStorageService = _MockFilmsStorageService();
    when(() => mockFilmsStorageService.getPredefinedFilms()).thenAnswer((_) => Future.value(widget.predefinedFilms));
    when(() => mockFilmsStorageService.getCustomFilms()).thenAnswer((_) => Future.value(widget.customFilms));
    when(() => mockFilmsStorageService.selectedFilmId).thenReturn(widget.selectedFilmId);
  }

  @override
  Widget build(BuildContext context) {
    return EquipmentProfileProvider(
      storageService: mockIAPStorageService,
      child: FilmsProvider(
        filmsStorageService: mockFilmsStorageService,
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
    lensZoom: 1.91,
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
    lensZoom: 5.02,
  ),
];

const mockFilms = [
  FilmMultiplying(id: '1', name: 'Mock film 1', iso: 100, reciprocityMultiplier: 2),
  FilmMultiplying(id: '2', name: 'Mock film 2', iso: 400, reciprocityMultiplier: 2),
  FilmMultiplying(id: '3', name: 'Mock film 3', iso: 800, reciprocityMultiplier: 3),
  FilmMultiplying(id: '4', name: 'Mock film 4', iso: 1200, reciprocityMultiplier: 1.5),
];

extension FilmMapper on List<Film> {
  Map<String, ({T film, bool isUsed})> toFilmsMap<T extends Film>({bool isUsed = true}) =>
      Map.fromEntries(map((e) => MapEntry(e.id, (film: e as T, isUsed: isUsed))));
}

class FilmMultiplying extends FilmExponential {
  final double reciprocityMultiplier;

  const FilmMultiplying({
    String? id,
    required super.name,
    required super.iso,
    required this.reciprocityMultiplier,
  }) : super(id: id ?? name, exponent: 1);

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
    return other is FilmMultiplying &&
        other.id == id &&
        other.name == name &&
        other.iso == iso &&
        other.reciprocityMultiplier == reciprocityMultiplier;
  }

  @override
  int get hashCode => Object.hash(id, name, iso, reciprocityMultiplier, runtimeType);
}
