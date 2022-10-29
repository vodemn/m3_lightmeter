import 'package:flutter/material.dart';
import 'package:lightmeter/models/photography_value.dart';

import 'components/bottom_controls/bottom_controls.dart';
import 'components/exposure_pairs_list/exposure_pairs_list.dart';
import 'components/topbar/topbar.dart';

class MeteringScreen extends StatelessWidget {
  const MeteringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const ev = 0.3;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          const MeteringTopBar(
            ev: ev,
            iso: 6400,
            nd: 0,
          ),
          Expanded(
            child: ExposurePairsList(
              ev: ev,
              stopType: Stop.third,
            ),
          ),
          MeteringBottomControls(
            onSourceChanged: () {},
            onMeasure: () {},
            onSettings: () {},
          ),
        ],
      ),
    );
  }
}
