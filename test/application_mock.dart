import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/theme.dart';

/// Provides [MaterialApp] with default theme and "en" localization
class WidgetTestApplicationMock extends StatelessWidget {
  final Widget child;

  const WidgetTestApplicationMock({required this.child, super.key});

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
