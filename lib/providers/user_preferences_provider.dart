import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lightmeter/data/models/camera_feature.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/utils/map_model.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class UserPreferencesProvider extends StatefulWidget {
  final bool hasLightSensor;
  final UserPreferencesService userPreferencesService;
  final Widget child;

  const UserPreferencesProvider({
    required this.hasLightSensor,
    required this.userPreferencesService,
    required this.child,
    super.key,
  });

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
    return InheritedModel.inheritFrom<_MeteringScreenLayoutModel>(context, aspect: feature)!.data[feature]!;
  }

  static StopType stopTypeOf(BuildContext context) {
    return _inheritFromEnumsModel(context, _Aspect.stopType).stopType;
  }

  static bool showEv100Of(BuildContext context) {
    return _inheritFromEnumsModel(context, _Aspect.showEv100).showEv100;
  }

  static CameraFeaturesConfig cameraConfigOf(BuildContext context) {
    return context.findAncestorWidgetOfExactType<_CameraFeaturesModel>()!.data;
  }

  static bool cameraFeatureOf(BuildContext context, CameraFeature feature) {
    return InheritedModel.inheritFrom<_CameraFeaturesModel>(context, aspect: feature)!.data[feature]!;
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

class _UserPreferencesProviderState extends State<UserPreferencesProvider> with WidgetsBindingObserver {
  late EvSourceType _evSourceType;
  late StopType _stopType = widget.userPreferencesService.stopType;
  late bool _showEv100 = widget.userPreferencesService.showEv100;
  late MeteringScreenLayoutConfig _meteringScreenLayout = widget.userPreferencesService.meteringScreenLayout;
  late CameraFeaturesConfig _cameraFeatures = widget.userPreferencesService.cameraFeatures;
  late SupportedLocale _locale = widget.userPreferencesService.locale;
  late ThemeType _themeType = widget.userPreferencesService.themeType;
  late Color _primaryColor = widget.userPreferencesService.primaryColor;
  late bool _dynamicColor = widget.userPreferencesService.dynamicColor;

  @override
  void initState() {
    super.initState();
    _evSourceType = widget.userPreferencesService.evSourceType;
    _evSourceType =
        _evSourceType == EvSourceType.sensor && !widget.hasLightSensor ? EvSourceType.camera : _evSourceType;
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
          if (_dynamicColor) {
            dynamicPrimaryColor = (_themeBrightness == Brightness.light ? lightDynamic : darkDynamic).primary;
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
          evSourceType: _evSourceType,
          locale: _locale,
          primaryColor: dynamicPrimaryColor ?? _primaryColor,
          showEv100: _showEv100,
          stopType: _stopType,
          themeType: _themeType,
          child: _MeteringScreenLayoutModel(
            data: _meteringScreenLayout,
            child: _CameraFeaturesModel(
              data: _cameraFeatures,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }

  void enableDynamicColor(bool enable) {
    setState(() {
      _dynamicColor = enable;
    });
    widget.userPreferencesService.dynamicColor = enable;
  }

  void toggleEvSourceType() {
    if (!widget.hasLightSensor) {
      return;
    }
    setState(() {
      switch (_evSourceType) {
        case EvSourceType.camera:
          _evSourceType = EvSourceType.sensor;
        case EvSourceType.sensor:
          _evSourceType = EvSourceType.camera;
      }
    });
    widget.userPreferencesService.evSourceType = _evSourceType;
  }

  void setLocale(SupportedLocale locale) {
    S.load(Locale(locale.intlName)).then((value) {
      setState(() {
        _locale = locale;
      });
      widget.userPreferencesService.locale = locale;
    });
  }

  void setMeteringScreenLayout(MeteringScreenLayoutConfig config) {
    setState(() {
      _meteringScreenLayout = config;
    });
    widget.userPreferencesService.meteringScreenLayout = _meteringScreenLayout;
  }

  void setCameraFeature(CameraFeaturesConfig config) {
    setState(() {
      _cameraFeatures = config;
    });
    widget.userPreferencesService.cameraFeatures = _cameraFeatures;
  }

  void setPrimaryColor(Color primaryColor) {
    setState(() {
      _primaryColor = primaryColor;
    });
    widget.userPreferencesService.primaryColor = primaryColor;
  }

  void toggleShowEV100() {
    setState(() {
      _showEv100 = !_showEv100;
    });
    widget.userPreferencesService.showEv100 = _showEv100;
  }

  void setStopType(StopType stopType) {
    setState(() {
      _stopType = stopType;
    });
    widget.userPreferencesService.stopType = stopType;
  }

  void setThemeType(ThemeType themeType) {
    setState(() {
      _themeType = themeType;
    });
    widget.userPreferencesService.themeType = themeType;
  }

  Brightness get _themeBrightness {
    switch (_themeType) {
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
  showEv100,
  stopType,
  theme,
  themeType,
}

class _UserPreferencesModel extends InheritedModel<_Aspect> {
  final DynamicColorState dynamicColorState;
  final EvSourceType evSourceType;
  final SupportedLocale locale;
  final bool showEv100;
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
    required this.showEv100,
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
        showEv100 != oldWidget.showEv100 ||
        stopType != oldWidget.stopType ||
        themeType != oldWidget.themeType;
  }

  @override
  bool updateShouldNotifyDependent(
    _UserPreferencesModel oldWidget,
    Set<_Aspect> dependencies,
  ) {
    return (dependencies.contains(_Aspect.dynamicColorState) && dynamicColorState != oldWidget.dynamicColorState) ||
        (dependencies.contains(_Aspect.evSourceType) && evSourceType != oldWidget.evSourceType) ||
        (dependencies.contains(_Aspect.locale) && locale != oldWidget.locale) ||
        (dependencies.contains(_Aspect.showEv100) && showEv100 != oldWidget.showEv100) ||
        (dependencies.contains(_Aspect.stopType) && stopType != oldWidget.stopType) ||
        (dependencies.contains(_Aspect.theme) &&
            (_brightness != oldWidget._brightness || _primaryColor != oldWidget._primaryColor)) ||
        (dependencies.contains(_Aspect.themeType) && themeType != oldWidget.themeType);
  }
}

class _MeteringScreenLayoutModel extends MapModel<MeteringScreenLayoutFeature> {
  const _MeteringScreenLayoutModel({
    required super.data,
    required super.child,
  });
}

class _CameraFeaturesModel extends MapModel<CameraFeature> {
  const _CameraFeaturesModel({
    required super.data,
    required super.child,
  });
}
