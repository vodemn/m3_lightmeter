import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/equipment_profile_picker/widget_picker_equipment_profiles.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/extreme_exposure_pairs_container/widget_container_extreme_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/film_picker/widget_picker_film.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:lightmeter/utils/platform_utils.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../integration_test/utils/widget_tester_actions.dart';
import 'mocks/paid_features_mock.dart';
import 'utils/expectations.dart';

@isTestGroup
void testToggleLayoutFeatures(String description) {
  group(
    description,
    () {
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
        'Equipment profile picker',
        (tester) async {
          await tester.pumpApplication(selectedEquipmentProfileId: mockEquipmentProfiles.first.id);
          await tester.takePhoto();
          expectPickerTitle<EquipmentProfilePicker>(mockEquipmentProfiles.first.name);
          expectExtremeExposurePairs('f/1.8 - 1/100', 'f/16 - 1/1.3');
          expectExposurePairsListItem(tester, 'f/1.8', '1/100');
          await tester.scrollToTheLastExposurePair(equipmentProfile: mockEquipmentProfiles.first);
          expectExposurePairsListItem(tester, 'f/16', '1/1.3');

          // Disable layout feature
          await tester.toggleLayoutFeature(S.current.meteringScreenLayoutHintEquipmentProfiles);
          expect(
            find.byType(EquipmentProfilePicker),
            findsNothing,
            reason:
                'Equipment profile picker must be hidden from the metering screen when the corresponding layout feature is disabled.',
          );
          expectExtremeExposurePairs(
            'f/1.0 - 1/320',
            'f/45 - 6"',
            reason: 'Aperture and shutter speed ranges must be reset to default values when equipment profile is reset',
          );
          expectExposurePairsListItem(
            tester,
            'f/1.0',
            '1/320',
            reason:
                'Aperture and shutter speed ranges must be reset to default values when equipment profile is reset.',
          );
          await tester.scrollToTheLastExposurePair();
          expectExposurePairsListItem(
            tester,
            'f/45',
            '6"',
            reason:
                'Aperture and shutter speed ranges must be reset to default values when equipment profile is reset.',
          );

          // Enable layout feature
          await tester.toggleLayoutFeature(S.current.meteringScreenLayoutHintEquipmentProfiles);
          expectPickerTitle<EquipmentProfilePicker>(
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
          expectExtremeExposurePairs('f/1.0 - 1/320', 'f/45 - 6"');
          expectExposurePairsListItem(tester, 'f/1.0', '1/320');
          await tester.scrollToTheLastExposurePair();
          expectExposurePairsListItem(tester, 'f/45', '6"');

          // Disable layout feature
          await tester.toggleLayoutFeature(S.current.meteringScreenFeatureExtremeExposurePairs);
          expect(
            find.byType(ExtremeExposurePairsContainer),
            findsNothing,
            reason:
                'Extreme exposure pairs container must be hidden from the metering screen when the corresponding layout feature is disabled.',
          );
          expectExposurePairsListItem(
            tester,
            'f/1.0',
            '1/320',
            reason:
                'Exposure pairs list must not be affected by the visibility of the extreme exposure pairs container.',
          );
          await tester.scrollToTheLastExposurePair();
          expectExposurePairsListItem(
            tester,
            'f/45',
            '6"',
            reason:
                'Exposure pairs list must not be affected by the visibility of the extreme exposure pairs container.',
          );

          // Enable layout feature
          await tester.toggleLayoutFeature(S.current.meteringScreenFeatureExtremeExposurePairs);
          expectExtremeExposurePairs(
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
          await tester.pumpApplication(selectedFilmId: mockFilms.first.id);
          await tester.takePhoto();
          expectPickerTitle<FilmPicker>(mockFilms.first.name);
          expectExtremeExposurePairs('f/1.0 - 1/320', 'f/45 - 12"');
          expectExposurePairsListItem(tester, 'f/1.0', '1/320');
          await tester.scrollToTheLastExposurePair();
          expectExposurePairsListItem(tester, 'f/45', '12"');

          // Disable layout feature
          await tester.toggleLayoutFeature(S.current.meteringScreenFeatureFilmPicker);
          expect(
            find.byType(FilmPicker),
            findsNothing,
            reason:
                'Film picker must be hidden from the metering screen when the corresponding layout feature is disabled.',
          );
          expectExtremeExposurePairs(
            'f/1.0 - 1/320',
            'f/45 - 6"',
            reason: 'Shutter speed must not be affected by reciprocity when film is discarded.',
          );
          expectExposurePairsListItem(
            tester,
            'f/1.0',
            '1/320',
            reason: 'Shutter speed must not be affected by reciprocity when film is discarded.',
          );
          await tester.scrollToTheLastExposurePair();
          expectExposurePairsListItem(
            tester,
            'f/45',
            '6"',
            reason: 'Shutter speed must not be affected by reciprocity when film is discarded.',
          );

          // Enable layout feature
          await tester.toggleLayoutFeature(S.current.meteringScreenFeatureFilmPicker);
          expectPickerTitle<FilmPicker>(
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
}
