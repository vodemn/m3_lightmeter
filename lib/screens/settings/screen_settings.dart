import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/haptics/provider_list_tile_haptics.dart';
import 'components/widget_list_tile_fractional_stops.dart';
import 'components/widget_list_tile_theme_type.dart';
import 'components/widget_label_version.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
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
                  const HapticsListTileProvider(),
                  const ThemeTypeListTile(),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [VersionLabel()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
