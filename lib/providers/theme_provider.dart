import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/utils/inherited_generics.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import 'package:provider/provider.dart';

class ThemeProvider extends StatefulWidget {
  final Widget child;

  const ThemeProvider({
    required this.child,
    super.key,
  });

  static ThemeProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<ThemeProviderState>()!;
  }

  static const primaryColorsList = [
    Color(0xfff44336),
    Color(0xffe91e63),
    Color(0xff9c27b0),
    Color(0xff673ab7),
    Color(0xff3f51b5),
    Color(0xff2196f3),
    Color(0xff03a9f4),
    Color(0xff00bcd4),
    Color(0xff009688),
    Color(0xff4caf50),
    Color(0xff8bc34a),
    Color(0xffcddc39),
    Color(0xffffeb3b),
    Color(0xffffc107),
    Color(0xffff9800),
    Color(0xffff5722),
  ];

  @override
  State<ThemeProvider> createState() => ThemeProviderState();
}

class ThemeProviderState extends State<ThemeProvider> with WidgetsBindingObserver {
  UserPreferencesService get _prefs => context.read<UserPreferencesService>();

  late final _themeTypeNotifier = ValueNotifier<ThemeType>(_prefs.themeType);
  late final _dynamicColorNotifier = ValueNotifier<bool>(_prefs.dynamicColor);
  late final _primaryColorNotifier = ValueNotifier<Color>(_prefs.primaryColor);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _themeTypeNotifier.dispose();
    _dynamicColorNotifier.dispose();
    _primaryColorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _themeTypeNotifier,
      builder: (_, themeType, __) => InheritedWidgetBase<ThemeType>(
        data: themeType,
        child: ValueListenableBuilder(
          valueListenable: _dynamicColorNotifier,
          builder: (_, useDynamicColor, __) => _DynamicColorProvider(
            useDynamicColor: useDynamicColor,
            themeBrightness: _themeBrightness,
            builder: (_, dynamicPrimaryColor) => ValueListenableBuilder(
              valueListenable: _primaryColorNotifier,
              builder: (_, primaryColor, __) => _ThemeDataProvider(
                primaryColor: dynamicPrimaryColor ?? primaryColor,
                brightness: _themeBrightness,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setThemeType(ThemeType themeType) {
    _themeTypeNotifier.value = themeType;
    _prefs.themeType = themeType;
  }

  Brightness get _themeBrightness {
    switch (_themeTypeNotifier.value) {
      case ThemeType.light:
        return Brightness.light;
      case ThemeType.dark:
        return Brightness.dark;
      case ThemeType.systemDefault:
        return SchedulerBinding.instance.platformDispatcher.platformBrightness;
    }
  }

  void setPrimaryColor(Color color) {
    _primaryColorNotifier.value = color;
    _prefs.primaryColor = color;
  }

  void enableDynamicColor(bool enable) {
    _dynamicColorNotifier.value = enable;
    _prefs.dynamicColor = enable;
  }
}

class _DynamicColorProvider extends StatelessWidget {
  final bool useDynamicColor;
  final Brightness themeBrightness;
  final Widget Function(BuildContext context, Color? primaryColor) builder;

  const _DynamicColorProvider({
    required this.useDynamicColor,
    required this.themeBrightness,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        late final DynamicColorState state;
        late final Color? dynamicPrimaryColor;
        if (lightDynamic != null && darkDynamic != null) {
          if (useDynamicColor) {
            dynamicPrimaryColor =
                (themeBrightness == Brightness.light ? lightDynamic : darkDynamic).primary;
            state = DynamicColorState.enabled;
          } else {
            dynamicPrimaryColor = null;
            state = DynamicColorState.disabled;
          }
        } else {
          dynamicPrimaryColor = null;
          state = DynamicColorState.unavailable;
        }
        return InheritedWidgetBase<DynamicColorState>(
          data: state,
          child: builder(context, dynamicPrimaryColor),
        );
      },
    );
  }
}

class _ThemeDataProvider extends StatelessWidget {
  final Color primaryColor;
  final Brightness brightness;
  final Widget child;

  const _ThemeDataProvider({
    required this.primaryColor,
    required this.brightness,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetBase<ThemeData>(
      data: _themeFromColorScheme(_colorSchemeFromColor()),
      child: child,
    );
  }

  ThemeData _themeFromColorScheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      primaryColor: primaryColor,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        elevation: 4,
        color: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
      ),
      cardTheme: CardTheme(
        clipBehavior: Clip.antiAlias,
        color: scheme.surface,
        elevation: 4,
        margin: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.borderRadiusL)),
        surfaceTintColor: scheme.surfaceTint,
      ),
      dialogBackgroundColor: scheme.surface,
      dialogTheme: DialogTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
        elevation: 6,
      ),
      dividerColor: scheme.outlineVariant,
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: 0,
      ),
      listTileTheme: ListTileThemeData(
        style: ListTileStyle.list,
        iconColor: scheme.onSurface,
        textColor: scheme.onSurface,
      ),
      scaffoldBackgroundColor: scheme.surface,
    );
  }

  ColorScheme _colorSchemeFromColor() {
    final scheme = brightness == Brightness.light
        ? Scheme.light(primaryColor.value)
        : Scheme.dark(primaryColor.value);

    return ColorScheme(
      brightness: brightness,
      background: Color(scheme.background),
      error: Color(scheme.error),
      errorContainer: Color(scheme.errorContainer),
      onBackground: Color(scheme.onBackground),
      onError: Color(scheme.onError),
      onErrorContainer: Color(scheme.onErrorContainer),
      primary: Color(scheme.primary),
      onPrimary: Color(scheme.onPrimary),
      primaryContainer: Color(scheme.primaryContainer),
      onPrimaryContainer: Color(scheme.onPrimaryContainer),
      secondary: Color(scheme.secondary),
      onSecondary: Color(scheme.onSecondary),
      surface: Color.alphaBlend(
        Color(scheme.primary).withOpacity(0.05),
        Color(scheme.background),
      ),
      onSurface: Color(scheme.onSurface),
      surfaceVariant: Color.alphaBlend(
        Color(scheme.primary).withOpacity(0.5),
        Color(scheme.background),
      ),
      onSurfaceVariant: Color(scheme.onSurfaceVariant),
      outline: Color(scheme.outline),
      outlineVariant: Color(scheme.outlineVariant),
    );
  }
}
