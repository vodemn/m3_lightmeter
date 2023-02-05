import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class CameraViewPlaceholder extends StatelessWidget {
  const CameraViewPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.borderRadiusM)),
      child: const Center(child: Icon(Icons.no_photography)),
    );
  }
}
