import 'package:flutter/material.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:lightmeter/utils/inherited_generics.dart';

class SettingsFlow extends StatelessWidget {
  const SettingsFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetBase<SettingsInteractor>(
      data: SettingsInteractor(
        context.get<UserPreferencesService>(),
        context.get<CaffeineService>(),
        context.get<HapticsService>(),
      ),
      child: const SettingsScreen(),
    );
  }
}
