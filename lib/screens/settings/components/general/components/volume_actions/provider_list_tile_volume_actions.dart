import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lightmeter/screens/settings/components/general/components/volume_actions/bloc_list_tile_volume_actions.dart';
import 'package:lightmeter/screens/settings/components/general/components/volume_actions/widget_list_tile_volume_actions.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';

class VolumeActionsListTileProvider extends StatelessWidget {
  const VolumeActionsListTileProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VolumeActionsListTileBloc(SettingsInteractorProvider.of(context)),
      child: const VolumeActionsListTile(),
    );
  }
}
