import 'package:flutter/material.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';
import 'package:lightmeter/providers/service_provider.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:lightmeter/utils/inherited_generics.dart';

class SettingsFlow extends StatelessWidget {
  const SettingsFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetBase<SettingsInteractor>(
      data: SettingsInteractor(
        ServiceProvider.userPreferencesServiceOf(context),
        ServiceProvider.caffeineServiceOf(context),
        ServiceProvider.hapticsServiceOf(context),
        ServiceProvider.volumeEventsServiceOf(context),
      ),
      child: const SettingsScreen(),
    );
  }
}
