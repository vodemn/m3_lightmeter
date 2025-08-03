import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

class LightmeterProBottomControls extends StatefulWidget {
  const LightmeterProBottomControls({super.key});

  @override
  State<LightmeterProBottomControls> createState() => _LightmeterProBottomControlsState();
}

class _LightmeterProBottomControlsState extends State<LightmeterProBottomControls> {
  late final Future<List<IAPProduct>> productsFuture;
  bool _isLoading = true;
  IAPProduct? monthly;
  IAPProduct? lifetime;
  IAPProduct? selected;

  @override
  void initState() {
    super.initState();
    productsFuture = IAPProductsProvider.of(context).fetchProducts();
    productsFuture.then((products) {
      monthly = products.firstWhereOrNull((p) => p.type == PurchaseType.monthly);
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
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceElevated1,
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.fromLTRB(
        Dimens.paddingM,
        Dimens.paddingM,
        Dimens.paddingM,
        Dimens.paddingM + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSwitcher(
            duration: Dimens.durationM,
            child: _isLoading
                ? const CircularProgressIndicator()
                : _Products(
                    monthly: monthly,
                    lifetime: lifetime,
                    selected: selected,
                    onProductSelected: (value) {
                      setState(() {
                        selected = value;
                      });
                    },
                  ),
          ),
          const SizedBox(height: Dimens.grid16),
          FilledButton(
            onPressed: selected != null
                ? () {
                    IAPProductsProvider.of(context).buyPro(selected!);
                  }
                : null,
            child: Text("Continue"),
          ),
          const _RestorePurchasesButton(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _Products extends StatelessWidget {
  const _Products({
    this.monthly,
    this.lifetime,
    required this.selected,
    required this.onProductSelected,
  });

  final IAPProduct? monthly;
  final IAPProduct? lifetime;
  final IAPProduct? selected;
  final ValueChanged<IAPProduct> onProductSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (monthly case final monthly?)
          _OfferingItems(
            product: monthly,
            isSelected: selected == monthly,
            onPressed: () => onProductSelected(monthly),
          ),
        const SizedBox(height: Dimens.grid8),
        if (lifetime case final lifetime?)
          _OfferingItems(
            product: lifetime,
            isSelected: selected == lifetime,
            onPressed: () => onProductSelected(lifetime),
          ),
      ],
    );
  }
}

class _OfferingItems extends StatelessWidget {
  const _OfferingItems({
    required this.product,
    required this.isSelected,
    required this.onPressed,
  });

  final IAPProduct product;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: isSelected
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.borderRadiusL),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
            )
          : null,
      child: GestureDetector(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.paddingS),
          child: ListTile(
            title: AnimatedDefaultTextStyle(
              duration: Dimens.durationM,
              style: Theme.of(context).textTheme.bodyLarge!.boldIfSelected(isSelected),
              child: Text(product.type.name),
            ),
            trailing: AnimatedDefaultTextStyle(
              duration: Dimens.durationM,
              style: Theme.of(context).textTheme.bodyMedium!.boldIfSelected(isSelected),
              child: Text(product.price),
            ),
          ),
        ),
      ),
    );
  }
}

class _RestorePurchasesButton extends StatelessWidget {
  const _RestorePurchasesButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(S.of(context).restorePurchases),
    );
  }
}

extension on TextStyle {
  TextStyle boldIfSelected(bool isSelected) => copyWith(fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal);
}
