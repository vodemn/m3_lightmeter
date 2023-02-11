import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:provider/provider.dart';

class SupportedLocaleProvider extends StatefulWidget {
  final Widget child;

  const SupportedLocaleProvider({required this.child, super.key});

  static SupportedLocaleProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<SupportedLocaleProviderState>()!;
  }

  @override
  State<SupportedLocaleProvider> createState() => SupportedLocaleProviderState();
}

class SupportedLocaleProviderState extends State<SupportedLocaleProvider> {
  late final ValueNotifier<SupportedLocale> valueListenable;

  @override
  void initState() {
    super.initState();
    valueListenable = ValueNotifier(context.read<UserPreferencesService>().locale);
  }

  @override
  void dispose() {
    valueListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (_, value, child) => Provider.value(
        value: value,
        child: child,
      ),
      child: widget.child,
    );
  }

  void setLocale(SupportedLocale locale) {
    S.load(Locale(locale.intlName)).then((value) {
      valueListenable.value = locale;
      context.read<UserPreferencesService>().locale = locale;
    });
  }
}