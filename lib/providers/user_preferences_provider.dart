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
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class UserPreferencesProvider extends StatefulWidget {
  final Widget child;

  const UserPreferencesProvider({required this.child, super.key});

  static _UserPreferencesProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<_UserPreferencesProviderState>()!;
  }

  static Brightness brightnessOf(BuildContext context) {
    return _inheritFrom(context, _ListenableAspect.brightness).brightness;
  }

  static DynamicColorState dynamicColorStateOf(BuildContext context) {
    return _inheritFrom(context, _ListenableAspect.dynamicColorState).dynamicColorState;
  }

  static EvSourceType evSourceTypeOf(BuildContext context) {
    return _inheritFrom(context, _ListenableAspect.evSourceType).evSourceType;
  }

  static SupportedLocale localeOf(BuildContext context) {
    return _inheritFrom(context, _ListenableAspect.locale).locale;
  }

  static MeteringScreenLayoutConfig meteringScreenConfigOf(BuildContext context) {
    return context.findAncestorWidgetOfExactType<_MeteringScreenLayoutModel>()!.data;
  }

  static bool meteringScreenFeatureOf(BuildContext context, MeteringScreenLayoutFeature feature) {
    return InheritedModel.inheritFrom<_MeteringScreenLayoutModel>(context, aspect: feature)!
        .data[feature]!;
  }

  static Color primaryColorOf(BuildContext context) {
    return _inheritFrom(context, _ListenableAspect.primaryColor).primaryColor;
  }

  static StopType stopTypeOf(BuildContext context) {
    return _inheritFrom(context, _ListenableAspect.stopType).stopType;
  }

  static ThemeType themeTypeOf(BuildContext context) {
    return _inheritFrom(context, _ListenableAspect.themeType).themeType;
  }

  static _EnumsModel _inheritFrom(
    BuildContext context,
    _ListenableAspect aspect,
  ) {
    return InheritedModel.inheritFrom<_EnumsModel>(context, aspect: aspect)!;
  }

  @override
  State<UserPreferencesProvider> createState() => _UserPreferencesProviderState();
}

class _UserPreferencesProviderState extends State<UserPreferencesProvider>
    with WidgetsBindingObserver {
  UserPreferencesService get userPreferencesService =>
      ServicesProvider.userPreferencesServiceOf(context);

  late bool dynamicColor = userPreferencesService.dynamicColor;
  late EvSourceType evSourceType;
  late final MeteringScreenLayoutConfig meteringScreenLayout =
      ServicesProvider.userPreferencesServiceOf(context).meteringScreenLayout;
  late Color primaryColor = userPreferencesService.primaryColor;
  late StopType stopType = userPreferencesService.stopType;
  late SupportedLocale locale = userPreferencesService.locale;
  late ThemeType themeType = userPreferencesService.themeType;

  @override
  void initState() {
    super.initState();
    evSourceType = ServicesProvider.userPreferencesServiceOf(context).evSourceType;
    evSourceType = evSourceType == EvSourceType.sensor &&
            !ServicesProvider.environmentOf(context).hasLightSensor
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
        return _EnumsModel(
          brightness: _themeBrightness,
          dynamicColorState: state,
          evSourceType: evSourceType,
          locale: locale,
          primaryColor: dynamicPrimaryColor ?? primaryColor,
          stopType: stopType,
          themeType: themeType,
          child: _MeteringScreenLayoutModel(
            data: meteringScreenLayout,
            child: widget.child,
          ),
        );
      },
    );
  }

  void enableDynamicColor(bool enable) {
    setState(() {
      dynamicColor = enable;
    });
    ServicesProvider.userPreferencesServiceOf(context).dynamicColor = enable;
  }

  void toggleEvSourceType() {
    if (!ServicesProvider.environmentOf(context).hasLightSensor) {
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
    ServicesProvider.userPreferencesServiceOf(context).evSourceType = evSourceType;
  }

  void setLocale(SupportedLocale locale) {
    S.load(Locale(locale.intlName)).then((value) {
      setState(() {
        this.locale = locale;
      });
      ServicesProvider.userPreferencesServiceOf(context).locale = locale;
    });
  }

  void setMeteringScreenLayout(MeteringScreenLayoutConfig config) {
    setState(() {
      config.forEach((key, value) {
        meteringScreenLayout.update(
          key,
          (_) => value,
          ifAbsent: () => value,
        );
      });
    });
    ServicesProvider.userPreferencesServiceOf(context).meteringScreenLayout = meteringScreenLayout;
  }

  void setPrimaryColor(Color primaryColor) {
    setState(() {
      this.primaryColor = primaryColor;
    });
    ServicesProvider.userPreferencesServiceOf(context).primaryColor = primaryColor;
  }

  void setStopType(StopType stopType) {
    setState(() {
      this.stopType = stopType;
    });
    ServicesProvider.userPreferencesServiceOf(context).stopType = stopType;
  }

  void setThemeType(ThemeType themeType) {
    setState(() {
      this.themeType = themeType;
    });
    ServicesProvider.userPreferencesServiceOf(context).themeType = themeType;
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
  brightness,
  dynamicColorState,
  evSourceType,
  locale,
  primaryColor,
  stopType,
  themeType,
}

class _EnumsModel extends InheritedModel<_ListenableAspect> {
  final Brightness brightness;
  final DynamicColorState dynamicColorState;
  final EvSourceType evSourceType;
  final SupportedLocale locale;
  final Color primaryColor;
  final StopType stopType;
  final ThemeType themeType;

  const _EnumsModel({
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
  bool updateShouldNotify(_EnumsModel oldWidget) {
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
    _EnumsModel oldWidget,
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
