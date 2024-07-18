import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/app_feature.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:lightmeter/utils/text_height.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

class ProFeaturesScreen extends StatelessWidget {
  const ProFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SliverScreen(
            title: S.of(context).proFeaturesTitle,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.paddingM,
                    vertical: Dimens.paddingS,
                  ),
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
                    Dimens.paddingM,
                    Dimens.paddingM,
                    0,
                  ),
                  child: Text(
                    S.of(context).proFeaturesWhatsIncluded,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.paddingM),
                  child: Text(S.of(context).proFeaturesSupportText),
                ),
              ),
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
            Dimens.paddingM + MediaQuery.paddingOf(context).bottom,
          ),
          child: FilledButton(
            onPressed: () {
              ServicesProvider.maybeOf(context)
                  ?.analytics
                  .setCustomKey('iap_product_type', IAPProductType.paidFeatures.storeId);
              IAPProductsProvider.maybeOf(context)?.buy(IAPProductType.paidFeatures);
            },
            child: Text(S.of(context).unlockFor(IAPProducts.productOf(context, IAPProductType.paidFeatures)!.price)),
          ),
        ),
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
                    feature.name,
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
      S.of(context).featuresFree,
      Theme.of(context).textTheme.bodyMedium,
      MediaQuery.sizeOf(context).width,
    ).width;
    _FeatureHighlight._proWidth ??= textSize(
      S.of(context).featuresPro,
      Theme.of(context).textTheme.bodyMedium,
      MediaQuery.sizeOf(context).width,
    ).width;
    return Container(
      constraints: BoxConstraints(
        minWidth:
            ((highlight ? _FeatureHighlight._proWidth : _FeatureHighlight._freeWidth) ?? 0.0) + Dimens.paddingM * 2,
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
