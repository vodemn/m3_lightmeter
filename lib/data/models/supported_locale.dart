enum SupportedLocale { en, fr, ru, cn }

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
      case SupportedLocale.cn:
        return '简体中文';
    }
  }
}
