import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/equipment_profile_edit/screen_equipment_profile_edit.dart';
import 'package:lightmeter/screens/lightmeter_pro/screen_lightmeter_pro.dart';
import 'package:lightmeter/screens/logbook_photos/screen_logbook_photos.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:lightmeter/utils/platform_utils.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../integration_test/utils/widget_tester_actions.dart';
import 'mocks/iap_products_mock.dart';

@isTest
void testGuardProTap(String description) {
  testWidgets(
    description,
    (tester) async {
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

      await tester.pumpApplication(isPro: false);
      await tester.openSettings();
      await tester.tapDescendantTextOf<SettingsScreen>(S.current.equipmentProfiles);

      /// Try adding a new equipment profile
      await tester.tap(find.byIcon(Icons.add_outlined).first);
      await tester.pumpAndSettle();
      expect(find.byType(LightmeterProScreen), findsOneWidget);

      /// Purchase Pro
      (tester.state(find.byType(MockIAPProductsProvider)) as MockIAPProductsProviderState).buy();
      await tester.navigatorPop(true);
      await tester.pumpAndSettle();
      expect(find.byType(LightmeterProScreen), findsNothing);
      expect(find.byType(EquipmentProfileEditScreen), findsOneWidget);
      await tester.navigatorPop();
      await tester.navigatorPop();

      /// Refund
      (tester.state(find.byType(MockIAPProductsProvider)) as MockIAPProductsProviderState).clearPurchases();
      await tester.pumpAndSettle();
      await tester.tapDescendantTextOf<SettingsScreen>(S.current.logbook);

      /// Try enabling logbook
      await tester.tap(find.text(S.current.saveNewPhotos));
      await tester.pumpAndSettle();
      expect(find.byType(LightmeterProScreen), findsOneWidget);
      (tester.state(find.byType(MockIAPProductsProvider)) as MockIAPProductsProviderState).buy();
      await tester.navigatorPop(true);
      await tester.pumpAndSettle();
      expect(find.byType(LightmeterProScreen), findsNothing);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(LogbookPhotosScreen),
          matching: find.byWidgetPredicate((widget) => widget is SwitchListTile && widget.value),
        ),
        findsOneWidget,
      );
    },
  );
}
