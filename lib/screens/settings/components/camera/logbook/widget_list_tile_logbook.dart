import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/routes.dart';

class LogbookListTile extends StatelessWidget {
  const LogbookListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.book_outlined),
      title: Text(S.of(context).logbook),
      onTap: () {
        Navigator.of(context).pushNamed(NavigationRoutes.logbookPhotosListScreen.name);
      },
    );
  }
}
