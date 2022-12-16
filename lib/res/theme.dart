import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import 'package:provider/provider.dart';

class ThemeProvider extends StatefulWidget {
  final Color initialPrimaryColor;
  final Widget? child;
  final TransitionBuilder? builder;

  const ThemeProvider({
    required this.initialPrimaryColor,
    this.child,
    this.builder,
    super.key,
  });

  static ThemeProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<ThemeProviderState>()!;
  }

  @override
  State<ThemeProvider> createState() => ThemeProviderState();
}

class ThemeProviderState extends State<ThemeProvider> {
  late ThemeType _themeType;
  late Color _primaryColor = widget.initialPrimaryColor;

  @override
  void initState() {
    super.initState();
    _themeType = context.read<UserPreferencesService>().themeType;
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _themeType,
      child: Provider.value(
        value: _themeFromColor(
          _primaryColor,
          _mapThemeTypeToBrightness(_themeType),
        ),
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }

  void setThemeType(ThemeType themeType) {
    if (themeType == _themeType) {
      return;
    }

    setState(() {
      _themeType = themeType;
    });
    context.read<UserPreferencesService>().themeType = themeType;
  }

  void setPrimaryColor(Color color) {
    if (color == _primaryColor) {
      return;
    }

    setState(() {
      _primaryColor = color;
    });
  }

  Brightness _mapThemeTypeToBrightness(ThemeType themeType) {
    switch (themeType) {
      case ThemeType.light:
        return Brightness.light;
      case ThemeType.dark:
        return Brightness.dark;
      case ThemeType.systemDefault:
        return SchedulerBinding.instance.platformDispatcher.platformBrightness;
    }
  }

  ThemeData _themeFromColor(Color color, Brightness brightness) {
    final scheme = brightness == Brightness.light ? Scheme.light(color.value) : Scheme.dark(color.value);
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: Color(scheme.primary),
      onPrimary: Color(scheme.onPrimary),
      primaryContainer: Color(scheme.primaryContainer),
      onPrimaryContainer: Color(scheme.onPrimaryContainer),
      secondary: Color(scheme.secondary),
      onSecondary: Color(scheme.onSecondary),
      error: Color(scheme.error),
      onError: Color(scheme.onError),
      background: Color(scheme.background),
      onBackground: Color(scheme.onBackground),
      surface: Color.alphaBlend(Color(scheme.primary).withOpacity(0.05), Color(scheme.background)),
      onSurface: Color(scheme.onSurface),
      surfaceVariant: Color.alphaBlend(Color(scheme.primary).withOpacity(0.5), Color(scheme.background)),
      onSurfaceVariant: Color(scheme.onSurfaceVariant),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
    );
  }
}
