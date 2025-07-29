import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/modal_route_args_parser.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/equipment_profile_edit/flow_equipment_profile_edit.dart';
import 'package:lightmeter/screens/equipment_profiles/screen_equipment_profiles.dart';
import 'package:lightmeter/screens/film_edit/flow_film_edit.dart';
import 'package:lightmeter/screens/films/screen_films.dart';
import 'package:lightmeter/screens/lightmeter_pro/screen_lightmeter_pro.dart';
import 'package:lightmeter/screens/logbook_photo_edit/flow_logbook_photo_edit.dart';
import 'package:lightmeter/screens/logbook_photos/screen_logbook_photos.dart';
import 'package:lightmeter/screens/metering/flow_metering.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:lightmeter/screens/shared/release_notes_dialog/flow_dialog_release_notes.dart';
import 'package:lightmeter/screens/timer/flow_timer.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = UserPreferencesProvider.themeOf(context);
    final systemIconsBrightness = ThemeData.estimateBrightnessForColor(theme.colorScheme.onSurface);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: systemIconsBrightness == Brightness.light ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: systemIconsBrightness,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: systemIconsBrightness,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: !PlatformConfig.isTest,
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
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        ),
        initialRoute: NavigationRoutes.meteringScreen.name,
        routes: {
          NavigationRoutes.meteringScreen.name: (_) => const ReleaseNotesFlow(child: MeteringFlow()),
          NavigationRoutes.settingsScreen.name: (_) => const SettingsFlow(),
          NavigationRoutes.equipmentProfilesListScreen.name: (_) => const EquipmentProfilesScreen(),
          NavigationRoutes.equipmentProfileEditScreen.name: (context) =>
              EquipmentProfileEditFlow(args: context.routeArgs<EquipmentProfileEditArgs>()),
          NavigationRoutes.filmsListScreen.name: (_) => const FilmsScreen(),
          NavigationRoutes.filmEditScreen.name: (context) => FilmEditFlow(args: context.routeArgs<FilmEditArgs>()),
          NavigationRoutes.proFeaturesScreen.name: (_) => LightmeterProScreen(),
          NavigationRoutes.timerScreen.name: (context) => TimerFlow(args: context.routeArgs<TimerFlowArgs>()),
          NavigationRoutes.logbookPhotosListScreen.name: (_) => const LogbookPhotosScreen(),
          NavigationRoutes.logbookPhotoEditScreen.name: (context) =>
              LogbookPhotoEditFlow(args: LogbookPhotoEditArgs(photo: context.routeArgs<LogbookPhoto>())),
        },
      ),
    );
  }
}
