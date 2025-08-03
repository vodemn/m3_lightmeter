import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/app_feature.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/lightmeter_pro/components/offering/widget_offering_lightmeter_pro.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:lightmeter/utils/text_height.dart';

class LightmeterProScreen extends StatelessWidget {
  final features =
      defaultTargetPlatform == TargetPlatform.android ? AppFeature.androidFeatures : AppFeature.iosFeatures;

  LightmeterProScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SliverScreen(
            title: Text(S.of(context).proFeaturesTitle),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.paddingM),
                  child: Text(
                    S.of(context).proFeaturesPromoText,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Dimens.paddingM,
                    0,
                    Dimens.paddingM,
                    Dimens.paddingS,
                  ),
                  child: Text(
                    S.of(context).proFeaturesWhatsIncluded,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: _FeaturesHeader()),
              SliverList.separated(
                itemCount: features.length,
                itemBuilder: (_, index) => _FeatureItem(feature: features[index]),
                separatorBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.paddingM),
                  child: Divider(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.paddingM),
                  child: Text(S.of(context).proFeaturesSupportText),
                ),
              ),
            ],
          ),
        ),
        const LightmeterProBottomControls(),
      ],
    );
  }
}

class _FeaturesHeader extends StatelessWidget {
  const _FeaturesHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
      child: Row(
        children: [
          const Spacer(),
          _FeatureHighlight(child: Text(S.of(context).featuresFree)),
          _FeatureHighlight(
            roundedTop: true,
            highlight: true,
            child: Text(
              S.of(context).featuresPro,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
          ),
        ],
      ),
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
                    feature.name(context),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: feature.isFree ? 1 : 0,
              child: const _FeatureHighlight(
                child: _CheckBox(highlight: false),
              ),
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
    return Container(
      constraints: BoxConstraints(
        minWidth: textSize(
              highlight ? S.of(context).featuresPro : S.of(context).featuresFree,
              Theme.of(context).textTheme.bodyMedium,
              MediaQuery.sizeOf(context).width,
            ).width +
            Dimens.paddingM * 2,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.paddingM,
        vertical: Dimens.paddingS,
      ),
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
    return Icon(
      Icons.check_outlined,
      color: highlight ? Theme.of(context).colorScheme.onSecondaryContainer : null,
    );
  }
}
