import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/fractional_stops_tile.dart';
import 'components/theme_type_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: Dimens.grid168,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.all(Dimens.paddingM),
              title: Text(
                S.of(context).settings,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 24),
              ),
            ),
            actions: [
              IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const StopTypeListTile(),
                // const CaffeineListTile(),
                // const HapticsListTile(),
                const ThemeTypeListTile(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
