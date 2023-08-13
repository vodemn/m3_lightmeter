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
        ServicesProvider.of(context).userPreferencesService,
        ServicesProvider.of(context).caffeineService,
        ServicesProvider.of(context).hapticsService,
        ServicesProvider.of(context).volumeEventsService,
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
