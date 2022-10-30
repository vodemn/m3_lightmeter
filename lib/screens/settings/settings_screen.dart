import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/caffeine_tile.dart';
import 'components/haptics_tile.dart';

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
            leading: null,
            expandedHeight: 160.0,
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
                onPressed: () {},
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          SliverList(delegate: SliverChildListDelegate([CaffeineListTile(), HapticsListTile()])),
        ],
      ),
    );
  }
}
