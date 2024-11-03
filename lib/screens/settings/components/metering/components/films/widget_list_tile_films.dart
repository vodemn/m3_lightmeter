import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/screens/settings/components/shared/iap_list_tile/widget_list_tile_iap.dart';

class FilmsListTile extends StatelessWidget {
  const FilmsListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return IAPListTile(
      leading: const Icon(Icons.camera_roll_outlined),
      title: Text(S.of(context).films),
      onTap: () => Navigator.of(context).pushNamed(NavigationRoutes.filmsListScreen.name),
    );
  }
}
