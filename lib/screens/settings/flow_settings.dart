import 'package:flutter/material.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';

class SettingsFlow extends StatelessWidget {
  const SettingsFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsInteractorProvider(
      data: SettingsInteractor(
        ServicesProvider.userPreferencesServiceOf(context),
        ServicesProvider.caffeineServiceOf(context),
        ServicesProvider.hapticsServiceOf(context),
        ServicesProvider.volumeEventsServiceOf(context),
      ),
      child: const SettingsScreen(),
    );
  }
}

class SettingsInteractorProvider extends InheritedWidget {
  final SettingsInteractor data;

  const SettingsInteractorProvider({
    required this.data,
    required super.child,
    super.key,
  });

  static SettingsInteractor of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<SettingsInteractorProvider>()!.data;
  }

  @override
  bool updateShouldNotify(SettingsInteractorProvider oldWidget) => false;
}
