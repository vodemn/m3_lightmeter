import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:lightmeter/application_wrapper.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

import '../integration_test/mocks/paid_features_mock.dart';
import '../integration_test/utils/platform_channel_mock.dart';

/// Provides [MaterialApp] with default theme and "en" localization
class WidgetTestApplicationMock extends StatelessWidget {
  final Widget child;

  const WidgetTestApplicationMock({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeFrom(primaryColorsList[5], Brightness.light),
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: child!,
      ),
      home: Scaffold(body: child),
    );
  }
}

class GoldenTestApplicationMock extends StatefulWidget {
  final IAPProductStatus productStatus;
  final Widget child;

  const GoldenTestApplicationMock({
    this.productStatus = IAPProductStatus.purchased,
    required this.child,
    super.key,
  });

  @override
  State<GoldenTestApplicationMock> createState() => _GoldenTestApplicationMockState();
}

class _GoldenTestApplicationMockState extends State<GoldenTestApplicationMock> {
  @override
  void initState() {
    super.initState();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      LightSensor.methodChannel,
      (methodCall) async {
        switch (methodCall.method) {
          case "sensor":
            return true;
          default:
            return null;
        }
      },
    );
    setupLightSensorStreamHandler();
  }

  @override
  void dispose() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      LightSensor.methodChannel,
      null,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IAPProducts(
      products: [
        IAPProduct(
          storeId: IAPProductType.paidFeatures.storeId,
          status: widget.productStatus,
        ),
      ],
      child: ApplicationWrapper(
        const Environment.dev(),
        child: MockIAPProviders(
          equipmentProfiles: mockEquipmentProfiles,
          selectedEquipmentProfileId: mockEquipmentProfiles.first.id,
          films: films,
          child: Builder(
            builder: (context) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: UserPreferencesProvider.themeOf(context),
                locale: Locale(UserPreferencesProvider.localeOf(context).intlName),
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                ),
                home: widget.child,
              );
            },
          ),
        ),
      ),
    );
  }
}
