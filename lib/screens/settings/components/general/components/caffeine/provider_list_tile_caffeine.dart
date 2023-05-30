import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';

import 'package:lightmeter/screens/settings/components/general/components/caffeine/bloc_list_tile_caffeine.dart';
import 'package:lightmeter/screens/settings/components/general/components/caffeine/widget_list_tile_caffeine.dart';
import 'package:lightmeter/utils/inherited_generics.dart';

class CaffeineListTileProvider extends StatelessWidget {
  const CaffeineListTileProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CaffeineListTileBloc(context.get<SettingsInteractor>()),
      child: const CaffeineListTile(),
    );
  }
}
