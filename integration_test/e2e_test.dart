import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/widget_bottom_controls.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/equipment_profile_picker/widget_picker_equipment_profiles.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/film_picker/widget_picker_film.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/nd_picker/widget_picker_nd.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_filter/widget_dialog_filter.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_range_picker/widget_dialog_picker_range.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:lightmeter/utils/double_to_zoom.dart';
import 'package:lightmeter/utils/platform_utils.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../integration_test/utils/widget_tester_actions.dart';
import 'mocks/paid_features_mock.dart';
import 'utils/expectations.dart';

@isTest
void testE2E(String description) {
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      /// Metering values
      UserPreferencesService.evSourceTypeKey: EvSourceType.camera.index,
      UserPreferencesService.meteringScreenLayoutKey: json.encode(
        {
          MeteringScreenLayoutFeature.equipmentProfiles: true,
          MeteringScreenLayoutFeature.extremeExposurePairs: true,
          MeteringScreenLayoutFeature.filmPicker: true,
        }.toJson(),
      ),

      UserPreferencesService.seenChangelogVersionKey: await const PlatformUtils().version,
    });
  });

  testWidgets(
    description,
    (tester) async {
      await tester.pumpApplication(
        equipmentProfiles: {},
        predefinedFilms: mockFilms.toSelectableMap(),
        customFilms: {},
      );

      /// Create Praktica + Zenitar profile from scratch
      await tester.openSettings();
      await tester.tapDescendantTextOf<SettingsScreen>(S.current.equipmentProfiles);
      await tester.tap(find.byIcon(Icons.add_outlined).first);
      await tester.pumpAndSettle();
      await tester.enterProfileName(mockEquipmentProfiles[0].name);
      await tester.setIsoValues(mockEquipmentProfiles[0].isoValues);
      await tester.setNdValues(mockEquipmentProfiles[0].ndValues);
      await tester.setApertureValues(mockEquipmentProfiles[0].apertureValues);
      await tester.setShutterSpeedValues(mockEquipmentProfiles[0].shutterSpeedValues);
      await tester.setZoomValue(mockEquipmentProfiles[0].lensZoom);
      expect(find.text('x1.91'), findsOneWidget);
      expect(find.text('f/1.7 - f/16'), findsOneWidget);
      expect(find.text('1/1000 - B'), findsOneWidget);
      await tester.saveEdits();

      /// Create Praktica + Jupiter profile from Zenitar profile
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.copy_outlined).first);
      await tester.pumpAndSettle();
      await tester.enterProfileName(mockEquipmentProfiles[1].name);
      await tester.setApertureValues(mockEquipmentProfiles[1].apertureValues);
      await tester.setZoomValue(mockEquipmentProfiles[1].lensZoom);
      expect(find.text('x5.02'), findsOneWidget);
      expect(find.text('f/3.5 - f/22'), findsOneWidget);
      expect(find.text('1/1000 - B'), findsNWidgets(1));
      await tester.saveEdits();

      /// Verify that both profiles were added and leave to the main screen
      expect(find.text(mockEquipmentProfiles[0].name), findsOneWidget);
      expect(find.text(mockEquipmentProfiles[1].name), findsOneWidget);
      await tester.navigatorPop();
      await tester.navigatorPop();

      /// Select some initial settings according to the selected gear and film
      /// Then take a photo and verify, that exposure pairs range and EV matches the selected settings
      await tester.openPickerAndSelect<EquipmentProfilePicker, EquipmentProfile>(mockEquipmentProfiles[0].name);
      await tester.openPickerAndSelect<FilmPicker, Film>(mockFilms[0].name);
      await tester.openPickerAndSelect<IsoValuePicker, IsoValue>('400');
      expectPickerTitle<EquipmentProfilePicker>(mockEquipmentProfiles[0].name);
      expectPickerTitle<FilmPicker>(mockFilms[0].name);
      expectPickerTitle<IsoValuePicker>('400');
      await tester.takePhoto();
      await _expectMeteringState(
        tester,
        equipmentProfile: mockEquipmentProfiles[0],
        film: mockFilms[0],
        fastest: 'f/1.8 - 1/400',
        slowest: 'f/16 - 1/5',
        iso: '400',
        nd: 'None',
        ev: mockPhotoEv100 + 2,
      );

      /// Add ND to shoot another scene
      await tester.openPickerAndSelect<NdValuePicker, NdValue>('2');
      await _expectMeteringStateAndMeasure(
        tester,
        equipmentProfile: mockEquipmentProfiles[0],
        film: mockFilms[0],
        fastest: 'f/1.8 - 1/200',
        slowest: 'f/16 - 1/2.5',
        iso: '400',
        nd: '2',
        ev: mockPhotoEv100 + 2 - 1,
      );

      /// Select another lens without ND
      await tester.openPickerAndSelect<EquipmentProfilePicker, EquipmentProfile>(mockEquipmentProfiles[1].name);
      await tester.openPickerAndSelect<NdValuePicker, NdValue>('None');
      await _expectMeteringStateAndMeasure(
        tester,
        equipmentProfile: mockEquipmentProfiles[1],
        film: mockFilms[0],
        fastest: 'f/3.5 - 1/100',
        slowest: 'f/22 - 1/2.5',
        iso: '400',
        nd: 'None',
        ev: mockPhotoEv100 + 2,
      );

      /// Set another film and another ISO
      await tester.openPickerAndSelect<IsoValuePicker, IsoValue>('200');
      await tester.openPickerAndSelect<FilmPicker, Film>(mockFilms[1].name);
      await _expectMeteringStateAndMeasure(
        tester,
        equipmentProfile: mockEquipmentProfiles[1],
        film: mockFilms[1],
        fastest: 'f/3.5 - 1/50',
        slowest: 'f/22 - 1/1.3',
        iso: '200',
        nd: 'None',
        ev: mockPhotoEv100 + 1,
      );

      /// Delete profile
      await tester.openSettings();
      await tester.tapDescendantTextOf<SettingsScreen>(S.current.equipmentProfiles);
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();
      await tester.deleteEdits();
      expect(find.text(mockEquipmentProfiles[0].name), findsNothing);
      expect(find.text(mockEquipmentProfiles[1].name), findsOneWidget);
    },
  );
}

extension EquipmentProfileActions on WidgetTester {
  Future<void> enterProfileName(String name) async {
    await enterText(find.byType(TextField), name);
    await pump();
  }

  Future<void> setIsoValues(List<IsoValue> values) =>
      _openAndSetDialogFilterValues<IsoValue>(S.current.isoValues, values);
  Future<void> setNdValues(List<NdValue> values) => _openAndSetDialogFilterValues<NdValue>(S.current.ndFilters, values);
  Future<void> _openAndSetDialogFilterValues<T extends PhotographyValue>(
    String listTileTitle,
    List<T> valuesToSelect, {
    bool deselectAll = true,
  }) async {
    await tap(find.text(listTileTitle));
    await pumpAndSettle();
    await setDialogFilterValues(valuesToSelect, deselectAll: deselectAll);
  }

  Future<void> setApertureValues(List<ApertureValue> values) =>
      _setDialogRangePickerValues<ApertureValue>(S.current.apertureValues, values);

  Future<void> setShutterSpeedValues(List<ShutterSpeedValue> values) =>
      _setDialogRangePickerValues<ShutterSpeedValue>(S.current.shutterSpeedValues, values);

  Future<void> setZoomValue(double value) => _setDialogSliderPickerValue(S.current.lensZoom, value);
}

extension on WidgetTester {
  Future<void> openPickerAndSelect<P extends Widget, V>(String valueToSelect) async {
    await openAnimatedPicker<P>();
    await tapDescendantTextOf<DialogPicker<V>>(valueToSelect);
    await tapSelectButton();
  }

  Future<void> saveEdits() async {
    await tap(find.byIcon(Icons.save_outlined));
    await pumpAndSettle(Dimens.durationML);
  }

  Future<void> deleteEdits() async {
    await tap(find.byIcon(Icons.delete_outlined));
    await pumpAndSettle(Dimens.durationML);
  }

  Future<void> setDialogFilterValues<T>(
    List<T> valuesToSelect, {
    bool deselectAll = true,
  }) async {
    if (deselectAll) {
      await tap(find.byIcon(Icons.deselect_outlined));
      await pump();
    }
    for (final value in valuesToSelect) {
      final listTile = find.descendant(of: find.byType(CheckboxListTile), matching: find.text(value.toString()));
      await scrollUntilVisible(
        listTile,
        56,
        scrollable: find.descendant(of: find.byType(DialogFilter<T>), matching: find.byType(Scrollable)),
      );
      await tap(listTile);
      await pump();
    }
    await tapSaveButton();
  }

  Future<void> _setDialogRangePickerValues<T extends PhotographyValue>(
    String listTileTitle,
    List<T> valuesToSelect,
  ) async {
    await tap(find.text(listTileTitle));
    await pumpAndSettle();

    final dialog = widget<DialogRangePicker<T>>(find.byType(DialogRangePicker<T>));
    final sliderFinder = find.byType(RangeSlider);
    final divisions = widget<RangeSlider>(sliderFinder).divisions!;
    final trackWidth = getSize(sliderFinder).width - (2 * Dimens.paddingL);
    final trackStep = trackWidth / divisions;

    final start = valuesToSelect.first;
    final oldStart = dialog.values.indexWhere((e) => e.value == dialog.selectedValues.first.value) * trackStep;
    final newStart = dialog.values.indexWhere((e) => e.value == start.value) * trackStep;
    await dragFrom(
      getTopLeft(sliderFinder) + Offset(Dimens.paddingL + oldStart, getSize(sliderFinder).height / 2),
      Offset(newStart - oldStart, 0),
    );
    await pump();

    final end = valuesToSelect.last;
    final oldEnd = dialog.values.indexWhere((e) => e.value == dialog.selectedValues.last.value) * trackStep;
    final newEnd = dialog.values.indexWhere((e) => e.value == end.value) * trackStep;
    await dragFrom(
      getTopLeft(sliderFinder) + Offset(Dimens.paddingL + oldEnd, getSize(sliderFinder).height / 2),
      Offset(newEnd - oldEnd, 0),
    );
    await pump();

    await tapSaveButton();
  }

  Future<void> _setDialogSliderPickerValue(
    String listTileTitle,
    double value,
  ) async {
    await tap(find.text(listTileTitle));
    await pumpAndSettle();

    final sliderFinder = find.byType(Slider);
    final trackWidth = getSize(sliderFinder).width - (2 * Dimens.paddingL);
    final trackStep = trackWidth / (widget<Slider>(sliderFinder).max - widget<Slider>(sliderFinder).min);

    final oldValue = widget<Slider>(sliderFinder).value;
    final oldStart = (oldValue - 1) * trackStep;
    final newStart = (value - 1) * trackStep;
    await dragFrom(
      getTopLeft(sliderFinder) + Offset(Dimens.paddingL + oldStart, getSize(sliderFinder).height / 2),
      Offset(newStart - oldStart, 0),
    );
    await pump();

    await tapSaveButton();
  }
}

Future<void> _expectMeteringState(
  WidgetTester tester, {
  required EquipmentProfile equipmentProfile,
  required Film film,
  required String fastest,
  required String slowest,
  required String iso,
  required String nd,
  required double ev,
  String? reason,
}) async {
  expectPickerTitle<EquipmentProfilePicker>(equipmentProfile.name);
  expectPickerTitle<FilmPicker>(film.name);
  expectExtremeExposurePairs(fastest, slowest);
  expectPickerTitle<IsoValuePicker>(iso);
  expectPickerTitle<NdValuePicker>(nd);
  expectExposurePairsListItem(tester, fastest.split(' - ')[0], fastest.split(' - ')[1]);
  await tester.scrollToTheLastExposurePair(equipmentProfile: equipmentProfile);
  expectExposurePairsListItem(tester, slowest.split(' - ')[0], slowest.split(' - ')[1]);
  expectMeasureButton(ev);
  expect(find.text(equipmentProfile.lensZoom.toZoom()), findsOneWidget);
}

Future<void> _expectMeteringStateAndMeasure(
  WidgetTester tester, {
  required EquipmentProfile equipmentProfile,
  required Film film,
  required String fastest,
  required String slowest,
  required String iso,
  required String nd,
  required double ev,
}) async {
  await _expectMeteringState(
    tester,
    equipmentProfile: equipmentProfile,
    film: film,
    fastest: fastest,
    slowest: slowest,
    iso: iso,
    nd: nd,
    ev: ev,
  );
  await tester.takePhoto();
  await _expectMeteringState(
    tester,
    equipmentProfile: equipmentProfile,
    film: film,
    fastest: fastest,
    slowest: slowest,
    iso: iso,
    nd: nd,
    ev: ev,
    reason:
        'Metering screen state must be the same before and after the measurement assuming that the scene is exactly the same.',
  );
}

void expectMeasureButton(double ev) {
  find.descendant(
    of: find.byType(MeteringBottomControls),
    matching: find.text('${ev.toStringAsFixed(1)}\n${S.current.ev}'),
  );
}
