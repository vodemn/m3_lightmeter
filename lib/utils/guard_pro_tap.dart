import 'package:flutter/material.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/utils/context_utils.dart';

void guardProTap(BuildContext context, VoidCallback callback) {
  if (context.isPro) {
    callback();
  } else {
    Navigator.of(context).pushNamed(NavigationRoutes.proFeaturesScreen.name);
  }
}
