import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/logbook_photos_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/equipment_profile_edit/flow_equipment_profile_edit.dart';
import 'package:lightmeter/screens/shared/sliver_placeholder/widget_sliver_placeholder.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class LogbookScreen extends StatefulWidget {
  const LogbookScreen({super.key});

  @override
  State<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SliverScreen(
      title: Text("Logbook"),
      slivers: [
        _PicturesGridBuilder(
          values: LogbookPhotos.of(context),
          onEdit: _editProfile,
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ),
      ],
    );
  }

  void _editProfile(LogbookPhoto photo) {}
}

class _PicturesGridBuilder extends StatelessWidget {
  final List<LogbookPhoto> values;
  final void Function(LogbookPhoto photo) onEdit;

  static const int _crossAxisCount = 3;

  const _PicturesGridBuilder({
    required this.values,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent:
            (MediaQuery.sizeOf(context).width - Dimens.paddingS * (_crossAxisCount - 1)) / _crossAxisCount,
        mainAxisSpacing: Dimens.paddingS,
        crossAxisSpacing: Dimens.paddingS,
        childAspectRatio: PlatformConfig.cameraPreviewAspectRatio,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            color: Colors.teal[100 * (index % 9)],
            child: Image.file(File(values[index].name)),
          );
        },
        childCount: values.length,
      ),
    );
  }
}
