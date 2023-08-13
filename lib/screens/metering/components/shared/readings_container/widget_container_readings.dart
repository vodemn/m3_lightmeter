import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/features.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/animated_dialog_picker/widget_picker_dialog_animated.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/reading_value_container/widget_container_reading_value.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class ReadingsContainer extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final Film film;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<Film> onFilmChanged;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;

  const ReadingsContainer({
    required this.fastest,
    required this.slowest,
    required this.film,
    required this.iso,
    required this.nd,
    required this.onFilmChanged,
    required this.onIsoChanged,
    required this.onNdChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (FeaturesConfig.equipmentProfilesEnabled) ...[
          const _EquipmentProfilePicker(),
          const _InnerPadding(),
        ],
        if (UserPreferencesProvider.meteringScreenFeatureOf(
          context,
          MeteringScreenLayoutFeature.extremeExposurePairs,
        )) ...[
          ReadingValueContainer(
            values: [
              ReadingValue(
                label: S.of(context).fastestExposurePair,
                value: fastest != null ? fastest!.toString() : '-',
              ),
              ReadingValue(
                label: S.of(context).slowestExposurePair,
                value: fastest != null ? slowest!.toString() : '-',
              ),
            ],
          ),
          const _InnerPadding(),
        ],
        if (UserPreferencesProvider.meteringScreenFeatureOf(
          context,
          MeteringScreenLayoutFeature.filmPicker,
        )) ...[
          _FilmPicker(
            values: Film.values,
            selectedValue: film,
            onChanged: onFilmChanged,
          ),
          const _InnerPadding(),
        ],
        Row(
          children: [
            Expanded(
              child: _IsoValuePicker(
                selectedValue: iso,
                values: EquipmentProfiles.selectedOf(context).isoValues,
                onChanged: onIsoChanged,
              ),
            ),
            const _InnerPadding(),
            Expanded(
              child: _NdValuePicker(
                selectedValue: nd,
                values: EquipmentProfiles.selectedOf(context).ndValues,
                onChanged: onNdChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InnerPadding extends SizedBox {
  const _InnerPadding() : super(height: Dimens.grid8, width: Dimens.grid8);
}

class _EquipmentProfilePicker extends StatelessWidget {
  const _EquipmentProfilePicker();

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<EquipmentProfile>(
      icon: Icons.camera,
      title: S.of(context).equipmentProfile,
      selectedValue: EquipmentProfiles.selectedOf(context),
      values: EquipmentProfiles.of(context),
      itemTitleBuilder: (_, value) => Text(value.id.isEmpty ? S.of(context).none : value.name),
      onChanged: EquipmentProfileProvider.of(context).setProfile,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: S.of(context).equipmentProfile,
          value: EquipmentProfiles.selectedOf(context).id.isEmpty
              ? S.of(context).none
              : EquipmentProfiles.selectedOf(context).name,
        ),
      ),
    );
  }
}

class _FilmPicker extends StatelessWidget {
  final List<Film> values;
  final Film selectedValue;
  final ValueChanged<Film> onChanged;

  const _FilmPicker({
    required this.values,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<Film>(
      icon: Icons.camera_roll,
      title: S.of(context).film,
      selectedValue: selectedValue,
      values: values,
      itemTitleBuilder: (_, value) => Text(value.name.isEmpty ? S.of(context).none : value.name),
      onChanged: onChanged,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: S.of(context).film,
          value: selectedValue.name.isEmpty ? S.of(context).none : selectedValue.name,
        ),
      ),
    );
  }
}

class _IsoValuePicker extends StatelessWidget {
  final List<IsoValue> values;
  final IsoValue selectedValue;
  final ValueChanged<IsoValue> onChanged;

  const _IsoValuePicker({
    required this.selectedValue,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<IsoValue>(
      icon: Icons.iso,
      title: S.of(context).iso,
      subtitle: S.of(context).filmSpeed,
      selectedValue: selectedValue,
      values: values,
      itemTitleBuilder: (_, value) => Text(value.value.toString()),
      // using ascending order, because increase in film speed rises EV
      itemTrailingBuilder: (selected, value) => value.value != selected.value
          ? Text(S.of(context).evValue(selected.toStringDifference(value)))
          : null,
      onChanged: onChanged,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: S.of(context).iso,
          value: selectedValue.value.toString(),
        ),
      ),
    );
  }
}

class _NdValuePicker extends StatelessWidget {
  final List<NdValue> values;
  final NdValue selectedValue;
  final ValueChanged<NdValue> onChanged;

  const _NdValuePicker({
    required this.selectedValue,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<NdValue>(
      icon: Icons.filter_b_and_w,
      title: S.of(context).nd,
      subtitle: S.of(context).ndFilterFactor,
      selectedValue: selectedValue,
      values: values,
      itemTitleBuilder: (_, value) => Text(
        value.value == 0 ? S.of(context).none : value.value.toString(),
      ),
      // using descending order, because ND filter darkens image & lowers EV
      itemTrailingBuilder: (selected, value) => value.value != selected.value
          ? Text(S.of(context).evValue(value.toStringDifference(selected)))
          : null,
      onChanged: onChanged,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: S.of(context).nd,
          value: selectedValue.value.toString(),
        ),
      ),
    );
  }
}
