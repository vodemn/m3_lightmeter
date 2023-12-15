import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/feature.dart';
import 'package:lightmeter/data/remote_config_service.dart';
import 'package:lightmeter/providers/remote_config_provider.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemoteConfigService extends Mock implements RemoteConfigService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _MockRemoteConfigService mockRemoteConfigService;

  setUpAll(() {
    mockRemoteConfigService = _MockRemoteConfigService();
  });

  setUp(() {
    when(() => mockRemoteConfigService.fetchConfig()).thenAnswer((_) async {});
    when(() => mockRemoteConfigService.getValue(Feature.unlockProFeaturesText)).thenReturn(false);
    when(() => mockRemoteConfigService.getAll()).thenReturn({Feature.unlockProFeaturesText: false});
  });

  tearDown(() {
    reset(mockRemoteConfigService);
  });

  Future<void> pumpTestWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      RemoteConfigProvider(
        remoteConfigService: mockRemoteConfigService,
        child: const _Application(),
      ),
    );
  }

  testWidgets(
    'RemoteConfigProvider init',
    (tester) async {
      when(() => mockRemoteConfigService.onConfigUpdated()).thenAnswer((_) => const Stream.empty());

      await pumpTestWidget(tester);
      expect(find.text('unlockProFeaturesText: false'), findsOneWidget);
    },
  );

  testWidgets(
    'RemoteConfigProvider updates stream',
    (tester) async {
      final StreamController<Set<Feature>> remoteConfigUpdateController = StreamController<Set<Feature>>();
      when(() => mockRemoteConfigService.onConfigUpdated()).thenAnswer((_) => remoteConfigUpdateController.stream);

      await pumpTestWidget(tester);
      expect(find.text('unlockProFeaturesText: false'), findsOneWidget);

      when(() => mockRemoteConfigService.getValue(Feature.unlockProFeaturesText)).thenReturn(true);
      remoteConfigUpdateController.add({Feature.unlockProFeaturesText});
      await tester.pumpAndSettle();
      expect(find.text('unlockProFeaturesText: true'), findsOneWidget);

      await remoteConfigUpdateController.close();
    },
  );

  test('RemoteConfig.updateShouldNotifyDependent', () {
    const config = RemoteConfig(config: {Feature.unlockProFeaturesText: false}, child: SizedBox());
    expect(
      config.updateShouldNotifyDependent(config, {}),
      false,
    );
    expect(
      config.updateShouldNotifyDependent(
        const RemoteConfig(config: {Feature.unlockProFeaturesText: false}, child: SizedBox()),
        {Feature.unlockProFeaturesText},
      ),
      false,
    );
    expect(
      config.updateShouldNotifyDependent(
        const RemoteConfig(config: {Feature.unlockProFeaturesText: true}, child: SizedBox()),
        {Feature.unlockProFeaturesText},
      ),
      true,
    );
  });
}

class _Application extends StatelessWidget {
  const _Application();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            "${Feature.unlockProFeaturesText.name}: ${RemoteConfig.isEnabled(context, Feature.unlockProFeaturesText)}",
          ),
        ),
      ),
    );
  }
}
