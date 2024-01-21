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
    when(() => mockRemoteConfigService.getValue(Feature.showUnlockProOnMainScreen)).thenReturn(false);
    when(() => mockRemoteConfigService.getAll()).thenReturn({Feature.showUnlockProOnMainScreen: false});
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
      expect(find.text('showUnlockProOnMainScreen: false'), findsOneWidget);
    },
  );

  testWidgets(
    'RemoteConfigProvider updates stream',
    (tester) async {
      final StreamController<Set<Feature>> remoteConfigUpdateController = StreamController<Set<Feature>>();
      when(() => mockRemoteConfigService.onConfigUpdated()).thenAnswer((_) => remoteConfigUpdateController.stream);

      await pumpTestWidget(tester);
      expect(find.text('showUnlockProOnMainScreen: false'), findsOneWidget);

      when(() => mockRemoteConfigService.getValue(Feature.showUnlockProOnMainScreen)).thenReturn(true);
      remoteConfigUpdateController.add({Feature.showUnlockProOnMainScreen});
      await tester.pumpAndSettle();
      expect(find.text('showUnlockProOnMainScreen: true'), findsOneWidget);

      await remoteConfigUpdateController.close();
    },
  );

  test('RemoteConfig.updateShouldNotifyDependent', () {
    const config = RemoteConfig(config: {Feature.showUnlockProOnMainScreen: false}, child: SizedBox());
    expect(
      config.updateShouldNotifyDependent(config, {}),
      false,
    );
    expect(
      config.updateShouldNotifyDependent(
        const RemoteConfig(config: {Feature.showUnlockProOnMainScreen: false}, child: SizedBox()),
        {Feature.showUnlockProOnMainScreen},
      ),
      false,
    );
    expect(
      config.updateShouldNotifyDependent(
        const RemoteConfig(config: {Feature.showUnlockProOnMainScreen: true}, child: SizedBox()),
        {Feature.showUnlockProOnMainScreen},
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
            "${Feature.showUnlockProOnMainScreen.name}: ${RemoteConfig.isEnabled(context, Feature.showUnlockProOnMainScreen)}",
          ),
        ),
      ),
    );
  }
}
