import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/providers/theme_provider.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late _MockSharedPreferences sharedPreferences;
  late UserPreferencesService service;

  setUpAll(() {
    sharedPreferences = _MockSharedPreferences();
    service = UserPreferencesService(sharedPreferences);
  });

  group('iso', () {
    test('get default', () {
      when(() => sharedPreferences.getInt(UserPreferencesService.isoKey)).thenReturn(null);
      expect(service.iso, const IsoValue(100, StopType.full));
    });

    test('get', () {
      when(() => sharedPreferences.getInt(UserPreferencesService.isoKey)).thenReturn(100);
      expect(service.iso, const IsoValue(100, StopType.full));
    });

    test('set', () {
      when(() => sharedPreferences.setInt(UserPreferencesService.isoKey, 200))
          .thenAnswer((_) => Future.value(true));
      service.iso = const IsoValue(200, StopType.full);
      verify(() => sharedPreferences.setInt(UserPreferencesService.isoKey, 200)).called(1);
    });
  });

  group('ndFilter', () {
    test('get default', () {
      when(() => sharedPreferences.getInt(UserPreferencesService.ndFilterKey)).thenReturn(null);
      expect(service.ndFilter, const NdValue(0));
    });

    test('get', () {
      when(() => sharedPreferences.getInt(UserPreferencesService.ndFilterKey)).thenReturn(4);
      expect(service.ndFilter, const NdValue(4));
    });

    test('set', () {
      when(() => sharedPreferences.setInt(UserPreferencesService.ndFilterKey, 0))
          .thenAnswer((_) => Future.value(true));
      service.ndFilter = const NdValue(0);
      verify(() => sharedPreferences.setInt(UserPreferencesService.ndFilterKey, 0)).called(1);
    });
  });

  group('evSourceType', () {
    test('get default', () {
      when(() => sharedPreferences.getInt(UserPreferencesService.evSourceTypeKey)).thenReturn(null);
      expect(service.evSourceType, EvSourceType.camera);
    });

    test('get', () {
      when(() => sharedPreferences.getInt(UserPreferencesService.evSourceTypeKey)).thenReturn(1);
      expect(service.evSourceType, EvSourceType.sensor);
    });

    test('set', () {
      when(() => sharedPreferences.setInt(UserPreferencesService.evSourceTypeKey, 1))
          .thenAnswer((_) => Future.value(true));
      service.evSourceType = EvSourceType.sensor;
      verify(() => sharedPreferences.setInt(UserPreferencesService.evSourceTypeKey, 1)).called(1);
    });
  });

  group('caffeine', () {
    test('get default', () {
      when(() => sharedPreferences.getBool(UserPreferencesService.caffeineKey)).thenReturn(null);
      expect(service.caffeine, false);
    });

    test('get', () {
      when(() => sharedPreferences.getBool(UserPreferencesService.caffeineKey)).thenReturn(true);
      expect(service.caffeine, true);
    });

    test('set', () {
      when(() => sharedPreferences.setBool(UserPreferencesService.caffeineKey, false))
          .thenAnswer((_) => Future.value(true));
      service.caffeine = false;
      verify(() => sharedPreferences.setBool(UserPreferencesService.caffeineKey, false)).called(1);
    });
  });

  group('meteringScreenLayout', () {
    test('get default', () {
      when(
        () => sharedPreferences.getString(UserPreferencesService.meteringScreenLayoutKey),
      ).thenReturn(null);
      expect(
        service.meteringScreenLayout,
        {
          MeteringScreenLayoutFeature.extremeExposurePairs: true,
          MeteringScreenLayoutFeature.filmPicker: true,
        },
      );
    });

    test('get', () {
      when(
        () => sharedPreferences.getString(UserPreferencesService.meteringScreenLayoutKey),
      ).thenReturn("""{"0":false,"1":true}""");
      expect(
        service.meteringScreenLayout,
        {
          MeteringScreenLayoutFeature.extremeExposurePairs: false,
          MeteringScreenLayoutFeature.filmPicker: true,
        },
      );
    });

    test('set', () {
      when(
        () => sharedPreferences.setString(
          UserPreferencesService.meteringScreenLayoutKey,
          """{"0":false,"1":true}""",
        ),
      ).thenAnswer((_) => Future.value(true));
      service.meteringScreenLayout = {
        MeteringScreenLayoutFeature.extremeExposurePairs: false,
        MeteringScreenLayoutFeature.filmPicker: true,
      };
      verify(
        () => sharedPreferences.setString(
          UserPreferencesService.meteringScreenLayoutKey,
          """{"0":false,"1":true}""",
        ),
      ).called(1);
    });
  });

  group('haptics', () {
    test('get default', () {
      when(() => sharedPreferences.getBool(UserPreferencesService.hapticsKey)).thenReturn(null);
      expect(service.haptics, true);
    });

    test('get', () {
      when(() => sharedPreferences.getBool(UserPreferencesService.hapticsKey)).thenReturn(true);
      expect(service.haptics, true);
    });

    test('set', () {
      when(() => sharedPreferences.setBool(UserPreferencesService.hapticsKey, false))
          .thenAnswer((_) => Future.value(true));
      service.haptics = false;
      verify(() => sharedPreferences.setBool(UserPreferencesService.hapticsKey, false)).called(1);
    });
  });

  group('locale', () {
    test('get default', () {
      when(() => sharedPreferences.getString(UserPreferencesService.localeKey)).thenReturn(null);
      expect(service.locale, SupportedLocale.en);
    });

    test('get', () {
      when(() => sharedPreferences.getString(UserPreferencesService.localeKey))
          .thenReturn('SupportedLocale.ru');
      expect(service.locale, SupportedLocale.ru);
    });

    test('set', () {
      when(
        () => sharedPreferences.setString(UserPreferencesService.localeKey, 'SupportedLocale.en'),
      ).thenAnswer((_) => Future.value(true));
      service.locale = SupportedLocale.en;
      verify(
        () => sharedPreferences.setString(UserPreferencesService.localeKey, 'SupportedLocale.en'),
      ).called(1);
    });
  });

  group('cameraEvCalibration', () {
    test('get default', () {
      when(() => sharedPreferences.getDouble(UserPreferencesService.cameraEvCalibrationKey))
          .thenReturn(null);
      expect(service.cameraEvCalibration, 0.0);
    });

    test('get', () {
      when(() => sharedPreferences.getDouble(UserPreferencesService.cameraEvCalibrationKey))
          .thenReturn(2.0);
      expect(service.cameraEvCalibration, 2.0);
    });

    test('set', () {
      when(
        () => sharedPreferences.setDouble(UserPreferencesService.cameraEvCalibrationKey, 1.0),
      ).thenAnswer((_) => Future.value(true));
      service.cameraEvCalibration = 1.0;
      verify(
        () => sharedPreferences.setDouble(UserPreferencesService.cameraEvCalibrationKey, 1.0),
      ).called(1);
    });
  });

  group('lightSensorEvCalibration', () {
    test('get default', () {
      when(() => sharedPreferences.getDouble(UserPreferencesService.lightSensorEvCalibrationKey))
          .thenReturn(null);
      expect(service.lightSensorEvCalibration, 0.0);
    });

    test('get', () {
      when(() => sharedPreferences.getDouble(UserPreferencesService.lightSensorEvCalibrationKey))
          .thenReturn(2.0);
      expect(service.lightSensorEvCalibration, 2.0);
    });

    test('set', () {
      when(
        () => sharedPreferences.setDouble(UserPreferencesService.lightSensorEvCalibrationKey, 1.0),
      ).thenAnswer((_) => Future.value(true));
      service.lightSensorEvCalibration = 1.0;
      verify(
        () => sharedPreferences.setDouble(UserPreferencesService.lightSensorEvCalibrationKey, 1.0),
      ).called(1);
    });
  });

  group('themeType', () {
    test('get default', () {
      when(() => sharedPreferences.getInt(UserPreferencesService.themeTypeKey)).thenReturn(null);
      expect(service.themeType, ThemeType.light);
    });

    test('get', () {
      when(() => sharedPreferences.getInt(UserPreferencesService.themeTypeKey)).thenReturn(1);
      expect(service.themeType, ThemeType.dark);
    });

    test('set', () {
      when(
        () => sharedPreferences.setInt(UserPreferencesService.themeTypeKey, 1),
      ).thenAnswer((_) => Future.value(true));
      service.themeType = ThemeType.dark;
      verify(
        () => sharedPreferences.setInt(UserPreferencesService.themeTypeKey, 1),
      ).called(1);
    });
  });

  group('primaryColor', () {
    test('get default', () {
      when(() => sharedPreferences.getInt(UserPreferencesService.primaryColorKey)).thenReturn(null);
      expect(service.primaryColor, ThemeProvider.primaryColorsList[5]);
    });

    test('get', () {
      when(() => sharedPreferences.getInt(UserPreferencesService.primaryColorKey))
          .thenReturn(0xff9c27b0);
      expect(service.primaryColor, ThemeProvider.primaryColorsList[2]);
    });

    test('set', () {
      when(
        () => sharedPreferences.setInt(UserPreferencesService.primaryColorKey, 0xff000000),
      ).thenAnswer((_) => Future.value(true));
      service.primaryColor = Colors.black;
      verify(
        () => sharedPreferences.setInt(UserPreferencesService.primaryColorKey, 0xff000000),
      ).called(1);
    });
  });

  group('dynamicColor', () {
    test('get default', () {
      when(() => sharedPreferences.getBool(UserPreferencesService.dynamicColorKey))
          .thenReturn(null);
      expect(service.dynamicColor, false);
    });

    test('get', () {
      when(() => sharedPreferences.getBool(UserPreferencesService.dynamicColorKey))
          .thenReturn(true);
      expect(service.dynamicColor, true);
    });

    test('set', () {
      when(() => sharedPreferences.setBool(UserPreferencesService.dynamicColorKey, false))
          .thenAnswer((_) => Future.value(true));
      service.dynamicColor = false;
      verify(() => sharedPreferences.setBool(UserPreferencesService.dynamicColorKey, false))
          .called(1);
    });
  });

  group('film', () {
    test('get default', () {
      when(() => sharedPreferences.getString(UserPreferencesService.filmKey)).thenReturn(null);
      expect(service.film, Film.values.first);
    });

    test('get', () {
      when(() => sharedPreferences.getString(UserPreferencesService.filmKey))
          .thenReturn('Fomapan ACTION 400');
      expect(service.film, const FomapanFilm.action400());
    });

    test('set', () {
      when(() => sharedPreferences.setString(UserPreferencesService.filmKey, 'Fomapan ACTION 400'))
          .thenAnswer((_) => Future.value(true));
      service.film = const FomapanFilm.action400();
      verify(
        () => sharedPreferences.setString(UserPreferencesService.filmKey, 'Fomapan ACTION 400'),
      ).called(1);
    });
  });
}
