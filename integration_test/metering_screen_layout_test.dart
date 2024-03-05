import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/components/exposure_pairs_list_item/widget_item_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/widget_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/equipment_profile_picker/widget_picker_equipment_profiles.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/extreme_exposure_pairs_container/widget_container_extreme_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/film_picker/widget_picker_film.dart';
import 'package:lightmeter/screens/metering/screen_metering.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../integration_test/utils/widget_tester_actions.dart';
import 'mocks/paid_features_mock.dart';

const _mockPhotoEv100 = 8.3;

@isTestGroup
void testToggleLayoutFeatures(String description) {
  group(
    description,
    () {
      setUp(() {
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
        });
      });

      testWidgets(
        'Equipment profile picker',
        (tester) async {
          await tester.pumpApplication(selectedEquipmentProfileId: mockEquipmentProfiles.first.id);
          await tester.takePhoto();
          _expectPickerTitle<EquipmentProfilePicker>(mockEquipmentProfiles.first.name);
          _expectExtremeExposurePairs('f/1.8 - 1/100', 'f/16 - 1/1.3');
          _expectExposurePairsListItem(tester, 'f/1.8', '1/100');
          await tester.scrollToTheLastExposurePair(mockEquipmentProfiles.first);
          _expectExposurePairsListItem(tester, 'f/16', '1/1.3');

          // Disable layout feature
          await tester.toggleLayoutFeature(S.current.meteringScreenLayoutHintEquipmentProfiles);
          expect(
            find.byType(EquipmentProfilePicker),
            findsNothing,
            reason:
                'Equipment profile picker must be hidden from the metering screen when the corresponding layout feature is disabled.',
          );
          _expectExtremeExposurePairs(
            'f/1.0 - 1/320',
            'f/45 - 6"',
            reason: 'Aperture and shutter speed ranges must be reset to default values when equipment profile is reset',
          );
          _expectExposurePairsListItem(
            tester,
            'f/1.0',
            '1/320',
            reason:
                'Aperture and shutter speed ranges must be reset to default values when equipment profile is reset.',
          );
          await tester.scrollToTheLastExposurePair();
          _expectExposurePairsListItem(
            tester,
            'f/45',
            '6"',
            reason:
                'Aperture and shutter speed ranges must be reset to default values when equipment profile is reset.',
          );

          // Enable layout feature
          await tester.toggleLayoutFeature(S.current.meteringScreenLayoutHintEquipmentProfiles);
          _expectPickerTitle<EquipmentProfilePicker>(
            S.current.none,
            reason: 'Equipment profile must remain unselected when the corresponding layout feature is re-enabled.',
          );
        },
      );

      testWidgets(
        'Extreme exposure pairs container',
        (tester) async {
          await tester.pumpApplication();
          await tester.takePhoto();
          _expectExtremeExposurePairs('f/1.0 - 1/320', 'f/45 - 6"');
          _expectExposurePairsListItem(tester, 'f/1.0', '1/320');
          await tester.scrollToTheLastExposurePair();
          _expectExposurePairsListItem(tester, 'f/45', '6"');

          // Disable layout feature
          await tester.toggleLayoutFeature(S.current.meteringScreenFeatureExtremeExposurePairs);
          expect(
            find.byType(ExtremeExposurePairsContainer),
            findsNothing,
            reason:
                'Extreme exposure pairs container must be hidden from the metering screen when the corresponding layout feature is disabled.',
          );
          _expectExposurePairsListItem(
            tester,
            'f/1.0',
            '1/320',
            reason:
                'Exposure pairs list must not be affected by the visibility of the extreme exposure pairs container.',
          );
          await tester.scrollToTheLastExposurePair();
          _expectExposurePairsListItem(
            tester,
            'f/45',
            '6"',
            reason:
                'Exposure pairs list must not be affected by the visibility of the extreme exposure pairs container.',
          );

          // Enable layout feature
          await tester.toggleLayoutFeature(S.current.meteringScreenFeatureExtremeExposurePairs);
          _expectExtremeExposurePairs(
            'f/1.0 - 1/320',
            'f/45 - 6"',
            reason:
                'Exposure pairs list must not be affected by the visibility of the extreme exposure pairs container.',
          );
        },
      );

      testWidgets(
        'Film picker',
        (tester) async {
          await tester.pumpApplication(selectedFilm: mockFilms.first);
          await tester.takePhoto();
          _expectPickerTitle<FilmPicker>(mockFilms.first.name);
          _expectExtremeExposurePairs('f/1.0 - 1/320', 'f/45 - 12"');
          _expectExposurePairsListItem(tester, 'f/1.0', '1/320');
          await tester.scrollToTheLastExposurePair();
          _expectExposurePairsListItem(tester, 'f/45', '12"');

          // Disable layout feature
          await tester.toggleLayoutFeature(S.current.meteringScreenFeatureFilmPicker);
          expect(
            find.byType(FilmPicker),
            findsNothing,
            reason:
                'Film picker must be hidden from the metering screen when the corresponding layout feature is disabled.',
          );
          _expectExtremeExposurePairs(
            'f/1.0 - 1/320',
            'f/45 - 6"',
            reason: 'Shutter speed must not be affected by reciprocity when film is discarded.',
          );
          _expectExposurePairsListItem(
            tester,
            'f/1.0',
            '1/320',
            reason: 'Shutter speed must not be affected by reciprocity when film is discarded.',
          );
          await tester.scrollToTheLastExposurePair();
          _expectExposurePairsListItem(
            tester,
            'f/45',
            '6"',
            reason: 'Shutter speed must not be affected by reciprocity when film is discarded.',
          );

          // Enable layout feature
          await tester.toggleLayoutFeature(S.current.meteringScreenFeatureFilmPicker);
          _expectPickerTitle<FilmPicker>(
            S.current.none,
            reason: 'Film must remain unselected when the corresponding layout feature is re-enabled.',
          );
        },
      );
    },
  );
}

extension on WidgetTester {
  Future<void> toggleLayoutFeature(String feature) async {
    await openSettings();
    await tapDescendantTextOf<SettingsScreen>(S.current.meteringScreenLayout);
    await tapDescendantTextOf<SwitchListTile>(feature);
    await tapSaveButton();
    await navigatorPop();
  }

  Future<void> scrollToTheLastExposurePair([EquipmentProfile equipmentProfile = defaultEquipmentProfile]) async {
    final exposurePairs = MeteringContainerBuidler.buildExposureValues(
      _mockPhotoEv100,
      StopType.third,
      equipmentProfile,
    );
    await scrollUntilVisible(
      find.byWidgetPredicate((widget) => widget is Row && widget.key == ValueKey(exposurePairs.length - 1)),
      56,
      scrollable: find.descendant(of: find.byType(ExposurePairsList), matching: find.byType(Scrollable)),
    );
  }
}

void _expectPickerTitle<T>(String title, {String? reason}) {
  expect(find.descendant(of: find.byType(T), matching: find.text(title)), findsOneWidget, reason: reason);
}

void _expectExtremeExposurePairs(String fastest, String slowest, {String? reason}) {
  final pickerFinder = find.byType(ExtremeExposurePairsContainer);
  expect(find.descendant(of: pickerFinder, matching: find.text(fastest)), findsOneWidget, reason: reason);
  expect(find.descendant(of: pickerFinder, matching: find.text(slowest)), findsOneWidget, reason: reason);
}

void _expectExposurePairsListItem(WidgetTester tester, String aperture, String shutterSpeed, {String? reason}) {
  Key? findKey<T extends PhotographyStopValue<num>>(String value) => tester
      .widget<Row>(
        find.ancestor(
          of: find.ancestor(
            of: find.text(value),
            matching: find.byType(ExposurePairsListItem<T>),
          ),
          matching: find.descendant(of: find.byType(ExposurePairsList), matching: find.byType(Row)),
        ),
      )
      .key;
  expect(
    findKey<ApertureValue>(aperture),
    findKey<ShutterSpeedValue>(shutterSpeed),
    reason: reason,
  );
}
