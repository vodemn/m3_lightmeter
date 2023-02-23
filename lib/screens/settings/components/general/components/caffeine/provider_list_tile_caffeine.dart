import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';

import 'bloc_list_tile_caffeine.dart';
import 'widget_list_tile_caffeine.dart';

class CaffeineListTileProvider extends StatelessWidget {
  const CaffeineListTileProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CaffeineListTileBloc(context.read<SettingsInteractor>()),
      child: const CaffeineListTile(),
    );
  }
}
