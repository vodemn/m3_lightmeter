import 'package:flutter/material.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/environment.dart';

class ServiceProvider extends InheritedWidget {
  final CaffeineService caffeineService;
  final Environment environment;
  final HapticsService hapticsService;
  final LightSensorService lightSensorService;
  final PermissionsService permissionsService;
  final UserPreferencesService userPreferencesService;
  final VolumeEventsService volumeEventsService;

  const ServiceProvider({
    required this.caffeineService,
    required this.environment,
    required this.hapticsService,
    required this.lightSensorService,
    required this.permissionsService,
    required this.userPreferencesService,
    required this.volumeEventsService,
    required super.child,
  });

  static CaffeineService caffeineServiceOf(BuildContext context) {
    return ServiceProvider._of(context).caffeineService;
  }

  static Environment environmentOf(BuildContext context) {
    return ServiceProvider._of(context).environment;
  }

  static HapticsService hapticsServiceOf(BuildContext context) {
    return ServiceProvider._of(context).hapticsService;
  }

  static LightSensorService lightSensorServiceOf(BuildContext context) {
    return ServiceProvider._of(context).lightSensorService;
  }

  static PermissionsService permissionsServiceOf(BuildContext context) {
    return ServiceProvider._of(context).permissionsService;
  }

  static UserPreferencesService userPreferencesServiceOf(BuildContext context) {
    return ServiceProvider._of(context).userPreferencesService;
  }

  static VolumeEventsService volumeEventsServiceOf(BuildContext context) {
    return ServiceProvider._of(context).volumeEventsService;
  }

  static ServiceProvider _of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<ServiceProvider>()!;
  }

  @override
  bool updateShouldNotify(ServiceProvider oldWidget) => false;
}
