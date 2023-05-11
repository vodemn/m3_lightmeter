import 'package:intl/intl.dart';

enum SupportedLocale { en, fr, ru }

SupportedLocale get currentLanguage {
  switch (Intl.getCurrentLocale()) {
    case "en":
      return SupportedLocale.en;
    case "fr":
      return SupportedLocale.fr;
    case "ru":
      return SupportedLocale.ru;
    default:
      return SupportedLocale.en;
  }
}

extension SupportedLocaleExtension on SupportedLocale {
  String get intlName => toString().replaceAll("SupportedLocale.", "");

  String get localizedName {
    switch (this) {
      case SupportedLocale.en:
        return 'English';
      case SupportedLocale.fr:
        return 'Français';
      case SupportedLocale.ru:
        return 'Русский';
    }
  }
}
