import 'package:flutter/material.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/screens/metering/components/topbar/shape_topbar.dart';
import 'package:lightmeter/screens/metering/components/topbar/components/widget_size_render.dart';
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

class MeteringTopBar extends StatefulWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final double ev;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;

  final ValueChanged<double> onCutoutLayout;

  const MeteringTopBar({
    required this.fastest,
    required this.slowest,
    required this.ev,
    required this.iso,
    required this.nd,
    required this.onIsoChanged,
    required this.onNdChanged,
    required this.onCutoutLayout,
    super.key,
  });

  @override
  State<MeteringTopBar> createState() => _MeteringTopBarState();
}

class _MeteringTopBarState extends State<MeteringTopBar> {
  double stepHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TopBarShape(
        color: Theme.of(context).colorScheme.surface,
        appendixWidth: stepHeight > 0
            ? MediaQuery.of(context).size.width / 2 - Dimens.grid8 + Dimens.paddingM
            : MediaQuery.of(context).size.width / 2 + Dimens.grid8 - Dimens.paddingM,
        appendixHeight: stepHeight,
      ),
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
                  child: SizeRenderWidget(
                    onLayout: (size) => _onReadingsLayout(size.height),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ReadingValueContainer(
                          values: [
                            ReadingValue(
                              label: S.of(context).fastestExposurePair,
                              value: widget.fastest != null ? widget.fastest!.toString() : '-',
                            ),
                            ReadingValue(
                              label: S.of(context).slowestExposurePair,
                              value: widget.fastest != null ? widget.slowest!.toString() : '-',
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
                              child: _IsoValueTile(
                                value: widget.iso,
                                onChanged: widget.onIsoChanged,
                              ),
                            ),
                            const _InnerPadding(),
                            Expanded(
                              child: _NdValueTile(
                                value: widget.nd,
                                onChanged: widget.onNdChanged,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const _InnerPadding(),
                const Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.borderRadiusM)),
                    child: CameraView(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onReadingsLayout(double readingsSectionHeight) {
    stepHeight = readingsSectionHeight -
        ((MediaQuery.of(context).size.width - Dimens.grid8 - 2 * Dimens.paddingM) / 2) /
            PlatformConfig.cameraPreviewAspectRatio;
    widget.onCutoutLayout(stepHeight);
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
    return _AnimatedDialogPicker<IsoValue>(
      title: S.of(context).iso,
      subtitle: S.of(context).filmSpeed,
      selectedValue: value,
      values: isoValues,
      itemTitleBuilder: (_, value) => Text(value.value.toString()),
      // using ascending order, because increase in film speed rises EV
      evDifferenceBuilder: (selected, other) => selected.toStringDifference(other),
      onChanged: onChanged,
    );
  }
}

class _NdValueTile extends StatelessWidget {
  final NdValue value;
  final ValueChanged<NdValue> onChanged;

  const _NdValueTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _AnimatedDialogPicker<NdValue>(
      title: S.of(context).nd,
      subtitle: S.of(context).ndFilterFactor,
      selectedValue: value,
      values: ndValues,
      itemTitleBuilder: (_, value) => Text(value.value == 0 ? S.of(context).none : value.value.toString()),
      // using descending order, because ND filter darkens image & lowers EV
      evDifferenceBuilder: (selected, other) => other.toStringDifference(selected),
      onChanged: onChanged,
    );
  }
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
