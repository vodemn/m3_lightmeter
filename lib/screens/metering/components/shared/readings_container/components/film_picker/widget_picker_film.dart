import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/widget_picker_dialog_animated.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmPicker extends StatelessWidget {
  final IsoValue selectedIso;

  const FilmPicker({required this.selectedIso});

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<Film>(
      icon: Icons.camera_roll_outlined,
      title: S.of(context).film,
      subtitle: S.of(context).filmReciprocityHint,
      selectedValue: Films.selectedOf(context),
      values: Films.inUseOf(context),
      itemTitleBuilder: (_, value) => Text(value.name.isEmpty ? S.of(context).none : value.name),
      onChanged: FilmsProvider.of(context).selectFilm,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: _label(context),
          value: Films.selectedOf(context).name.isEmpty ? S.of(context).none : Films.selectedOf(context).name,
        ),
      ),
    );
  }

  String _label(BuildContext context) {
    if (Films.selectedOf(context) == const FilmStub() || Films.selectedOf(context).iso == selectedIso.value) {
      return S.of(context).film;
    }

    final evDiff = IsoValue(
      Films.selectedOf(context).iso,
      StopType.full,
    ).difference(selectedIso);

    if (evDiff > 0) {
      return S.of(context).filmPush;
    } else if (evDiff < 0) {
      return S.of(context).filmPull;
    } else {
      return S.of(context).film;
    }
  }
}
