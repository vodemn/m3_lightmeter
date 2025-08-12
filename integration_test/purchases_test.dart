import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/equipment_profile_picker/widget_picker_equipment_profiles.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/extreme_exposure_pairs_container/widget_container_extreme_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/film_picker/widget_picker_film.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/lightmeter_pro_badge/widget_badge_lightmeter_pro.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/nd_picker/widget_picker_nd.dart';
import 'package:lightmeter/utils/platform_utils.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../integration_test/utils/widget_tester_actions.dart';
import 'mocks/iap_products_mock.dart';
import 'utils/finder_actions.dart';

@isTest
void testPurchases(String description) {
  testWidgets(
    description,
    (tester) async {
      SharedPreferences.setMockInitialValues({
        /// Metering values
        UserPreferencesService.evSourceTypeKey: EvSourceType.camera.index,
        UserPreferencesService.showEv100Key: true,
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
      await tester.takePhoto();

      /// Expect the bare minimum free functionallity
      _expectProMeteringScreen(enabled: false);

      /// Make purchase
      (tester.state(find.byType(MockIAPProductsProvider)) as MockIAPProductsProviderState).buy();
      await tester.pumpAndSettle();

      _expectProMeteringScreen(enabled: true);

      /// Refund
      (tester.state(find.byType(MockIAPProductsProvider)) as MockIAPProductsProviderState).clearPurchases();
      await tester.pumpAndSettle();

      /// Expect the bare minimum free functionallity
      _expectProMeteringScreen(enabled: false);
    },
  );
}

void _expectProMeteringScreen({required bool enabled}) {
  expect(find.byType(LightmeterProBadge), !enabled ? findsOneWidget : findsNothing);
  expect(find.byType(EquipmentProfilePicker), findsOneWidget);
  expect(find.byType(ExtremeExposurePairsContainer), findsOneWidget);
  expect(find.byType(FilmPicker), findsOneWidget);
  expect(find.byType(IsoValuePicker), findsOneWidget);
  expect(find.byType(NdValuePicker), findsOneWidget);
  expect(
    find.descendant(
      of: find.measureButton(),
      matching: find.byWidgetPredicate((widget) => widget is Text && widget.data!.contains('\u2081\u2080\u2080')),
    ),
    findsOneWidget,
  );
}
