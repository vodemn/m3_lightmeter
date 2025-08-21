import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/logbook_photo_edit/screen_logbook_photo_edit.dart';
import 'package:lightmeter/screens/logbook_photos/components/grid_tile/widget_grid_tile_logbook_photo.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_picker/widget_dialog_picker.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:lightmeter/utils/platform_utils.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../integration_test/utils/widget_tester_actions.dart';
import 'mocks/paid_features_mock.dart';

@isTest
void testLogbook(String description) {
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      UserPreferencesService.evSourceTypeKey: EvSourceType.camera.index,
      UserPreferencesService.seenChangelogVersionKey: await const PlatformUtils().version,
    });
  });

  testWidgets(
    description,
    (tester) async {
      await tester.pumpApplication(
        selectedEquipmentProfileId: mockEquipmentProfiles.first.id,
        selectedFilmId: mockFilms.first.id,
        customFilms: {},
      );
      await tester.takePhoto();

      /// Open logbook
      await tester.openSettings();
      await tester.tapDescendantTextOf<SettingsScreen>(S.current.logbook);

      /// Verify that photo is present
      expect(find.byType(LogbookPhotoGridTile), findsOneWidget);

      /// Open the first photo
      await tester.tap(find.byType(LogbookPhotoGridTile).first);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text(mockEquipmentProfiles.first.name));
      await tester.ensureVisible(find.text(mockFilms.first.name));

      /// Add a note, select aperture value and shutter speed value
      await tester.enterText(
        find.descendant(
          of: find.byType(LogbookPhotoEditScreen),
          matching: find.byType(TextField),
        ),
        'Test note',
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text(S.current.shutterSpeedValue));
      await tester.pumpAndSettle();
      await tester.openPickerAndSelect<ApertureValue>(S.current.apertureValue, 'f/5.6');
      await tester.openPickerAndSelect<ShutterSpeedValue>(S.current.shutterSpeedValue, '1/125');
      await tester.openPickerAndSelect<EquipmentProfile>(S.current.equipmentProfile, S.current.notSet);
      await tester.openPickerAndSelect<Film>(S.current.film, S.current.notSet);
      await tester.pumpAndSettle();

      /// Save the edits
      await tester.tap(find.byIcon(Icons.save_outlined));
      await tester.pumpAndSettle();

      /// Disable logbook
      await tester.tap(find.text(S.current.saveNewPhotos));
      await tester.navigatorPop();
      await tester.navigatorPop();
      await tester.takePhoto();

      /// Open logbook
      await tester.openSettings();
      await tester.tapDescendantTextOf<SettingsScreen>(S.current.logbook);

      /// Verify that only one photo is present
      expect(find.byType(LogbookPhotoGridTile), findsOneWidget);

      /// Open photo again
      await tester.tap(find.byType(LogbookPhotoGridTile).first);
      await tester.pumpAndSettle();

      /// Verify the edits were saved
      expect(find.text('Test note'), findsOneWidget);
      expect(find.text('f/5.6'), findsOneWidget);
      expect(find.text('1/125'), findsOneWidget);

      /// Delete the photo
      await tester.tap(find.byIcon(Icons.delete_outlined));
      await tester.pumpAndSettle();

      /// Verify the photo was deleted
      expect(find.byType(LogbookPhotoGridTile), findsNothing);
      expect(find.text(S.current.noPhotos), findsOneWidget);
    },
  );
}

extension on WidgetTester {
  Future<void> openPickerAndSelect<V>(String title, String valueToSelect) async {
    await tap(find.text(title));
    await pumpAndSettle();
    final dialogFinder = find.byType(DialogPicker<Optional<V>>);
    final listTileFinder = find.descendant(of: dialogFinder, matching: find.text(valueToSelect));
    await scrollUntilVisible(
      listTileFinder,
      56,
      scrollable: find.descendant(of: dialogFinder, matching: find.byType(Scrollable)),
    );
    await tap(listTileFinder);
    await tapSelectButton();
  }
}
