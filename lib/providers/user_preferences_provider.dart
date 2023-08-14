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
    return _inheritFromEnumsModel(context, _Aspect.dynamicColorState).dynamicColorState;
  }

  static EvSourceType evSourceTypeOf(BuildContext context) {
    return _inheritFromEnumsModel(context, _Aspect.evSourceType).evSourceType;
  }

  static SupportedLocale localeOf(BuildContext context) {
    return _inheritFromEnumsModel(context, _Aspect.locale).locale;
  }

  static MeteringScreenLayoutConfig meteringScreenConfigOf(BuildContext context) {
    return context.findAncestorWidgetOfExactType<_MeteringScreenLayoutModel>()!.data;
  }

  static bool meteringScreenFeatureOf(BuildContext context, MeteringScreenLayoutFeature feature) {
    return InheritedModel.inheritFrom<_MeteringScreenLayoutModel>(context, aspect: feature)!
        .data[feature]!;
  }

  static StopType stopTypeOf(BuildContext context) {
    return _inheritFromEnumsModel(context, _Aspect.stopType).stopType;
  }

  static ThemeData themeOf(BuildContext context) {
    return _inheritFromEnumsModel(context, _Aspect.theme).theme;
  }

  static ThemeType themeTypeOf(BuildContext context) {
    return _inheritFromEnumsModel(context, _Aspect.themeType).themeType;
  }

  static _UserPreferencesModel _inheritFromEnumsModel(
    BuildContext context,
    _Aspect aspect,
  ) {
    return InheritedModel.inheritFrom<_UserPreferencesModel>(context, aspect: aspect)!;
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
        return _UserPreferencesModel(
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

enum _Aspect {
  dynamicColorState,
  evSourceType,
  locale,
  stopType,
  theme,
  themeType,
}

class _UserPreferencesModel extends InheritedModel<_Aspect> {
  final DynamicColorState dynamicColorState;
  final EvSourceType evSourceType;
  final SupportedLocale locale;
  final StopType stopType;
  final ThemeType themeType;

  final Brightness _brightness;
  final Color _primaryColor;

  const _UserPreferencesModel({
    required Brightness brightness,
    required this.dynamicColorState,
    required this.evSourceType,
    required this.locale,
    required Color primaryColor,
    required this.stopType,
    required this.themeType,
    required super.child,
  })  : _brightness = brightness,
        _primaryColor = primaryColor;

  ThemeData get theme => themeFrom(_primaryColor, _brightness);

  @override
  bool updateShouldNotify(_UserPreferencesModel oldWidget) {
    return _brightness != oldWidget._brightness ||
        dynamicColorState != oldWidget.dynamicColorState ||
        evSourceType != oldWidget.evSourceType ||
        locale != oldWidget.locale ||
        _primaryColor != oldWidget._primaryColor ||
        stopType != oldWidget.stopType ||
        themeType != oldWidget.themeType;
  }

  @override
  bool updateShouldNotifyDependent(
    _UserPreferencesModel oldWidget,
    Set<_Aspect> dependencies,
  ) {
    return (dependencies.contains(_Aspect.dynamicColorState) &&
            dynamicColorState != oldWidget.dynamicColorState) ||
        (dependencies.contains(_Aspect.evSourceType) && evSourceType != oldWidget.evSourceType) ||
        (dependencies.contains(_Aspect.locale) && locale != oldWidget.locale) ||
        (dependencies.contains(_Aspect.stopType) && stopType != oldWidget.stopType) ||
        (dependencies.contains(_Aspect.theme) &&
            (_brightness != oldWidget._brightness || _primaryColor != oldWidget._primaryColor)) ||
        (dependencies.contains(_Aspect.themeType) && themeType != oldWidget.themeType);
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
