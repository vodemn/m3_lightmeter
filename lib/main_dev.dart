import 'package:flutter/material.dart';
import 'package:lightmeter/application.dart';
import 'package:lightmeter/application_wrapper.dart';
import 'package:lightmeter/environment.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    IAPProducts(
      products: [IAPProduct(storeId: IAPProductType.paidFeatures.storeId)],
      child: const ApplicationWrapper(
        Environment.dev(),
        child: Application(),
      ),
    ),
  );
}
