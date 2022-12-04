import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/models/exposure_pair.dart';
import 'package:lightmeter/models/iso_value.dart';
import 'package:lightmeter/models/nd_value.dart';
import 'package:lightmeter/models/photography_value.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/shared/animated_dialog.dart';
import 'components/dialog_picker.dart';
import 'components/reading_container.dart';
import 'models/reading_value.dart';

class MeteringTopBar extends StatelessWidget {
  static const _columnsCount = 3;
  final _isoDialogKey = GlobalKey<AnimatedDialogState>();
  final _ndDialogKey = GlobalKey<AnimatedDialogState>();

  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final double ev;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;

  MeteringTopBar({
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
    final columnWidth =
        (MediaQuery.of(context).size.width - Dimens.paddingM * 2 - Dimens.grid16 * (_columnsCount - 1)) / 3;
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: columnWidth / 3 * 4,
                          child: ReadingContainer(
                            values: [
                              ReadingValue(
                                label: S.of(context).fastestExposurePair,
                                value: fastest != null
                                    ? '${fastest!.aperture.toString()} - ${fastest!.shutterSpeed.toString()}'
                                    : 'N/A',
                              ),
                              ReadingValue(
                                label: S.of(context).slowestExposurePair,
                                value: fastest != null
                                    ? '${slowest!.aperture.toString()} - ${slowest!.shutterSpeed.toString()}'
                                    : 'N/A',
                              ),
                            ],
                          ),
                        ),
                        const _InnerPadding(),
                        Row(
                          children: [
                            SizedBox(
                              width: columnWidth,
                              child: ReadingContainer.singleValue(
                                value: ReadingValue(
                                  label: 'EV',
                                  value: ev.toStringAsFixed(1),
                                ),
                              ),
                            ),
                            const _InnerPadding(),
                            SizedBox(
                              width: columnWidth,
                              child: AnimatedDialog(
                                key: _isoDialogKey,
                                closedChild: ReadingContainer.singleValue(
                                  value: ReadingValue(
                                    label: S.of(context).iso,
                                    value: iso.value.toString(),
                                  ),
                                ),
                                openedChild: MeteringScreenDialogPicker(
                                  title: S.of(context).iso,
                                  initialValue: iso,
                                  values: isoValues,
                                  itemTitleBuilder: (context, value) => Text(
                                    value.value.toString(),
                                    style: value.stopType == StopType.full
                                        ? Theme.of(context).textTheme.bodyLarge
                                        : Theme.of(context).textTheme.bodySmall,
                                  ),
                                  onCancel: () {
                                    _isoDialogKey.currentState?.close();
                                  },
                                  onSelect: (value) {
                                    _isoDialogKey.currentState?.close().then((_) => onIsoChanged(value));
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const _InnerPadding(),
                  SizedBox(
                    width: columnWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AnimatedDialog(
                          openedSize: Size(
                            MediaQuery.of(context).size.width - Dimens.paddingM * 2,
                            (MediaQuery.of(context).size.width - Dimens.paddingM * 2) / 3 * 4,
                          ),
                          child: const AspectRatio(
                            aspectRatio: 3 / 4,
                            child: ColoredBox(color: Colors.black),
                          ),
                        ),
                        const _InnerPadding(),
                        AnimatedDialog(
                          key: _ndDialogKey,
                          closedChild: ReadingContainer.singleValue(
                            value: ReadingValue(
                              label: S.of(context).nd,
                              value: nd.value.toString(),
                            ),
                          ),
                          openedChild: MeteringScreenDialogPicker(
                            title: S.of(context).nd,
                            initialValue: nd,
                            values: ndValues,
                            itemTitleBuilder: (context, value) => Text(
                              value.value == 0 ? S.of(context).none : value.value.toString(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            onCancel: () {
                              _ndDialogKey.currentState?.close();
                            },
                            onSelect: (value) {
                              _ndDialogKey.currentState?.close().then((_) => onNdChanged(value));
                            },
                          ),
                        ),
                      ],
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
  const _InnerPadding() : super(height: Dimens.grid16, width: Dimens.grid16);
}
