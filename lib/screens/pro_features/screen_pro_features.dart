import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/app_feature.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/screens/settings/components/about/widget_settings_section_about.dart';
import 'package:lightmeter/screens/settings/components/general/widget_settings_section_general.dart';
import 'package:lightmeter/screens/settings/components/lightmeter_pro/widget_settings_section_lightmeter_pro.dart';
import 'package:lightmeter/screens/settings/components/metering/widget_settings_section_metering.dart';
import 'package:lightmeter/screens/settings/components/theme/widget_settings_section_theme.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:lightmeter/utils/text_height.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

class ProFeaturesScreen extends StatefulWidget {
  const ProFeaturesScreen({super.key});

  @override
  State<ProFeaturesScreen> createState() => _ProFeaturesScreenState();
}

class _ProFeaturesScreenState extends State<ProFeaturesScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Column(
        children: [
          Expanded(
            child: SliverScreen(
              title: S.of(context).proFeatures,
              slivers: [
                const SliverToBoxAdapter(child: _FeaturesHeader()),
                SliverList.separated(
                  itemCount: AppFeature.values.length,
                  itemBuilder: (context, index) {
                    return _FeatureItem(feature: AppFeature.values[index]);
                  },
                  separatorBuilder: (_, __) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.paddingM),
                    child: Divider(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: Dimens.grid16)),
              ],
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.surfaceElevated1,
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.fromLTRB(
              Dimens.paddingM,
              Dimens.paddingM,
              Dimens.paddingM,
              MediaQuery.paddingOf(context).bottom,
            ),
            child: FilledButton(
              onPressed: () {},
              child: Text(S.of(context).unlockFor(IAPProducts.productOf(context, IAPProductType.paidFeatures)!.price)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturesHeader extends StatelessWidget {
  const _FeaturesHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        _FeatureHighlight(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.paddingM,
                vertical: Dimens.paddingS,
              ),
              child: Text('Free'),
            ),
          ),
        ),
        _FeatureHighlight(
          roundedTop: true,
          highlight: true,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.paddingM,
                vertical: Dimens.paddingS,
              ),
              child: Text(
                'Pro',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
            ),
          ),
        ),
        const SizedBox(width: Dimens.grid16),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final AppFeature feature;

  const _FeatureItem({
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: Dimens.grid48),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.paddingM,
                    vertical: Dimens.paddingS,
                  ),
                  child: Text(
                    feature.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: feature.isFree ? 1 : 0,
              child: const _CheckBox(highlight: false),
            ),
            _FeatureHighlight(
              highlight: true,
              roundedBottom: feature == AppFeature.values.last,
              child: const _CheckBox(highlight: true),
            ),
            const SizedBox(width: Dimens.grid16),
          ],
        ),
      ),
    );
  }
}

class _FeatureHighlight extends StatelessWidget {
  static double? _freeWidth;
  static double? _proWidth;

  final bool highlight;
  final bool roundedTop;
  final bool roundedBottom;
  final Widget child;

  const _FeatureHighlight({
    this.highlight = false,
    this.roundedTop = false,
    this.roundedBottom = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    _FeatureHighlight._freeWidth ??= textSize(
      'Free',
      Theme.of(context).textTheme.bodyMedium,
      MediaQuery.sizeOf(context).width,
    ).width;
    _FeatureHighlight._proWidth ??= textSize(
      'Pro',
      Theme.of(context).textTheme.bodyMedium,
      MediaQuery.sizeOf(context).width,
    ).width;
    return Container(
      constraints:
          BoxConstraints(minWidth: (highlight ? _FeatureHighlight._proWidth : _FeatureHighlight._freeWidth) ?? 0.0),
      decoration: BoxDecoration(
        color: highlight ? Theme.of(context).colorScheme.secondaryContainer : null,
        borderRadius: roundedTop
            ? const BorderRadius.only(
                topLeft: Radius.circular(Dimens.borderRadiusM),
                topRight: Radius.circular(Dimens.borderRadiusM),
              )
            : roundedBottom
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(Dimens.borderRadiusM),
                    bottomRight: Radius.circular(Dimens.borderRadiusM),
                  )
                : null,
      ),
      child: child,
    );
  }
}

class _CheckBox extends StatelessWidget {
  final bool highlight;

  const _CheckBox({required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.paddingM,
        vertical: Dimens.paddingS,
      ),
      child: Icon(
        Icons.check_outlined,
        color: highlight ? Theme.of(context).colorScheme.onSecondaryContainer : null,
      ),
    );
  }
}
