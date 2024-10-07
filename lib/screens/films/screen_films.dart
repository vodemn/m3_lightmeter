import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/about/widget_settings_section_about.dart';
import 'package:lightmeter/screens/settings/components/general/widget_settings_section_general.dart';
import 'package:lightmeter/screens/settings/components/lightmeter_pro/widget_settings_section_lightmeter_pro.dart';
import 'package:lightmeter/screens/settings/components/metering/widget_settings_section_metering.dart';
import 'package:lightmeter/screens/settings/components/shared/expandable_section_list/components/expandable_section_list_item/widget_expandable_section_list_item.dart';
import 'package:lightmeter/screens/settings/components/shared/expandable_section_list/widget_expandable_section_list.dart';
import 'package:lightmeter/screens/settings/components/theme/widget_settings_section_theme.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmsScreen extends StatefulWidget {
  const FilmsScreen({super.key});

  @override
  State<FilmsScreen> createState() => _FilmsScreenState();
}

class _FilmsScreenState extends State<FilmsScreen> {
  @override
  Widget build(BuildContext context) {
    return SliverScreen(
      title: 'Films',
      appBarActions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add_outlined),
          tooltip: S.of(context).tooltipAdd,
        ),
      ],
      slivers: [
        ExpandableSectionList<Film>(
          values: films,
          onSectionTitleTap: () {},
          contentBuilder: (context, value) => [
            ListTile(
              leading: const Icon(Icons.iso),
              title: Text(S.of(context).iso),
              trailing: Text(value.iso.toString()),
              onTap: () {
                
              },
            ),
            ListTile(
              leading: const Icon(Icons.equalizer),
              title: Text('Formula'),
              trailing: Text('x^1.34'),
            ),
          ],
          actionsBuilder: (context, value) => [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.copy_outlined),
              tooltip: S.of(context).tooltipCopy,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete_outlined),
              tooltip: S.of(context).tooltipDelete,
            ),
          ],
        ),
        SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom)),
      ],
    );
  }
}
