import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

import 'package:lightmeter/screens/settings/components/general/components/caffeine/bloc_list_tile_caffeine.dart';

class CaffeineListTile extends StatelessWidget {
  const CaffeineListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaffeineListTileBloc, bool>(
      builder: (context, state) => SwitchListTile(
        secondary: const Icon(Icons.screen_lock_portrait),
        title: Text(S.of(context).keepScreenOn),
        value: state,
        onChanged: context.read<CaffeineListTileBloc>().onCaffeineChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
      ),
    );
  }
}
