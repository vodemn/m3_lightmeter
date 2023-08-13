import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/service_providers.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

enum _ListenableAspect {
  brightness,
  dynamicColorState,
  evSourceType,
  locale,
  primaryColor,
  stopType,
  themeType,
}

class EnumProviders extends StatefulWidget {
  final Widget child;

  const EnumProviders({required this.child, super.key});

  static _EnumProvidersState of(BuildContext context) {
    return context.findAncestorStateOfType<_EnumProvidersState>()!;
  }

  static Brightness brightnessOf(BuildContext context) {
    return InheritedModel.inheritFrom<_EnumProvidersModel>(
      context,
      aspect: _ListenableAspect.brightness,
    )!
        .brightness;
  }

  static DynamicColorState dynamicColorStateOf(BuildContext context) {
    return InheritedModel.inheritFrom<_EnumProvidersModel>(
      context,
      aspect: _ListenableAspect.dynamicColorState,
    )!
        .dynamicColorState;
  }

  static EvSourceType evSourceTypeOf(BuildContext context) {
    return InheritedModel.inheritFrom<_EnumProvidersModel>(
      context,
      aspect: _ListenableAspect.evSourceType,
    )!
        .evSourceType;
  }

  static SupportedLocale localeOf(BuildContext context) {
    return InheritedModel.inheritFrom<_EnumProvidersModel>(
      context,
      aspect: _ListenableAspect.locale,
    )!
        .locale;
  }

  static Color primaryColorOf(BuildContext context) {
    return InheritedModel.inheritFrom<_EnumProvidersModel>(
      context,
      aspect: _ListenableAspect.primaryColor,
    )!
        .primaryColor;
  }

  static StopType stopTypeOf(BuildContext context) {
    return InheritedModel.inheritFrom<_EnumProvidersModel>(
      context,
      aspect: _ListenableAspect.stopType,
    )!
        .stopType;
  }

  static ThemeType themeTypeOf(BuildContext context) {
    return InheritedModel.inheritFrom<_EnumProvidersModel>(
      context,
      aspect: _ListenableAspect.themeType,
    )!
        .themeType;
  }

  @override
  State<EnumProviders> createState() => _EnumProvidersState();
}

class _EnumProvidersState extends State<EnumProviders> with WidgetsBindingObserver {
  UserPreferencesService get userPreferencesService =>
      ServiceProviders.userPreferencesServiceOf(context);

  late bool dynamicColor = userPreferencesService.dynamicColor;
  late EvSourceType evSourceType;
  late Color primaryColor = userPreferencesService.primaryColor;
  late StopType stopType = userPreferencesService.stopType;
  late SupportedLocale locale = userPreferencesService.locale;
  late ThemeType themeType = userPreferencesService.themeType;

  @override
  void initState() {
    super.initState();
    evSourceType = ServiceProviders.userPreferencesServiceOf(context).evSourceType;
    evSourceType = evSourceType == EvSourceType.sensor &&
            !ServiceProviders.environmentOf(context).hasLightSensor
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
        return _EnumProvidersModel(
          brightness: _themeBrightness,
          dynamicColorState: state,
          evSourceType: evSourceType,
          locale: locale,
          primaryColor: dynamicPrimaryColor ?? primaryColor,
          stopType: stopType,
          themeType: themeType,
          child: widget.child,
        );
      },
    );
  }

  void enableDynamicColor(bool enable) {
    setState(() {
      dynamicColor = enable;
    });
    ServiceProviders.userPreferencesServiceOf(context).dynamicColor = enable;
  }

  void toggleEvSourceType() {
    if (!ServiceProviders.environmentOf(context).hasLightSensor) {
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
    ServiceProviders.userPreferencesServiceOf(context).evSourceType = evSourceType;
  }

  void setLocale(SupportedLocale locale) {
    S.load(Locale(locale.intlName)).then((value) {
      setState(() {
        this.locale = locale;
      });
      ServiceProviders.userPreferencesServiceOf(context).locale = locale;
    });
  }

  void setPrimaryColor(Color primaryColor) {
    setState(() {
      this.primaryColor = primaryColor;
    });
    ServiceProviders.userPreferencesServiceOf(context).primaryColor = primaryColor;
  }

  void setStopType(StopType stopType) {
    setState(() {
      this.stopType = stopType;
    });
    ServiceProviders.userPreferencesServiceOf(context).stopType = stopType;
  }

  void setThemeType(ThemeType themeType) {
    setState(() {
      this.themeType = themeType;
    });
    ServiceProviders.userPreferencesServiceOf(context).themeType = themeType;
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

class _EnumProvidersModel extends InheritedModel<_ListenableAspect> {
  final Brightness brightness;
  final DynamicColorState dynamicColorState;
  final EvSourceType evSourceType;
  final SupportedLocale locale;
  final Color primaryColor;
  final StopType stopType;
  final ThemeType themeType;

  const _EnumProvidersModel({
    required this.brightness,
    required this.dynamicColorState,
    required this.evSourceType,
    required this.locale,
    required this.primaryColor,
    required this.stopType,
    required this.themeType,
    required super.child,
  });

  @override
  bool updateShouldNotify(_EnumProvidersModel oldWidget) {
    return brightness != oldWidget.brightness ||
        dynamicColorState != oldWidget.dynamicColorState ||
        evSourceType != oldWidget.evSourceType ||
        locale != oldWidget.locale ||
        primaryColor != oldWidget.primaryColor ||
        stopType != oldWidget.stopType ||
        themeType != oldWidget.themeType;
  }

  @override
  bool updateShouldNotifyDependent(
    _EnumProvidersModel oldWidget,
    Set<_ListenableAspect> dependencies,
  ) {
    return (brightness != oldWidget.brightness &&
            dependencies.contains(_ListenableAspect.brightness)) ||
        (dynamicColorState != oldWidget.dynamicColorState &&
            dependencies.contains(_ListenableAspect.dynamicColorState)) ||
        (evSourceType != oldWidget.evSourceType &&
            dependencies.contains(_ListenableAspect.evSourceType)) ||
        (locale != oldWidget.locale && dependencies.contains(_ListenableAspect.locale)) ||
        (primaryColor != oldWidget.primaryColor &&
            dependencies.contains(_ListenableAspect.primaryColor)) ||
        (stopType != oldWidget.stopType && dependencies.contains(_ListenableAspect.stopType)) ||
        (themeType != oldWidget.themeType && dependencies.contains(_ListenableAspect.themeType));
  }
}
