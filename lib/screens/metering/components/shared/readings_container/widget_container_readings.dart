import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/photography_values/iso_value.dart';
import 'package:lightmeter/data/models/photography_values/nd_value.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/animated_dialog_picker/widget_dialog_animated_picker.dart';
import 'components/reading_value_container/widget_container_reading_value.dart';

/// Contains a column of fastest & slowest exposure pairs + a row of ISO and ND pickers
class ReadingsContainer extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;

  const ReadingsContainer({
    required this.fastest,
    required this.slowest,
    required this.iso,
    required this.nd,
    required this.onIsoChanged,
    required this.onNdChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        Row(
          children: [
            Expanded(
              child: _IsoValueTile(
                value: iso,
                onChanged: onIsoChanged,
              ),
            ),
            const _InnerPadding(),
            Expanded(
              child: _NdValueTile(
                value: nd,
                onChanged: onNdChanged,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _InnerPadding extends SizedBox {
  const _InnerPadding() : super(height: Dimens.grid8, width: Dimens.grid8);
}

class _IsoValueTile extends StatelessWidget {
  final IsoValue value;
  final ValueChanged<IsoValue> onChanged;

  const _IsoValueTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<IsoValue>(
      title: S.of(context).iso,
      subtitle: S.of(context).filmSpeed,
      selectedValue: value,
      values: isoValues,
      itemTitleBuilder: (_, value) => Text(value.value.toString()),
      // using ascending order, because increase in film speed rises EV
      evDifferenceBuilder: (selected, other) => selected.toStringDifference(other),
      onChanged: onChanged,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: S.of(context).iso,
          value: value.value.toString(),
        ),
      ),
    );
  }
}

class _NdValueTile extends StatelessWidget {
  final NdValue value;
  final ValueChanged<NdValue> onChanged;

  const _NdValueTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<NdValue>(
      title: S.of(context).nd,
      subtitle: S.of(context).ndFilterFactor,
      selectedValue: value,
      values: ndValues,
      itemTitleBuilder: (_, value) => Text(
        value.value == 0 ? S.of(context).none : value.value.toString(),
      ),
      // using descending order, because ND filter darkens image & lowers EV
      evDifferenceBuilder: (selected, other) => other.toStringDifference(selected),
      onChanged: onChanged,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: S.of(context).nd,
          value: value.value.toString(),
        ),
      ),
    );
  }
}
