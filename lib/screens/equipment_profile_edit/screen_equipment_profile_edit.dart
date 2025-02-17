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
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:lightmeter/screens/shared/text_field/widget_text_field.dart';
import 'package:lightmeter/utils/double_to_zoom.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfileEditScreen extends StatefulWidget {
  final bool isEdit;

  const EquipmentProfileEditScreen({
    required this.isEdit,
    super.key,
  });

  @override
  State<EquipmentProfileEditScreen> createState() => _EquipmentProfileEditScreenState();
}

class _EquipmentProfileEditScreenState extends State<EquipmentProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EquipmentProfileEditBloc, EquipmentProfileEditState>(
      listenWhen: (previous, current) => previous.isLoading != current.isLoading,
      listener: (context, state) {
        if (state.isLoading) {
          FocusScope.of(context).unfocus();
        } else {
          if (state.profileToCopy != null) {
            Navigator.of(context).pushReplacementNamed(
              NavigationRoutes.equipmentProfileEditScreen.name,
              arguments: EquipmentProfileEditArgs(
                editType: EquipmentProfileEditType.add,
                profile: state.profileToCopy,
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
            BlocBuilder<EquipmentProfileEditBloc, EquipmentProfileEditState>(
              buildWhen: (previous, current) => previous.canSave != current.canSave,
              builder: (context, state) => IconButton(
                onPressed: state.canSave
                    ? () {
                        context.read<EquipmentProfileEditBloc>().add(const EquipmentProfileSaveEvent());
                      }
                    : null,
                icon: const Icon(Icons.save_outlined),
              ),
            ),
            if (widget.isEdit)
              BlocBuilder<EquipmentProfileEditBloc, EquipmentProfileEditState>(
                buildWhen: (previous, current) => previous.canSave != current.canSave,
                builder: (context, state) => IconButton(
                  onPressed: state.canSave
                      ? null
                      : () {
                          context.read<EquipmentProfileEditBloc>().add(const EquipmentProfileCopyEvent());
                        },
                  icon: const Icon(Icons.copy_outlined),
                ),
              ),
            if (widget.isEdit)
              IconButton(
                onPressed: () {
                  context.read<EquipmentProfileEditBloc>().add(const EquipmentProfileDeleteEvent());
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
                      child: const Column(
                        children: [
                          _NameFieldBuilder(),
                          _IsoValuesListTileBuilder(),
                          _NdValuesListTileBuilder(),
                          _ApertureValuesListTileBuilder(),
                          _ShutterSpeedValuesListTileBuilder(),
                          _LensZoomListTileBuilder(),
                        ],
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

class _NameFieldBuilder extends StatelessWidget {
  const _NameFieldBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquipmentProfileEditBloc, EquipmentProfileEditState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.only(
          left: Dimens.paddingM,
          top: Dimens.paddingS / 2,
          right: Dimens.paddingL,
          bottom: Dimens.paddingS / 2,
        ),
        child: LightmeterTextField(
          initialValue: state.name,
          maxLength: 48,
          hintText: S.of(context).name,
          style: Theme.of(context).listTileTheme.titleTextStyle,
          leading: const Icon(Icons.edit_outlined),
          onChanged: (value) {
            context.read<EquipmentProfileEditBloc>().add(EquipmentProfileNameChangedEvent(value));
          },
        ),
      ),
    );
  }
}

class _IsoValuesListTileBuilder extends StatelessWidget {
  const _IsoValuesListTileBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquipmentProfileEditBloc, EquipmentProfileEditState>(
      builder: (context, state) => FilterListTile<IsoValue>(
        icon: Icons.iso_outlined,
        title: S.of(context).isoValues,
        description: S.of(context).isoValuesFilterDescription,
        values: IsoValue.values,
        selectedValues: state.isoValues,
        onChanged: (value) {
          context.read<EquipmentProfileEditBloc>().add(EquipmentProfileIsoValuesChangedEvent(value));
        },
      ),
    );
  }
}

class _NdValuesListTileBuilder extends StatelessWidget {
  const _NdValuesListTileBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquipmentProfileEditBloc, EquipmentProfileEditState>(
      builder: (context, state) => FilterListTile<NdValue>(
        icon: Icons.filter_b_and_w_outlined,
        title: S.of(context).ndFilters,
        description: S.of(context).ndFiltersFilterDescription,
        values: NdValue.values,
        selectedValues: state.ndValues,
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
    return BlocBuilder<EquipmentProfileEditBloc, EquipmentProfileEditState>(
      builder: (context, state) => RangePickerListTile<ApertureValue>(
        icon: Icons.camera_outlined,
        title: S.of(context).apertureValues,
        description: S.of(context).apertureValuesFilterDescription,
        values: ApertureValue.values,
        selectedValues: state.apertureValues,
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
    return BlocBuilder<EquipmentProfileEditBloc, EquipmentProfileEditState>(
      builder: (context, state) => RangePickerListTile<ShutterSpeedValue>(
        icon: Icons.shutter_speed_outlined,
        title: S.of(context).shutterSpeedValues,
        description: S.of(context).shutterSpeedValuesFilterDescription,
        values: ShutterSpeedValue.values,
        selectedValues: state.shutterSpeedValues,
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

class _LensZoomListTileBuilder extends StatelessWidget {
  const _LensZoomListTileBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquipmentProfileEditBloc, EquipmentProfileEditState>(
      builder: (context, state) => SliderPickerListTile(
        icon: Icons.zoom_in_outlined,
        title: S.of(context).lensZoom,
        description: S.of(context).lensZoomDescription,
        value: state.lensZoom,
        range: const RangeValues(1, 7),
        valueAdapter: (context, value) => value.toZoom(context),
        onChanged: (value) {
          context.read<EquipmentProfileEditBloc>().add(EquipmentProfileLensZoomChangedEvent(value));
        },
      ),
    );
  }
}
