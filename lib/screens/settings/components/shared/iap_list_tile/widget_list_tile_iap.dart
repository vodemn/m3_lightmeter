import 'package:flutter/material.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/utils/context_utils.dart';

class IAPListTile extends StatelessWidget {
  final Icon leading;
  final Text title;
  final VoidCallback onTap;

  const IAPListTile({
    required this.leading,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      onTap: context.isPro
          ? onTap
          : () {
              Navigator.of(context).pushNamed(NavigationRoutes.proFeaturesScreen.name);
            },
    );
  }
}
