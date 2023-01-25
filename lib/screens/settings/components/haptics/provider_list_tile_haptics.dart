import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';

import 'bloc_list_tile_haptics.dart';
import 'widget_list_tile_haptics.dart';

class HapticsListTileProvider extends StatelessWidget {
  const HapticsListTileProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HapticsListTileBloc(context.read<SettingsInteractor>()),
      child: const HapticsListTile(),
    );
  }
}
