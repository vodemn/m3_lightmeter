import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/animated_dialog_picker/widget_picker_dialog_animated.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/reading_value_container/widget_container_reading_value.dart';
import 'package:lightmeter/screens/metering/flow_metering.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:lightmeter/utils/inherited_generics.dart';

class Application extends StatelessWidget {
  final Environment env;

  const Application(this.env, {super.key});

  @override
  Widget build(BuildContext context) {
    return LightmeterProviders(
      env: env,
      builder: (context, ready) => ready
          ? _AnnotatedRegionWrapper(
              child: MaterialApp(
                theme: context.listen<ThemeData>(),
                locale: Locale(context.listen<SupportedLocale>().intlName),
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
            )
          : const SizedBox(),
    );
  }
}

class _AnnotatedRegionWrapper extends StatelessWidget {
  final Widget child;

  const _AnnotatedRegionWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final systemIconsBrightness = ThemeData.estimateBrightnessForColor(
      context.listen<ThemeData>().colorScheme.onSurface,
    );
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness:
            systemIconsBrightness == Brightness.light ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: systemIconsBrightness,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: systemIconsBrightness,
      ),
      child: child,
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
