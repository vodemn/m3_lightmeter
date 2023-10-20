import 'package:flutter/material.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/environment.dart';

// coverage:ignore-start
class ServicesProvider extends InheritedWidget {
  final CaffeineService caffeineService;
  final Environment environment;
  final HapticsService hapticsService;
  final LightSensorService lightSensorService;
  final PermissionsService permissionsService;
  final UserPreferencesService userPreferencesService;
  final VolumeEventsService volumeEventsService;

  const ServicesProvider({
    required this.caffeineService,
    required this.environment,
    required this.hapticsService,
    required this.lightSensorService,
    required this.permissionsService,
    required this.userPreferencesService,
    required this.volumeEventsService,
    required super.child,
  });

  static ServicesProvider of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<ServicesProvider>()!;
  }

  @override
  bool updateShouldNotify(ServicesProvider oldWidget) => false;
}
// coverage:ignore-end
