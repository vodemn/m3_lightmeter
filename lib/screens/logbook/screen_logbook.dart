import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/providers/logbook_photos_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/logbook/components/grid_tile/widget_grid_tile_logbook_photo.dart';
import 'package:lightmeter/screens/shared/icon_placeholder/widget_icon_placeholder.dart';
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
      title: Text(S.of(context).logbook),
      slivers: [
        SliverToBoxAdapter(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.paddingM),
              child: SwitchListTile(
                secondary: const Icon(Icons.book_outlined),
                title: Text(S.of(context).saveNewPhotos),
                value: LogbookPhotos.isEnabledOf(context),
                onChanged: LogbookPhotosProvider.of(context).saveLogbookPhotos,
              ),
            ),
          ),
        ),
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

  void _editProfile(LogbookPhoto photo) {
    Navigator.of(context).pushNamed(
      NavigationRoutes.logbookPhotoEditScreen.name,
      arguments: photo,
    );
  }
}

class _PicturesGridBuilder extends StatefulWidget {
  final List<LogbookPhoto> values;
  final void Function(LogbookPhoto photo) onEdit;

  static const int _crossAxisCount = 3;

  const _PicturesGridBuilder({
    required this.values,
    required this.onEdit,
  });

  @override
  State<_PicturesGridBuilder> createState() => _PicturesGridBuilderState();
}

class _PicturesGridBuilderState extends State<_PicturesGridBuilder> {
  late Map<String, GlobalKey> _keys = _generateKeys();

  @override
  void didUpdateWidget(_PicturesGridBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _keys = _generateKeys();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.values.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: IconPlaceholder(
            icon: Icons.photo_outlined,
            text: S.of(context).noPhotos,
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.all(Dimens.paddingM),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: (MediaQuery.sizeOf(context).width -
                  Dimens.paddingS * (_PicturesGridBuilder._crossAxisCount - 1) -
                  Dimens.paddingM * 2) /
              _PicturesGridBuilder._crossAxisCount,
          mainAxisSpacing: Dimens.paddingS,
          crossAxisSpacing: Dimens.paddingS,
          childAspectRatio: PlatformConfig.cameraPreviewAspectRatio,
        ),
        delegate: SliverChildBuilderDelegate(
          //TODO: fix jumping after the photo is edited
          (_, int index) => LogbookPhotoGridTile(
            key: _keys[widget.values[index].id],
            photo: widget.values[index],
            onTap: () => widget.onEdit(widget.values[index]),
          ),
          childCount: widget.values.length,
        ),
      ),
    );
  }

  Map<String, GlobalKey> _generateKeys() {
    return Map.fromEntries(
      widget.values.map(
        (photo) => MapEntry(
          photo.id,
          GlobalKey(debugLabel: photo.id),
        ),
      ),
    );
  }
}
