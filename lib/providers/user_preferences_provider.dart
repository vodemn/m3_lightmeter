import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class UserPreferencesProvider extends StatefulWidget {
  final Widget child;

  const UserPreferencesProvider({required this.child, super.key});

  static _UserPreferencesProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<_UserPreferencesProviderState>()!;
  }

  static DynamicColorState dynamicColorStateOf(BuildContext context) {
    return _inheritFromThemeModel(context, _ThemeAspect.dynamicColorState).dynamicColorState;
  }

  static EvSourceType evSourceTypeOf(BuildContext context) {
    return _inheritFromEnumsModel(context, _ListenableAspect.evSourceType).evSourceType;
  }

  static SupportedLocale localeOf(BuildContext context) {
    return _inheritFromEnumsModel(context, _ListenableAspect.locale).locale;
  }

  static MeteringScreenLayoutConfig meteringScreenConfigOf(BuildContext context) {
    return context.findAncestorWidgetOfExactType<_MeteringScreenLayoutModel>()!.data;
  }

  static bool meteringScreenFeatureOf(BuildContext context, MeteringScreenLayoutFeature feature) {
    return InheritedModel.inheritFrom<_MeteringScreenLayoutModel>(context, aspect: feature)!
        .data[feature]!;
  }

  static StopType stopTypeOf(BuildContext context) {
    return _inheritFromEnumsModel(context, _ListenableAspect.stopType).stopType;
  }

  static ThemeData themeOf(BuildContext context) {
    return _inheritFromThemeModel(context, _ThemeAspect.theme).theme;
  }

  static ThemeType themeTypeOf(BuildContext context) {
    return _inheritFromThemeModel(context, _ThemeAspect.themeType).themeType;
  }

  static _EnumsModel _inheritFromEnumsModel(BuildContext context, _ListenableAspect aspect) {
    return InheritedModel.inheritFrom<_EnumsModel>(context, aspect: aspect)!;
  }

  static _ThemeModel _inheritFromThemeModel(BuildContext context, _ThemeAspect aspect) {
    return InheritedModel.inheritFrom<_ThemeModel>(context, aspect: aspect)!;
  }

  @override
  State<UserPreferencesProvider> createState() => _UserPreferencesProviderState();
}

class _UserPreferencesProviderState extends State<UserPreferencesProvider>
    with WidgetsBindingObserver {
  UserPreferencesService get userPreferencesService =>
      ServicesProvider.of(context).userPreferencesService;

  late bool dynamicColor = userPreferencesService.dynamicColor;
  late EvSourceType evSourceType;
  late MeteringScreenLayoutConfig meteringScreenLayout =
      userPreferencesService.meteringScreenLayout;
  late Color primaryColor = userPreferencesService.primaryColor;
  late StopType stopType = userPreferencesService.stopType;
  late SupportedLocale locale = userPreferencesService.locale;
  late ThemeType themeType = userPreferencesService.themeType;

  @override
  void initState() {
    super.initState();
    evSourceType = userPreferencesService.evSourceType;
    evSourceType = evSourceType == EvSourceType.sensor &&
            !ServicesProvider.of(context).environment.hasLightSensor
        ? EvSourceType.camera
        : evSourceType;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        late final DynamicColorState state;
        late final Color? dynamicPrimaryColor;
        if (lightDynamic != null && darkDynamic != null) {
          if (dynamicColor) {
            dynamicPrimaryColor =
                (_themeBrightness == Brightness.light ? lightDynamic : darkDynamic).primary;
            state = DynamicColorState.enabled;
          } else {
            dynamicPrimaryColor = null;
            state = DynamicColorState.disabled;
          }
        } else {
          dynamicPrimaryColor = null;
          state = DynamicColorState.unavailable;
        }
        return _ThemeModel(
          brightness: _themeBrightness,
          dynamicColorState: state,
          primaryColor: dynamicPrimaryColor ?? primaryColor,
          themeType: themeType,
          child: _EnumsModel(
            evSourceType: evSourceType,
            locale: locale,
            stopType: stopType,
            child: _MeteringScreenLayoutModel(
              data: meteringScreenLayout,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }

  void enableDynamicColor(bool enable) {
    setState(() {
      dynamicColor = enable;
    });
    userPreferencesService.dynamicColor = enable;
  }

  void toggleEvSourceType() {
    if (!ServicesProvider.of(context).environment.hasLightSensor) {
      return;
    }
    setState(() {
      switch (evSourceType) {
        case EvSourceType.camera:
          evSourceType = EvSourceType.sensor;
        case EvSourceType.sensor:
          evSourceType = EvSourceType.camera;
      }
    });
    userPreferencesService.evSourceType = evSourceType;
  }

  void setLocale(SupportedLocale locale) {
    S.load(Locale(locale.intlName)).then((value) {
      setState(() {
        this.locale = locale;
      });
      userPreferencesService.locale = locale;
    });
  }

  void setMeteringScreenLayout(MeteringScreenLayoutConfig config) {
    setState(() {
      meteringScreenLayout = config;
    });
    userPreferencesService.meteringScreenLayout = meteringScreenLayout;
  }

  void setPrimaryColor(Color primaryColor) {
    setState(() {
      this.primaryColor = primaryColor;
    });
    userPreferencesService.primaryColor = primaryColor;
  }

  void setStopType(StopType stopType) {
    setState(() {
      this.stopType = stopType;
    });
    userPreferencesService.stopType = stopType;
  }

  void setThemeType(ThemeType themeType) {
    setState(() {
      this.themeType = themeType;
    });
    userPreferencesService.themeType = themeType;
  }

  Brightness get _themeBrightness {
    switch (themeType) {
      case ThemeType.light:
        return Brightness.light;
      case ThemeType.dark:
        return Brightness.dark;
      case ThemeType.systemDefault:
        return SchedulerBinding.instance.platformDispatcher.platformBrightness;
    }
  }
}

enum _ListenableAspect {
  evSourceType,
  locale,
  stopType,
}

class _EnumsModel extends InheritedModel<_ListenableAspect> {
  final EvSourceType evSourceType;
  final SupportedLocale locale;
  final StopType stopType;

  const _EnumsModel({
    required this.evSourceType,
    required this.locale,
    required this.stopType,
    required super.child,
  });

  @override
  bool updateShouldNotify(_EnumsModel oldWidget) {
    return evSourceType != oldWidget.evSourceType ||
        locale != oldWidget.locale ||
        stopType != oldWidget.stopType;
  }

  @override
  bool updateShouldNotifyDependent(
    _EnumsModel oldWidget,
    Set<_ListenableAspect> dependencies,
  ) {
    return (evSourceType != oldWidget.evSourceType &&
            dependencies.contains(_ListenableAspect.evSourceType)) ||
        (locale != oldWidget.locale && dependencies.contains(_ListenableAspect.locale)) ||
        (stopType != oldWidget.stopType && dependencies.contains(_ListenableAspect.stopType));
  }
}

enum _ThemeAspect {
  dynamicColorState,
  theme,
  themeType,
}

class _ThemeModel extends InheritedModel<_ThemeAspect> {
  final DynamicColorState dynamicColorState;
  final ThemeType themeType;

  final Brightness _brightness;
  final Color _primaryColor;

  const _ThemeModel({
    required Brightness brightness,
    required this.dynamicColorState,
    required Color primaryColor,
    required this.themeType,
    required super.child,
  })  : _brightness = brightness,
        _primaryColor = primaryColor;

  ThemeData get theme => themeFrom(_primaryColor, _brightness);

  @override
  bool updateShouldNotify(_ThemeModel oldWidget) {
    return _brightness != oldWidget._brightness ||
        dynamicColorState != oldWidget.dynamicColorState ||
        _primaryColor != oldWidget._primaryColor ||
        themeType != oldWidget.themeType;
  }

  @override
  bool updateShouldNotifyDependent(
    _ThemeModel oldWidget,
    Set<_ThemeAspect> dependencies,
  ) {
    return (dependencies.contains(_ThemeAspect.theme) &&
            (_brightness != oldWidget._brightness || _primaryColor != oldWidget._primaryColor)) ||
        (dependencies.contains(_ThemeAspect.dynamicColorState) &&
            dynamicColorState != oldWidget.dynamicColorState) ||
        (dependencies.contains(_ThemeAspect.themeType) && themeType != oldWidget.themeType);
  }
}

class _MeteringScreenLayoutModel extends InheritedModel<MeteringScreenLayoutFeature> {
  final Map<MeteringScreenLayoutFeature, bool> data;

  const _MeteringScreenLayoutModel({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(_MeteringScreenLayoutModel oldWidget) => oldWidget.data != data;

  @override
  bool updateShouldNotifyDependent(
    _MeteringScreenLayoutModel oldWidget,
    Set<MeteringScreenLayoutFeature> dependencies,
  ) {
    for (final dependecy in dependencies) {
      if (oldWidget.data[dependecy] != data[dependecy]) {
        return true;
      }
    }
    return false;
  }
}
