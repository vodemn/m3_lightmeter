import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/utils/guard_pro_tap.dart';

class FilmsListTile extends StatelessWidget {
  const FilmsListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.camera_roll_outlined),
      title: Text(S.of(context).films),
      onTap: () {
        guardProTap(
          context,
          () {
            Navigator.of(context).pushNamed(NavigationRoutes.filmsListScreen.name);
          },
        );
      },
    );
  }
}
