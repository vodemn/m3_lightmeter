import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:test/test.dart';

void main() {
  test('intlName', () {
    expect(SupportedLocale.en.intlName, 'en');
    expect(SupportedLocale.fr.intlName, 'fr');
    expect(SupportedLocale.pl.intlName, 'pl');
    expect(SupportedLocale.ru.intlName, 'ru');
    expect(SupportedLocale.zh.intlName, 'zh');
    expect(SupportedLocale.de.intlName, 'de');
  });

  test('localizedName', () {
    expect(SupportedLocale.en.localizedName, 'English');
    expect(SupportedLocale.fr.localizedName, 'Français');
    expect(SupportedLocale.pl.localizedName, 'Polski');
    expect(SupportedLocale.ru.localizedName, 'Русский');
    expect(SupportedLocale.zh.localizedName, '简体中文');
    expect(SupportedLocale.de.localizedName, 'Deutsch');
  });
}
