import 'package:flutter/material.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/utils/context_utils.dart';

Future<void> guardProTap(BuildContext context, VoidCallback callback) async {
  if (context.isPro) {
    callback();
  } else {
    final isPro = await Navigator.of(context).pushNamed(NavigationRoutes.proFeaturesScreen.name);
    if (isPro == true) {
      callback();
    }
  }
}
