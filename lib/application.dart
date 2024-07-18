import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/metering/flow_metering.dart';
import 'package:lightmeter/screens/pro_features/screen_pro_features.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:lightmeter/screens/shared/release_notes_dialog/flow_dialog_release_notes.dart';
import 'package:lightmeter/screens/timer/flow_timer.dart';

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
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        ),
        initialRoute: "metering",
        routes: {
          "metering": (_) => const ReleaseNotesFlow(child: MeteringFlow()),
          "settings": (_) => const SettingsFlow(),
          "proFeatures": (_) => const ProFeaturesScreen(),
          "timer": (context) => TimerFlow(args: ModalRoute.of(context)!.settings.arguments! as TimerFlowArgs),
        },
      ),
    );
  }
}
