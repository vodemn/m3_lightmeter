import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/topbar/components/reading_container.dart';
import 'package:lightmeter/screens/metering/components/topbar/topbar_shape.dart';
import 'package:lightmeter/utils/text_line_height.dart';

class MeteringTopBar extends StatelessWidget {
  static const _columnsCount = 3;

  final double lux;
  final double ev;
  final int iso;
  final double nd;

  const MeteringTopBar({
    required this.lux,
    required this.ev,
    required this.iso,
    required this.nd,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final columnWidth = (MediaQuery.of(context).size.width - Dimens.paddingM * (_columnsCount + 1)) / 3;
    return CustomPaint(
      painter: TopBarShape(
        color: Theme.of(context).colorScheme.surface,
        appendixSize: Size(
          (MediaQuery.of(context).size.width - Dimens.paddingM * 4) / 3 + Dimens.paddingM * 2,
          Dimens.paddingM +
              Theme.of(context).textTheme.labelMedium!.lineHeight +
              Dimens.grid4 +
              Theme.of(context).textTheme.titleLarge!.lineHeight +
              Dimens.paddingM * 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.paddingM),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
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
                    SizedBox(
                      width: columnWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.borderRadiusM),
                        child: const AspectRatio(
                          aspectRatio: 3 / 4,
                          child: ColoredBox(color: Colors.black),
                        ),
                      ),
                    )
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
                        label: 'LUX',
                        value: lux.toString(),
                      ),
                    ),
                  ),
                  const _InnerPadding(),
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
              ),
              const _InnerPadding(),
              Row(
                children: [
                  const Spacer(),
                  const _InnerPadding(),
                  const Spacer(),
                  const _InnerPadding(),
                  SizedBox(
                    width: columnWidth,
                    child: ReadingContainer.singleValue(
                      value: ReadingValue(
                        label: 'ND',
                        value: nd.toString(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InnerPadding extends SizedBox {
  const _InnerPadding() : super(height: Dimens.paddingM, width: Dimens.borderRadiusM);
}
