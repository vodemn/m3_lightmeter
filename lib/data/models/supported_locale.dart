enum SupportedLocale { de, en, fr, ru, zh }

extension SupportedLocaleExtension on SupportedLocale {
  String get intlName => toString().replaceAll("SupportedLocale.", "");

  String get localizedName {
    switch (this) {
      case SupportedLocale.de:
        return 'Deutsch';
      case SupportedLocale.en:
        return 'English';
      case SupportedLocale.fr:
        return 'Français';
      case SupportedLocale.ru:
        return 'Русский';
      case SupportedLocale.zh:
        return '简体中文';
    }
  }
}
