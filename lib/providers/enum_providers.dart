import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/service_providers.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

enum _ListenableAspect {
  evSourceType,
  locale,
  stopType,
  themeType,
}

class EnumProviders extends StatefulWidget {
  final Widget child;

  const EnumProviders({required this.child, super.key});

  static _EnumProvidersState of(BuildContext context) {
    return context.findAncestorStateOfType<_EnumProvidersState>()!;
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

class _EnumProvidersState extends State<EnumProviders> {
  UserPreferencesService get userPreferencesService =>
      ServiceProviders.userPreferencesServiceOf(context);

  late EvSourceType evSourceType;
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
  }

  @override
  Widget build(BuildContext context) {
    return _EnumProvidersModel(
      evSourceType: evSourceType,
      locale: locale,
      stopType: stopType,
      themeType: themeType,
      child: widget.child,
    );
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
}

class _EnumProvidersModel extends InheritedModel<_ListenableAspect> {
  final EvSourceType evSourceType;
  final SupportedLocale locale;
  final StopType stopType;
  final ThemeType themeType;

  const _EnumProvidersModel({
    required this.evSourceType,
    required this.locale,
    required this.stopType,
    required this.themeType,
    required super.child,
  });

  @override
  bool updateShouldNotify(_EnumProvidersModel oldWidget) {
    return evSourceType != oldWidget.evSourceType ||
        locale != oldWidget.locale ||
        stopType != oldWidget.stopType ||
        themeType != oldWidget.themeType;
  }

  @override
  bool updateShouldNotifyDependent(
    _EnumProvidersModel oldWidget,
    Set<_ListenableAspect> dependencies,
  ) {
    return (evSourceType != oldWidget.evSourceType &&
            dependencies.contains(_ListenableAspect.evSourceType)) ||
        (locale != oldWidget.locale && dependencies.contains(_ListenableAspect.locale)) ||
        (stopType != oldWidget.stopType && dependencies.contains(_ListenableAspect.stopType)) ||
        (themeType != oldWidget.themeType && dependencies.contains(_ListenableAspect.themeType));
  }
}
