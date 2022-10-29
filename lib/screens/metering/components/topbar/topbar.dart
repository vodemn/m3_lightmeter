import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/topbar/components/reading_container.dart';
import 'package:lightmeter/screens/metering/components/topbar/topbar_shape.dart';
import 'package:lightmeter/utils/text_line_height.dart';

class MeteringTopBar extends StatelessWidget {
  static const _columnsCount = 3;

  final double ev;
  final int iso;
  final double nd;

  const MeteringTopBar({
    required this.ev,
    required this.iso,
    required this.nd,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final columnWidth =
        (MediaQuery.of(context).size.width - Dimens.paddingM * 2 - Dimens.grid16 * (_columnsCount - 1)) / 3;
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.paddingM),
        child: SafeArea(
          bottom: false,
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
                        values: const [
                          ReadingValue(
                            label: 'Fastest',
                            value: 'f/5.6 - 1/2000',
                          ),
                          ReadingValue(
                            label: 'Slowest',
                            value: 'f/45 - 1/30',
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
                              value: ev.toString(),
                            ),
                          ),
                        ),
                        const _InnerPadding(),
                        SizedBox(
                          width: columnWidth,
                          child: ReadingContainer.singleValue(
                            value: ReadingValue(
                              label: 'ISO',
                              value: iso.toString(),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimens.borderRadiusM),
                      child: const AspectRatio(
                        aspectRatio: 3 / 4,
                        child: ColoredBox(color: Colors.black),
                      ),
                    ),
                    const _InnerPadding(),
                    ReadingContainer.singleValue(
                      value: ReadingValue(
                        label: 'ND',
                        value: nd.toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InnerPadding extends SizedBox {
  const _InnerPadding() : super(height: Dimens.grid16, width: Dimens.grid16);
}
