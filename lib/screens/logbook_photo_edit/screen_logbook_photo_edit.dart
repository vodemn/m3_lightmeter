import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/logbook_photo_edit/bloc_logbook_photo_edit.dart';
import 'package:lightmeter/screens/logbook_photo_edit/components/coordinates_list_tile/widget_list_tile_coordinates_logbook_photo.dart';
import 'package:lightmeter/screens/logbook_photo_edit/components/picker_list_tile/widget_list_tile_picker.dart';
import 'package:lightmeter/screens/logbook_photo_edit/event_logbook_photo_edit.dart';
import 'package:lightmeter/screens/logbook_photo_edit/state_logbook_photo_edit.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:lightmeter/screens/shared/text_field/widget_text_field.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class LogbookPhotoEditScreen extends StatefulWidget {
  const LogbookPhotoEditScreen({super.key});

  @override
  State<LogbookPhotoEditScreen> createState() => _LogbookPhotoEditScreenState();
}

class _LogbookPhotoEditScreenState extends State<LogbookPhotoEditScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogbookPhotoEditBloc, LogbookPhotoEditState>(
      listenWhen: (previous, current) => previous.isLoading != current.isLoading,
      listener: (context, state) {
        if (state.isLoading) {
          FocusScope.of(context).unfocus();
        } else {
          Navigator.of(context).pop();
        }
      },
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) => IgnorePointer(
        ignoring: state.isLoading,
        child: SliverScreen(
          title: Text(_formatDate(state.timestamp)),
          appBarActions: [
            BlocBuilder<LogbookPhotoEditBloc, LogbookPhotoEditState>(
              buildWhen: (previous, current) => previous.canSave != current.canSave,
              builder: (context, state) => IconButton(
                onPressed: state.canSave
                    ? () {
                        context.read<LogbookPhotoEditBloc>().add(const LogbookPhotoSaveEvent());
                      }
                    : null,
                icon: const Icon(Icons.save_outlined),
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<LogbookPhotoEditBloc>().add(const LogbookPhotoDeleteEvent());
              },
              icon: const Icon(Icons.delete_outlined),
            ),
          ],
          slivers: [
            SliverToBoxAdapter(
              child: Opacity(
                opacity: state.isLoading ? Dimens.disabledOpacity : Dimens.enabledOpacity,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.paddingM),
                  child: Column(
                    children: [
                      _PhotoPreviewBuilder(),
                      SizedBox(height: Dimens.grid16),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: Dimens.paddingM),
                          child: Column(
                            children: [
                              LogbookPhotoCoordinatesListTile(),
                              _NoteListTile(),
                              _EvListTile(),
                              _IsoListTile(),
                              _NdFilterListTile(),
                              _AperturePickerListTile(),
                              _ShutterSpeedPickerListTile(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Dimens.grid16),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }
}

class _PhotoPreviewBuilder extends StatelessWidget {
  const _PhotoPreviewBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogbookPhotoEditBloc, LogbookPhotoEditState>(
      buildWhen: (_, __) => false,
      builder: (context, state) => AspectRatio(
        aspectRatio: PlatformConfig.cameraPreviewAspectRatio,
        child: Hero(
          tag: state.id,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.borderRadiusM),
            child: PlatformConfig.cameraStubImage.isNotEmpty
                ? Image.asset(
                    PlatformConfig.cameraStubImage,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(state.name),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}

class _NoteListTile extends StatelessWidget {
  const _NoteListTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogbookPhotoEditBloc, LogbookPhotoEditState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.only(
          left: Dimens.paddingM,
          top: Dimens.paddingS / 2,
          right: Dimens.paddingL,
          bottom: Dimens.paddingS / 2,
        ),
        child: LightmeterTextField(
          initialValue: state.note,
          maxLength: 256,
          maxLines: null,
          hintText: S.of(context).note,
          style: Theme.of(context).listTileTheme.titleTextStyle,
          leading: const Icon(Icons.note_outlined),
          onChanged: (value) {
            context.read<LogbookPhotoEditBloc>().add(LogbookPhotoNoteChangedEvent(value));
          },
        ),
      ),
    );
  }
}

class _EvListTile extends StatelessWidget {
  const _EvListTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogbookPhotoEditBloc, LogbookPhotoEditState>(
      buildWhen: (_, __) => false,
      builder: (context, state) => ListTile(
        leading: const Icon(Icons.exposure),
        title: Text(S.of(context).ev),
        trailing: Text(state.ev.toStringAsFixed(1)),
      ),
    );
  }
}

class _IsoListTile extends StatelessWidget {
  const _IsoListTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogbookPhotoEditBloc, LogbookPhotoEditState>(
      buildWhen: (_, __) => false,
      builder: (context, state) => ListTile(
        leading: const Icon(Icons.iso_outlined),
        title: Text(S.of(context).iso),
        trailing: Text(state.iso.toString()),
      ),
    );
  }
}

class _NdFilterListTile extends StatelessWidget {
  const _NdFilterListTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogbookPhotoEditBloc, LogbookPhotoEditState>(
      buildWhen: (_, __) => false,
      builder: (context, state) => ListTile(
        leading: const Icon(Icons.filter_b_and_w_outlined),
        title: Text(S.of(context).ndFilter),
        trailing: Text(state.nd.toString()),
      ),
    );
  }
}

class _AperturePickerListTile extends StatelessWidget {
  const _AperturePickerListTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogbookPhotoEditBloc, LogbookPhotoEditState>(
      buildWhen: (previous, current) => previous.aperture != current.aperture,
      builder: (context, state) => PickerListTile(
        icon: Icons.camera_outlined,
        title: S.of(context).apertureValue,
        values: ApertureValue.values,
        selectedValue: state.aperture,
        onChanged: (value) {
          context.read<LogbookPhotoEditBloc>().add(LogbookPhotoApertureChangedEvent(value.value));
        },
      ),
    );
  }
}

class _ShutterSpeedPickerListTile extends StatelessWidget {
  const _ShutterSpeedPickerListTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogbookPhotoEditBloc, LogbookPhotoEditState>(
      buildWhen: (previous, current) => previous.shutterSpeed != current.shutterSpeed,
      builder: (context, state) => PickerListTile(
        icon: Icons.shutter_speed_outlined,
        title: S.of(context).shutterSpeedValue,
        values: ShutterSpeedValue.values,
        selectedValue: state.shutterSpeed,
        onChanged: (value) {
          context.read<LogbookPhotoEditBloc>().add(LogbookPhotoShutterSpeedChangedEvent(value.value));
        },
      ),
    );
  }
}
