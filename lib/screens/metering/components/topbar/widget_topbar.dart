import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/screens/metering/ev_source/camera/bloc_camera.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/photography_values/iso_value.dart';
import 'package:lightmeter/data/models/photography_values/nd_value.dart';
import 'package:lightmeter/data/models/photography_values/photography_value.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/widget_camera_preview.dart';
import 'components/shared/widget_dialog_animated.dart';
import 'components/widget_dialog_picker.dart';
import 'components/container_reading_value.dart';

class MeteringTopBar extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final double ev;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;

  const MeteringTopBar({
    required this.fastest,
    required this.slowest,
    required this.ev,
    required this.iso,
    required this.nd,
    required this.onIsoChanged,
    required this.onNdChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(Dimens.borderRadiusL),
        bottomRight: Radius.circular(Dimens.borderRadiusL),
      ),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.paddingM),
          child: SafeArea(
            bottom: false,
            child: MediaQuery(
              data: MediaQuery.of(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ReadingValueContainer(
                          values: [
                            ReadingValue(
                              label: S.of(context).fastestExposurePair,
                              value: fastest != null
                                  ? '${fastest!.aperture.toString()} - ${fastest!.shutterSpeed.toString()}'
                                  : '-',
                            ),
                            ReadingValue(
                              label: S.of(context).slowestExposurePair,
                              value: fastest != null
                                  ? '${slowest!.aperture.toString()} - ${slowest!.shutterSpeed.toString()}'
                                  : '-',
                            ),
                          ],
                        ),
                        /*
                        const _InnerPadding(),
                        ReadingValueContainer.singleValue(
                          value: ReadingValue(
                            label: 'EV',
                            value: ev.toStringAsFixed(1),
                          ),
                        ),
                        */
                        const _InnerPadding(),
                        Row(
                          children: [
                            Expanded(
                              child: _AnimatedDialogPicker(
                                title: S.of(context).iso,
                                subtitle: S.of(context).filmSpeed,
                                selectedValue: iso,
                                values: isoValues,
                                itemTitleBuilder: (_, value) => Text(value.value.toString()),
                                // using ascending order, because increase in film speed rises EV
                                evDifferenceBuilder: (selected, other) => selected.toStringDifference(other),
                                onChanged: onIsoChanged,
                              ),
                            ),
                            const _InnerPadding(),
                            Expanded(
                              child: _AnimatedDialogPicker(
                                title: S.of(context).nd,
                                subtitle: S.of(context).ndFilterFactor,
                                selectedValue: nd,
                                values: ndValues,
                                itemTitleBuilder: (_, value) => Text(
                                  value.value == 0 ? S.of(context).none : value.value.toString(),
                                ),
                                // using descending order, because ND filter darkens image & lowers EV
                                evDifferenceBuilder: (selected, other) => other.toStringDifference(selected),
                                onChanged: onNdChanged,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const _InnerPadding(),
                  Expanded(
                    child: AnimatedDialog(
                      openedSize: Size(
                        MediaQuery.of(context).size.width - Dimens.paddingM * 2,
                        (MediaQuery.of(context).size.width - Dimens.paddingM * 2) / 3 * 4,
                      ),
                      child: BlocProvider.value(
                        value: context.read<CameraBloc>(),
                        child: const CameraView(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InnerPadding extends SizedBox {
  const _InnerPadding() : super(height: Dimens.grid8, width: Dimens.grid8);
}

class _AnimatedDialogPicker<T extends PhotographyValue> extends StatelessWidget {
  final _key = GlobalKey<AnimatedDialogState>();
  final String title;
  final String subtitle;
  final T selectedValue;
  final List<T> values;
  final DialogPickerItemBuilder<T> itemTitleBuilder;
  final DialogPickerEvDifferenceBuilder<T> evDifferenceBuilder;
  final ValueChanged<T> onChanged;

  _AnimatedDialogPicker({
    required this.title,
    required this.subtitle,
    required this.selectedValue,
    required this.values,
    required this.itemTitleBuilder,
    required this.evDifferenceBuilder,
    required this.onChanged,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return AnimatedDialog(
      key: _key,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: title,
          value: selectedValue.value.toString(),
        ),
      ),
      openedChild: MeteringScreenDialogPicker<T>(
        title: title,
        subtitle: subtitle,
        initialValue: selectedValue,
        values: values,
        itemTitleBuilder: itemTitleBuilder,
        evDifferenceBuilder: evDifferenceBuilder,
        onCancel: () {
          _key.currentState?.close();
        },
        onSelect: (value) {
          _key.currentState?.close().then((_) => onChanged(value));
        },
      ),
    );
  }
}
