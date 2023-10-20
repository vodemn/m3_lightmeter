import 'package:flutter/material.dart';
import 'package:lightmeter/application.dart';
import 'package:lightmeter/application_wrapper.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/firebase.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase(handleErrors: true);
  runApp(
    const IAPProductsProvider(
      child: ApplicationWrapper(
        Environment.prod(),
        child: Application(),
      ),
    ),
  );
}
