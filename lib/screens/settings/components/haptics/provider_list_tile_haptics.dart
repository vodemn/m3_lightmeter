import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/interactors/haptics_interactor.dart';
import 'package:provider/provider.dart';

import 'bloc_list_tile_haptics.dart';
import 'widget_list_tile_haptics.dart';

class HapticsListTileProvider extends StatelessWidget {
  const HapticsListTileProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => HapticsInteractor(
        context.read<UserPreferencesService>(),
        context.read<HapticsService>(),
      ),
      child: BlocProvider(
        create: (context) => HapticsListTileBloc(
          context.read<HapticsInteractor>()
        ),
        child: const HapticsListTile(),
      ),
    );
  }
}
