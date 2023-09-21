import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/metering/flow_metering.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application extends StatelessWidget {
  final Environment env;

  const Application(this.env, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        SharedPreferences.getInstance(),
        const LightSensorService(LocalPlatform()).hasSensor(),
      ]),
      builder: (_, snapshot) {
        if (snapshot.data != null) {
          return IAPProviders(
            sharedPreferences: snapshot.data![0] as SharedPreferences,
            child: ServicesProvider(
              caffeineService: const CaffeineService(),
              environment: env.copyWith(hasLightSensor: snapshot.data![1] as bool),
              hapticsService: const HapticsService(),
              lightSensorService: const LightSensorService(LocalPlatform()),
              permissionsService: const PermissionsService(),
              userPreferencesService:
                  UserPreferencesService(snapshot.data![0] as SharedPreferences),
              volumeEventsService: const VolumeEventsService(LocalPlatform()),
              child: UserPreferencesProvider(
                child: Builder(
                  builder: (context) {
                    final theme = UserPreferencesProvider.themeOf(context);
                    final systemIconsBrightness =
                        ThemeData.estimateBrightnessForColor(theme.colorScheme.onSurface);
                    return AnnotatedRegion(
                      value: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarBrightness: systemIconsBrightness == Brightness.light
                            ? Brightness.dark
                            : Brightness.light,
                        statusBarIconBrightness: systemIconsBrightness,
                        systemNavigationBarColor: Colors.transparent,
                        systemNavigationBarIconBrightness: systemIconsBrightness,
                      ),
                      child: MaterialApp(
                        theme: theme,
                        locale: Locale(UserPreferencesProvider.localeOf(context).intlName),
                        localizationsDelegates: const [
                          S.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        supportedLocales: S.delegate.supportedLocales,
                        builder: (context, child) => MediaQuery(
                          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                          child: child!,
                        ),
                        initialRoute: "metering",
                        routes: {
                          "metering": (context) => const MeteringFlow(),
                          "settings": (context) => const SettingsFlow(),
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        } else if (snapshot.error != null) {
          return Center(child: Text(snapshot.error!.toString()));
        }

        // TODO(@vodemn): maybe user splashscreen instead
        return const SizedBox();
      },
    );
  }
}

class AnimatedPickerTest extends StatefulWidget {
  const AnimatedPickerTest({super.key});

  @override
  State<AnimatedPickerTest> createState() => _AnimatedPickerTestState();
}

class _AnimatedPickerTestState extends State<AnimatedPickerTest> {
  Film _selectedFilm = Film.values.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _FilmPicker(
          values: Film.values,
          selectedValue: _selectedFilm,
          onChanged: (value) {
            setState(() {
              _selectedFilm = value;
            });
          },
        ),
      ),
    );
  }
}

class _FilmPicker extends StatelessWidget {
  final List<Film> values;
  final Film selectedValue;
  final ValueChanged<Film> onChanged;

  const _FilmPicker({
    required this.values,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<Film>(
      icon: Icons.camera_roll,
      title: "Film",
      selectedValue: selectedValue,
      values: values,
      itemTitleBuilder: (_, value) => Text(value.name.isEmpty ? 'None' : value.name),
      onChanged: onChanged,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: "Film",
          value: selectedValue.name.isEmpty ? 'None' : selectedValue.name,
        ),
      ),
    );
  }
}
