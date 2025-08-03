import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/screens/shared/button/widget_button_filled_large.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

class LightmeterProOffering extends StatefulWidget {
  const LightmeterProOffering({super.key});

  @override
  State<LightmeterProOffering> createState() => _LightmeterProOfferingState();
}

class _LightmeterProOfferingState extends State<LightmeterProOffering> {
  late final Future<List<IAPProduct>> productsFuture;
  bool _isLoading = true;
  IAPProduct? monthly;
  IAPProduct? yearly;
  IAPProduct? lifetime;
  IAPProduct? selected;

  @override
  void initState() {
    super.initState();
    productsFuture = IAPProductsProvider.of(context).fetchProducts();
    productsFuture.then((products) async {
      monthly = products.firstWhereOrNull((p) => p.type == PurchaseType.monthly);
      yearly = products.firstWhereOrNull((p) => p.type == PurchaseType.yearly);
      lifetime = products.firstWhereOrNull((p) => p.type == PurchaseType.lifetime);
      selected = monthly ?? lifetime;
    }).onError((_, __) {
      ///
    }).whenComplete(() {
      _isLoading = false;
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (IAPProducts.isPro(context)) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimens.borderRadiusL),
          topRight: Radius.circular(Dimens.borderRadiusL),
        ),
        color: Theme.of(context).colorScheme.surfaceElevated1,
      ),
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.fromLTRB(
        Dimens.paddingM,
        Dimens.paddingM,
        Dimens.paddingM,
        Dimens.paddingM + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: Dimens.durationM,
            child: _isLoading
                ? const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _Products(
                    monthly: monthly,
                    yearly: yearly,
                    lifetime: lifetime,
                    selected: selected,
                    onProductSelected: (value) {
                      setState(() {
                        selected = value;
                      });
                    },
                  ),
          ),
          const SizedBox(height: Dimens.grid8),
          FilledButtonLarge(
            title: S.of(context).continuePurchase,
            onPressed: selected != null
                ? () {
                    IAPProductsProvider.of(context).buyPro(selected!);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _Products extends StatelessWidget {
  const _Products({
    this.monthly,
    this.yearly,
    this.lifetime,
    required this.selected,
    required this.onProductSelected,
  });

  final IAPProduct? monthly;
  final IAPProduct? yearly;
  final IAPProduct? lifetime;
  final IAPProduct? selected;
  final ValueChanged<IAPProduct> onProductSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (monthly case final monthly?)
          Padding(
            padding: const EdgeInsets.only(bottom: Dimens.paddingS),
            child: _ProductItem(
              title: S.of(context).monthly,
              price: S.of(context).pricePerMonth(monthly.price),
              isSelected: selected == monthly,
              onPressed: () => onProductSelected(monthly),
            ),
          ),
        if (yearly case final yearly?)
          Padding(
            padding: const EdgeInsets.only(bottom: Dimens.paddingS),
            child: _ProductItem(
              title: S.of(context).yearly,
              price: S.of(context).pricePerYear(yearly.price),
              isSelected: selected == yearly,
              onPressed: () => onProductSelected(yearly),
            ),
          ),
        if (lifetime case final lifetime?)
          _ProductItem(
            title: S.of(context).lifetime,
            price: lifetime.price,
            isSelected: selected == lifetime,
            onPressed: () => onProductSelected(lifetime),
          ),
      ],
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({
    required this.title,
    required this.price,
    required this.isSelected,
    required this.onPressed,
  });

  final String title;
  final String price;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceElevated2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.borderRadiusM),
        side: isSelected
            ? BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : BorderSide.none,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onPressed,
        child: Padding(
          /// [Radio] has 12pt paddings around the button.
          /// [Dimens.paddingM] - 12pt = 4pt
          padding: const EdgeInsets.fromLTRB(
            Dimens.grid4,
            Dimens.grid4,
            Dimens.paddingM,
            Dimens.grid4,
          ),
          child: Row(
            children: [
              Radio(
                value: isSelected,
                groupValue: true,
                onChanged: (_) => onPressed(),
              ),
              _ProductAnimatedText(
                title,
                isSelected: isSelected,
              ),
              const Spacer(),
              _ProductAnimatedText(
                price,
                isSelected: isSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductAnimatedText extends StatelessWidget {
  const _ProductAnimatedText(this.text, {required this.isSelected});

  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: Dimens.durationM,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color:
                isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
          ),
      child: Text(text),
    );
  }
}
