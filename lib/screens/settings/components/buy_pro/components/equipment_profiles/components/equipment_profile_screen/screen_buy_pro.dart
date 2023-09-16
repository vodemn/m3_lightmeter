import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';

class BuyProScreen extends StatelessWidget {
  const BuyProScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScreen(
      title: S.of(context).lightmeterPro,
      appBarActions: [
        IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.close),
        ),
      ],
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Text(S.of(context).lightmeterProDescription),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(S.of(context).buy),
                  ),
                ],
              )
            ],
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom)),
      ],
    );
  }
}
