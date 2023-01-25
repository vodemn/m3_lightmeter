import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:provider/provider.dart';

class SettingsFlow extends StatelessWidget {
  const SettingsFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => SettingsInteractor(
        context.read<UserPreferencesService>(),
        context.read<HapticsService>(),
      ),
      child: const SettingsScreen(),
    );
  }
}
