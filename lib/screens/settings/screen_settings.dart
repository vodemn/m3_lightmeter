import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/haptics/provider_list_tile_haptics.dart';
import 'components/source_code/widget_list_tile_source_code.dart';
import 'components/version/widget_list_tile_version.dart';
import 'components/widget_list_tile_fractional_stops.dart';
import 'components/theme/widget_settings_theme.dart';
import 'components/widget_label_version.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  _Section(
                    title: S.of(context).theme,
                    children: [
                      const StopTypeListTile(),
                    ],
                  ),
                  _Section(
                    title: S.of(context).theme,
                    children: [
                      const HapticsListTileProvider(),
                    ],
                  ),
                  _Section(
                    title: S.of(context).theme,
                    children: [
                      const ThemeSettings(),
                    ],
                  ),
                  _Section(
                    title: S.of(context).about,
                    children: [
                      const SourceCodeListTile(),
                      const VersionListTile(),
                    ],
                  ),
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

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimens.paddingM,
        0,
        Dimens.paddingM,
        Dimens.paddingM,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(Dimens.borderRadiusL),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: Dimens.paddingM),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
