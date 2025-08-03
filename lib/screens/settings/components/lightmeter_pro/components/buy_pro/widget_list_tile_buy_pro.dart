import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/routes.dart';

class BuyProListTile extends StatelessWidget {
  const BuyProListTile({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement pending handling via REvenueCat
    return ListTile(
      leading: const Icon(Icons.bolt),
      title: Text(S.of(context).getPro),
      onTap: () {
        Navigator.of(context).pushNamed(NavigationRoutes.proFeaturesScreen.name);
      },
    );
  }
}
