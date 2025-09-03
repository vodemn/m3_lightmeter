import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/equipment_profile_edit/bloc_equipment_profile_edit.dart';
import 'package:lightmeter/screens/equipment_profile_edit/components/filter_list_tile/widget_list_tile_filter.dart';
import 'package:lightmeter/screens/equipment_profile_edit/components/range_picker_list_tile/widget_list_tile_range_picker.dart';
import 'package:lightmeter/screens/equipment_profile_edit/components/slider_picker_list_tile/widget_list_tile_slider_picker.dart';
import 'package:lightmeter/screens/equipment_profile_edit/event_equipment_profile_edit.dart';
import 'package:lightmeter/screens/equipment_profile_edit/flow_equipment_profile_edit.dart';
import 'package:lightmeter/screens/equipment_profile_edit/state_equipment_profile_edit.dart';
import 'package:lightmeter/screens/metering/components/camera_container/bloc_container_camera.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:lightmeter/screens/shared/text_field/widget_text_field.dart';
import 'package:lightmeter/utils/double_to_zoom.dart';
import 'package:lightmeter/utils/to_string_signed.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfileEditScreen<T extends IEquipmentProfile> extends StatefulWidget {
  final bool isEdit;

  const EquipmentProfileEditScreen({
    required this.isEdit,
    super.key,
  });

  @override
  State<EquipmentProfileEditScreen<T>> createState() => _EquipmentProfileEditScreenState<T>();
}

class _EquipmentProfileEditScreenState<T extends IEquipmentProfile> extends State<EquipmentProfileEditScreen<T>> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IEquipmentProfileEditBloc<T>, EquipmentProfileEditState<T>>(
      listenWhen: (previous, current) => previous.isLoading != current.isLoading,
      listener: (context, state) {
        if (state.isLoading) {
          FocusScope.of(context).unfocus();
        } else {
          if (state.profileToCopy != null) {
            Navigator.of(context).pushReplacementNamed(
              NavigationRoutes.equipmentProfileEditScreen.name,
              arguments: EquipmentProfileEditArgs<T>(
                editType: EquipmentProfileEditType.add,
                profile: state.profileToCopy!,
              ),
            );
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) => IgnorePointer(
        ignoring: state.isLoading,
        child: SliverScreen(
          title: Text(widget.isEdit ? S.of(context).editEquipmentProfileTitle : S.of(context).addEquipmentProfileTitle),
          appBarActions: [
            BlocBuilder<IEquipmentProfileEditBloc<T>, EquipmentProfileEditState<T>>(
              buildWhen: (previous, current) => previous.canSave != current.canSave,
              builder: (context, state) => IconButton(
                onPressed: state.canSave
                    ? () {
                        context.read<IEquipmentProfileEditBloc<T>>().add(const EquipmentProfileSaveEvent());
                      }
                    : null,
                icon: const Icon(Icons.save_outlined),
              ),
            ),
            if (widget.isEdit)
              BlocBuilder<IEquipmentProfileEditBloc<T>, EquipmentProfileEditState<T>>(
                buildWhen: (previous, current) => previous.canSave != current.canSave,
                builder: (context, state) => IconButton(
                  onPressed: state.canSave
                      ? null
                      : () {
                          context.read<IEquipmentProfileEditBloc<T>>().add(const EquipmentProfileCopyEvent());
                        },
                  icon: const Icon(Icons.copy_outlined),
                ),
              ),
            if (widget.isEdit)
              IconButton(
                onPressed: () {
                  context.read<IEquipmentProfileEditBloc<T>>().add(const EquipmentProfileDeleteEvent());
                },
                icon: const Icon(Icons.delete_outlined),
              ),
          ],
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Dimens.paddingM,
                  0,
                  Dimens.paddingM,
                  Dimens.paddingM,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimens.paddingM),
                    child: Opacity(
                      opacity: state.isLoading ? Dimens.disabledOpacity : Dimens.enabledOpacity,
                      child: Column(
                        children: switch (state.profile) {
                          EquipmentProfile() => [
                              _NameFieldBuilder<T>(),
                              _ApertureValuesListTileBuilder(),
                              _ShutterSpeedValuesListTileBuilder(),
                              _IsoValuesListTileBuilder<T>(),
                              _NdValuesListTileBuilder(),
                              _LensZoomListTileBuilder<T>(),
                              _ExposureOffsetListTileBuilder<T>(),
                            ],
                          PinholeEquipmentProfile() => [
                              _NameFieldBuilder<T>(),
                              // TODO: Add aperture value list tile for pinhole equipment profile
                              _IsoValuesListTileBuilder<T>(),
                              _LensZoomListTileBuilder<T>(),
                              _ExposureOffsetListTileBuilder<T>(),
                            ],
                        },
                      ),
                    ),
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
}

class _NameFieldBuilder<T extends IEquipmentProfile> extends StatelessWidget {
  const _NameFieldBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IEquipmentProfileEditBloc<T>, EquipmentProfileEditState<T>>(
      buildWhen: (previous, current) => previous.profile.name != current.profile.name,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.only(
          left: Dimens.paddingM,
          top: Dimens.paddingS / 2,
          right: Dimens.paddingL,
          bottom: Dimens.paddingS / 2,
        ),
        child: LightmeterTextField(
          autofocus: true,
          initialValue: state.profile.name,
          maxLength: 48,
          hintText: S.of(context).name,
          style: Theme.of(context).listTileTheme.titleTextStyle,
          leading: const Icon(Icons.edit_outlined),
          onChanged: (value) {
            context.read<IEquipmentProfileEditBloc<T>>().add(EquipmentProfileNameChangedEvent<T>(value));
          },
        ),
      ),
    );
  }
}

class _IsoValuesListTileBuilder<T extends IEquipmentProfile> extends StatelessWidget {
  const _IsoValuesListTileBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IEquipmentProfileEditBloc<T>, EquipmentProfileEditState<T>>(
      builder: (context, state) => FilterListTile<IsoValue>(
        icon: Icons.iso_outlined,
        title: S.of(context).isoValues,
        description: S.of(context).isoValuesFilterDescription,
        values: IsoValue.values,
        selectedValues: state.profile.isoValues,
        onChanged: (value) {
          context.read<IEquipmentProfileEditBloc<T>>().add(EquipmentProfileIsoValuesChangedEvent<T>(value));
        },
      ),
    );
  }
}

class _NdValuesListTileBuilder extends StatelessWidget {
  const _NdValuesListTileBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquipmentProfileEditBloc, EquipmentProfileEditState<EquipmentProfile>>(
      builder: (context, state) => FilterListTile<NdValue>(
        icon: Icons.filter_b_and_w_outlined,
        title: S.of(context).ndFilters,
        description: S.of(context).ndFiltersFilterDescription,
        values: NdValue.values,
        selectedValues: state.profile.ndValues,
        onChanged: (value) {
          context.read<EquipmentProfileEditBloc>().add(EquipmentProfileNdValuesChangedEvent(value));
        },
      ),
    );
  }
}

class _ApertureValuesListTileBuilder extends StatelessWidget {
  const _ApertureValuesListTileBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquipmentProfileEditBloc, EquipmentProfileEditState<EquipmentProfile>>(
      builder: (context, state) => RangePickerListTile<ApertureValue>(
        icon: Icons.camera_outlined,
        title: S.of(context).apertureValues,
        description: S.of(context).apertureValuesFilterDescription,
        values: ApertureValue.values,
        selectedValues: state.profile.apertureValues,
        onChanged: (value) {
          context.read<EquipmentProfileEditBloc>().add(EquipmentProfileApertureValuesChangedEvent(value));
        },
      ),
    );
  }
}

class _ShutterSpeedValuesListTileBuilder extends StatelessWidget {
  const _ShutterSpeedValuesListTileBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquipmentProfileEditBloc, EquipmentProfileEditState<EquipmentProfile>>(
      builder: (context, state) => RangePickerListTile<ShutterSpeedValue>(
        icon: Icons.shutter_speed_outlined,
        title: S.of(context).shutterSpeedValues,
        description: S.of(context).shutterSpeedValuesFilterDescription,
        values: ShutterSpeedValue.values,
        selectedValues: state.profile.shutterSpeedValues,
        trailingAdapter: (context, value) =>
            value.value == 1 ? S.of(context).shutterSpeedManualShort : value.toString(),
        dialogValueAdapter: (context, value) => value.value == 1 ? S.of(context).shutterSpeedManual : value.toString(),
        onChanged: (value) {
          context.read<EquipmentProfileEditBloc>().add(EquipmentProfileShutterSpeedValuesChangedEvent(value));
        },
      ),
    );
  }
}

class _LensZoomListTileBuilder<T extends IEquipmentProfile> extends StatelessWidget {
  const _LensZoomListTileBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IEquipmentProfileEditBloc<T>, EquipmentProfileEditState<T>>(
      buildWhen: (previous, current) => previous.profile.lensZoom != current.profile.lensZoom,
      builder: (context, state) => SliderPickerListTile(
        icon: Icons.zoom_in_outlined,
        title: S.of(context).lensZoom,
        description: S.of(context).lensZoomDescription,
        value: state.profile.lensZoom,
        range: CameraContainerBloc.zoomMaxRange,
        valueAdapter: (context, value) => value.toZoom(context),
        onChanged: (value) {
          context.read<IEquipmentProfileEditBloc<T>>().add(EquipmentProfileLensZoomChangedEvent<T>(value));
        },
      ),
    );
  }
}

class _ExposureOffsetListTileBuilder<T extends IEquipmentProfile> extends StatelessWidget {
  const _ExposureOffsetListTileBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IEquipmentProfileEditBloc<T>, EquipmentProfileEditState<T>>(
      buildWhen: (previous, current) => previous.profile.exposureOffset != current.profile.exposureOffset,
      builder: (context, state) => SliderPickerListTile(
        icon: Icons.light_mode_outlined,
        title: S.of(context).exposureOffset,
        description: S.of(context).exposureOffsetDescription,
        value: state.profile.exposureOffset,
        range: CameraContainerBloc.exposureMaxRange,
        valueAdapter: (context, value) => S.of(context).evValue(value.toStringSignedAsFixed(1)),
        onChanged: (value) {
          context.read<IEquipmentProfileEditBloc<T>>().add(EquipmentProfileExposureOffsetChangedEvent<T>(value));
        },
      ),
    );
  }
}
