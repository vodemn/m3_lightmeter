import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:lightmeter/application.dart';
import 'package:lightmeter/application_wrapper.dart';
import 'package:lightmeter/data/analytics/analytics.dart';
import 'package:lightmeter/data/analytics/api/analytics_firebase.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/firebase_options.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

const _errorsLogger = LightmeterAnalytics(api: LightmeterAnalyticsFirebase());

Future<void> runLightmeterApp(Environment env) async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      if (env.buildType == BuildType.prod) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }
      _errorsLogger.init();
      final application = ApplicationWrapper(env, child: const Application());
      runApp(
        env.buildType == BuildType.dev
            ? IAPProducts(
                products: [IAPProduct(storeId: IAPProductType.paidFeatures.storeId)],
                child: application,
              )
            : IAPProductsProvider(child: application),
      );
    },
    _errorsLogger.logCrash,
  );
}
