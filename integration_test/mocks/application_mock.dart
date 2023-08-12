import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/theme_provider.dart';
import 'package:lightmeter/utils/inherited_generics.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserPreferencesService extends Mock implements UserPreferencesService {}

class ApplicationMock extends StatefulWidget {
  final Widget child;

  const ApplicationMock({required this.child, super.key});

  @override
  State<ApplicationMock> createState() => _ApplicationMockState();
}

class _ApplicationMockState extends State<ApplicationMock> {
  late final _MockUserPreferencesService userPreferencesService;

  @override
  void initState() {
    super.initState();
    userPreferencesService = _MockUserPreferencesService();
    when(() => userPreferencesService.themeType).thenReturn(ThemeType.light);
    when(() => userPreferencesService.primaryColor)
        .thenReturn(ThemeProvider.primaryColorsList.first);
    when(() => userPreferencesService.dynamicColor).thenReturn(false);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetBase<UserPreferencesService>(
      data: userPreferencesService,
      child: ThemeProvider(
        child: Builder(
          builder: (context) {
            return MaterialApp(
              theme: context.listen<ThemeData>(),
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
    );
  }
}
