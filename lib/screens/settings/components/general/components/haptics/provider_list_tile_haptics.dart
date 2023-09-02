import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lightmeter/screens/settings/components/general/components/haptics/bloc_list_tile_haptics.dart';
import 'package:lightmeter/screens/settings/components/general/components/haptics/widget_list_tile_haptics.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';

class HapticsListTileProvider extends StatelessWidget {
  const HapticsListTileProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HapticsListTileBloc(SettingsInteractorProvider.of(context)),
      child: const HapticsListTile(),
    );
  }
}
