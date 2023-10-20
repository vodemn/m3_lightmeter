import 'package:dynamic_color/test_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserPreferencesService extends Mock implements UserPreferencesService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockUserPreferencesService mockUserPreferencesService;

  setUpAll(() {
    mockUserPreferencesService = _MockUserPreferencesService();
  });

  setUp(() {
    when(() => mockUserPreferencesService.evSourceType).thenReturn(EvSourceType.camera);
    when(() => mockUserPreferencesService.stopType).thenReturn(StopType.third);
    when(() => mockUserPreferencesService.meteringScreenLayout).thenReturn({
      MeteringScreenLayoutFeature.extremeExposurePairs: true,
      MeteringScreenLayoutFeature.filmPicker: true,
      MeteringScreenLayoutFeature.equipmentProfiles: true,
      MeteringScreenLayoutFeature.histogram: true,
    });
    when(() => mockUserPreferencesService.locale).thenReturn(SupportedLocale.en);
    when(() => mockUserPreferencesService.themeType).thenReturn(ThemeType.light);
    when(() => mockUserPreferencesService.primaryColor).thenReturn(primaryColorsList[5]);
    when(() => mockUserPreferencesService.dynamicColor).thenReturn(false);
  });

  tearDown(() {
    reset(mockUserPreferencesService);
  });

  Future<void> pumpTestWidget(
    WidgetTester tester, {
    bool hasLightSensor = true,
    required WidgetBuilder builder,
  }) async {
    await tester.pumpWidget(
      UserPreferencesProvider(
        hasLightSensor: hasLightSensor,
        userPreferencesService: mockUserPreferencesService,
        child: _Application(builder: builder),
      ),
    );
  }

  group('[evSourceType]', () {
    Future<void> pumpEvTestApplication(WidgetTester tester, {required bool hasLightSensor}) async {
      await pumpTestWidget(
        tester,
        hasLightSensor: hasLightSensor,
        builder: (context) => Column(
          children: [
            Text('EV source type: ${UserPreferencesProvider.evSourceTypeOf(context)}'),
            ElevatedButton(
              onPressed: UserPreferencesProvider.of(context).toggleEvSourceType,
              child: const Text('toggleEvSourceType'),
            ),
          ],
        ),
      );
    }

    void expectEvSource(EvSourceType evSourceType) {
      expect(find.text("EV source type: $evSourceType"), findsOneWidget);
    }

    testWidgets(
      'Init evSourceType when has sensor & stored sensor',
      (tester) async {
        when(() => mockUserPreferencesService.evSourceType).thenReturn(EvSourceType.sensor);
        await pumpEvTestApplication(tester, hasLightSensor: true);
        expectEvSource(EvSourceType.sensor);
      },
    );

    testWidgets(
      'Init evSourceType when has no sensor & stored camera',
      (tester) async {
        when(() => mockUserPreferencesService.evSourceType).thenReturn(EvSourceType.camera);
        await pumpEvTestApplication(tester, hasLightSensor: false);
        expectEvSource(EvSourceType.camera);
      },
    );

    testWidgets(
      'Init evSourceType when has no sensor & stored sensor -> Reset to camera',
      (tester) async {
        when(() => mockUserPreferencesService.evSourceType).thenReturn(EvSourceType.sensor);
        await pumpEvTestApplication(tester, hasLightSensor: false);
        expectEvSource(EvSourceType.camera);
      },
    );

    testWidgets(
      'Try toggleEvSourceType() when has no sensor',
      (tester) async {
        when(() => mockUserPreferencesService.evSourceType).thenReturn(EvSourceType.camera);
        await pumpEvTestApplication(tester, hasLightSensor: false);
        await tester.tap(find.text('toggleEvSourceType'));
        await tester.pumpAndSettle();
        verifyNever(() => mockUserPreferencesService.evSourceType = EvSourceType.sensor);
      },
    );

    testWidgets(
      'Try toggleEvSourceType() when has sensor',
      (tester) async {
        when(() => mockUserPreferencesService.evSourceType).thenReturn(EvSourceType.camera);
        await pumpEvTestApplication(tester, hasLightSensor: true);

        await tester.tap(find.text('toggleEvSourceType'));
        await tester.pumpAndSettle();
        expectEvSource(EvSourceType.sensor);
        verify(() => mockUserPreferencesService.evSourceType = EvSourceType.sensor).called(1);

        await tester.tap(find.text('toggleEvSourceType'));
        await tester.pumpAndSettle();
        expectEvSource(EvSourceType.camera);
        verify(() => mockUserPreferencesService.evSourceType = EvSourceType.camera).called(1);
      },
    );
  });

  testWidgets(
    'Set different stop type',
    (tester) async {
      when(() => mockUserPreferencesService.stopType).thenReturn(StopType.third);
      await pumpTestWidget(
        tester,
        builder: (context) => Column(
          children: [
            Text('Stop type: ${UserPreferencesProvider.stopTypeOf(context)}'),
            ElevatedButton(
              onPressed: () => UserPreferencesProvider.of(context).setStopType(StopType.full),
              child: const Text('setStopType'),
            ),
          ],
        ),
      );
      expect(find.text("Stop type: ${StopType.third}"), findsOneWidget);

      await tester.tap(find.text('setStopType'));
      await tester.pumpAndSettle();
      expect(find.text("Stop type: ${StopType.full}"), findsOneWidget);
      verify(() => mockUserPreferencesService.stopType = StopType.full).called(1);
    },
  );

  testWidgets(
    'Set metering screen layout config',
    (tester) async {
      await pumpTestWidget(
        tester,
        builder: (context) {
          final config = UserPreferencesProvider.meteringScreenConfigOf(context);
          return Column(
            children: [
              ...List.generate(
                config.length,
                (index) => Text('${config.keys.toList()[index]}: ${config.values.toList()[index]}'),
              ),
              ...List.generate(
                MeteringScreenLayoutFeature.values.length,
                (index) => Text(
                  '${MeteringScreenLayoutFeature.values[index]}: ${UserPreferencesProvider.meteringScreenFeatureOf(context, MeteringScreenLayoutFeature.values[index])}',
                ),
              ),
              ElevatedButton(
                onPressed: () => UserPreferencesProvider.of(context).setMeteringScreenLayout({
                  MeteringScreenLayoutFeature.equipmentProfiles: true,
                  MeteringScreenLayoutFeature.extremeExposurePairs: false,
                  MeteringScreenLayoutFeature.filmPicker: false,
                  MeteringScreenLayoutFeature.histogram: true,
                }),
                child: const Text(''),
              ),
            ],
          );
        },
      );
      // Match `findsNWidgets(2)` to verify that `meteringScreenFeatureOf` specific results are the same as the whole config
      expect(find.text("${MeteringScreenLayoutFeature.equipmentProfiles}: true"), findsNWidgets(2));
      expect(find.text("${MeteringScreenLayoutFeature.extremeExposurePairs}: true"), findsNWidgets(2));
      expect(find.text("${MeteringScreenLayoutFeature.filmPicker}: true"), findsNWidgets(2));
      expect(find.text("${MeteringScreenLayoutFeature.histogram}: true"), findsNWidgets(2));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("${MeteringScreenLayoutFeature.equipmentProfiles}: true"), findsNWidgets(2));
      expect(find.text("${MeteringScreenLayoutFeature.extremeExposurePairs}: false"), findsNWidgets(2));
      expect(find.text("${MeteringScreenLayoutFeature.filmPicker}: false"), findsNWidgets(2));
      expect(find.text("${MeteringScreenLayoutFeature.histogram}: true"), findsNWidgets(2));
      verify(
        () => mockUserPreferencesService.meteringScreenLayout = {
          MeteringScreenLayoutFeature.extremeExposurePairs: false,
          MeteringScreenLayoutFeature.filmPicker: false,
          MeteringScreenLayoutFeature.equipmentProfiles: true,
          MeteringScreenLayoutFeature.histogram: true,
        },
      ).called(1);
    },
  );

  testWidgets(
    'Set different locale',
    (tester) async {
      when(() => mockUserPreferencesService.locale).thenReturn(SupportedLocale.en);
      await pumpTestWidget(
        tester,
        builder: (context) => ElevatedButton(
          onPressed: () => UserPreferencesProvider.of(context).setLocale(SupportedLocale.fr),
          child: Text('${UserPreferencesProvider.localeOf(context)}'),
        ),
      );
      expect(find.text("${SupportedLocale.en}"), findsOneWidget);

      await tester.tap(find.text("${SupportedLocale.en}"));
      await tester.pumpAndSettle();
      expect(find.text("${SupportedLocale.fr}"), findsOneWidget);
      verify(() => mockUserPreferencesService.locale = SupportedLocale.fr).called(1);
    },
  );

  group('[theme]', () {
    testWidgets(
      'Set dark theme type',
      (tester) async {
        when(() => mockUserPreferencesService.themeType).thenReturn(ThemeType.light);
        await pumpTestWidget(
          tester,
          builder: (context) => Column(
            children: [
              ElevatedButton(
                onPressed: () => UserPreferencesProvider.of(context).setThemeType(ThemeType.dark),
                child: Text('${UserPreferencesProvider.themeTypeOf(context)}'),
              ),
              Text('${Theme.of(context).colorScheme.brightness}')
            ],
          ),
        );
        expect(find.text("${ThemeType.light}"), findsOneWidget);
        expect(find.text("${Brightness.light}"), findsOneWidget);

        await tester.tap(find.text("${ThemeType.light}"));
        await tester.pumpAndSettle();
        expect(find.text("${ThemeType.dark}"), findsOneWidget);
        expect(find.text("${Brightness.dark}"), findsOneWidget);
        verify(() => mockUserPreferencesService.themeType = ThemeType.dark).called(1);
      },
    );

    testWidgets(
      'Set systemDefault theme type and toggle platform brightness',
      (tester) async {
        when(() => mockUserPreferencesService.themeType).thenReturn(ThemeType.light);
        await pumpTestWidget(
          tester,
          builder: (context) => Column(
            children: [
              ElevatedButton(
                onPressed: () => UserPreferencesProvider.of(context).setThemeType(ThemeType.systemDefault),
                child: Text('${UserPreferencesProvider.themeTypeOf(context)}'),
              ),
              Text('${Theme.of(context).colorScheme.brightness}')
            ],
          ),
        );
        TestWidgetsFlutterBinding.instance.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
        expect(find.text("${ThemeType.light}"), findsOneWidget);
        expect(find.text("${Brightness.light}"), findsOneWidget);

        await tester.tap(find.text("${ThemeType.light}"));
        await tester.pumpAndSettle();
        expect(find.text("${ThemeType.systemDefault}"), findsOneWidget);
        expect(find.text("${Brightness.dark}"), findsOneWidget);
        verify(() => mockUserPreferencesService.themeType = ThemeType.systemDefault).called(1);

        TestWidgetsFlutterBinding.instance.platformDispatcher.platformBrightnessTestValue = Brightness.light;
        await tester.pumpAndSettle();
        expect(find.text("${ThemeType.systemDefault}"), findsOneWidget);
        expect(find.text("${Brightness.light}"), findsOneWidget);
      },
    );

    testWidgets(
      'Set primary color',
      (tester) async {
        when(() => mockUserPreferencesService.primaryColor).thenReturn(primaryColorsList[5]);
        await pumpTestWidget(
          tester,
          builder: (context) => ElevatedButton(
            onPressed: () => UserPreferencesProvider.of(context).setPrimaryColor(primaryColorsList[7]),
            child: Text('${UserPreferencesProvider.themeOf(context).primaryColor}'),
          ),
        );
        expect(find.text("${primaryColorsList[5]}"), findsOneWidget);

        await tester.tap(find.text("${primaryColorsList[5]}"));
        await tester.pumpAndSettle();
        expect(find.text("${primaryColorsList[7]}"), findsOneWidget);
        verify(() => mockUserPreferencesService.primaryColor = primaryColorsList[7]).called(1);
      },
    );

    testWidgets(
      'Dynamic colors not available',
      (tester) async {
        when(() => mockUserPreferencesService.dynamicColor).thenReturn(true);
        await pumpTestWidget(
          tester,
          builder: (context) => ElevatedButton(
            onPressed: () => UserPreferencesProvider.of(context).enableDynamicColor(false),
            child: Text('${UserPreferencesProvider.dynamicColorStateOf(context)}'),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text("${DynamicColorState.unavailable}"),
          findsOneWidget,
          reason:
              "Even though dynamic colors usage is enabled, the core palette can be unavailable. Therefore `DynamicColorState` is also unavailable.",
        );
      },
    );

    testWidgets(
      'Toggle dynamic color state',
      (tester) async {
        DynamicColorTestingUtils.setMockDynamicColors(corePalette: CorePalette.of(0xffffffff));
        when(() => mockUserPreferencesService.dynamicColor).thenReturn(true);
        await pumpTestWidget(
          tester,
          builder: (context) => ElevatedButton(
            onPressed: () => UserPreferencesProvider.of(context).enableDynamicColor(false),
            child: Text('${UserPreferencesProvider.dynamicColorStateOf(context)}'),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text("${DynamicColorState.enabled}"), findsOneWidget);

        await tester.tap(find.text("${DynamicColorState.enabled}"));
        await tester.pumpAndSettle();
        expect(find.text("${DynamicColorState.disabled}"), findsOneWidget);
        verify(() => mockUserPreferencesService.dynamicColor = false).called(1);
      },
    );
  });
}

class _Application extends StatelessWidget {
  final WidgetBuilder builder;

  const _Application({required this.builder});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: UserPreferencesProvider.themeOf(context),
      home: Scaffold(body: Center(child: Builder(builder: builder))),
    );
  }
}
