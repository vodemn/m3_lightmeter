import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lightmeter/screens/settings/components/general/components/timer/bloc_list_tile_timer.dart';
import 'package:lightmeter/screens/settings/components/general/components/timer/widget_list_tile_timer.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';

class TimerListTileProvider extends StatelessWidget {
  const TimerListTileProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerListTileBloc(SettingsInteractorProvider.of(context)),
      child: const TimerListTile(),
    );
  }
}
