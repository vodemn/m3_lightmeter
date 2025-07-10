import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/logbook/screen_logbook.dart';

class LogbookListTile extends StatelessWidget {
  const LogbookListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.book_outlined),
      title: Text(S.of(context).logbook),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LogbookScreen()),
        );
      },
    );
  }
}
