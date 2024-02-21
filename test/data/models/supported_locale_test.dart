import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:test/test.dart';

void main() {
  test('intlName', () {
    expect(SupportedLocale.en.intlName, 'en');
    expect(SupportedLocale.fr.intlName, 'fr');
    expect(SupportedLocale.ru.intlName, 'ru');
    expect(SupportedLocale.zh.intlName, 'zh');
  });

  test('localizedName', () {
    expect(SupportedLocale.en.localizedName, 'English');
    expect(SupportedLocale.fr.localizedName, 'Français');
    expect(SupportedLocale.ru.localizedName, 'Русский');
    expect(SupportedLocale.zh.localizedName, '简体中文');
  });
}
