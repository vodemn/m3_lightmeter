import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'models/photography_value.dart';
import 'res/theme.dart';
import 'screens/metering/metering_bloc.dart';
import 'screens/metering/metering_screen.dart';
import 'utils/stop_type_provider.dart';

void main() {
  runApp(const Application());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void initState() {
    super.initState();
    final mySystemTheme = SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => PermissionsService(),
      child: StopTypeProvider(
        child: BlocProvider(
          create: (context) => MeteringBloc(context.read<StopType>()),
          child: MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme,
            ),
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
            home: const MeteringScreen(),
            routes: {
              "metering": (context) => const MeteringScreen(),
              "settings": (context) => const SettingsScreen(),
            },
          ),
        ),
      ),
    );
  }
}
