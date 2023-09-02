import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:test/test.dart';

void main() {
  test('intlName', () {
    expect(SupportedLocale.en.intlName, 'en');
    expect(SupportedLocale.fr.intlName, 'fr');
    expect(SupportedLocale.ru.intlName, 'ru');
  });

  test('localizedName', () {
    expect(SupportedLocale.en.localizedName, 'English');
    expect(SupportedLocale.fr.localizedName, 'Français');
    expect(SupportedLocale.ru.localizedName, 'Русский');
  });
}
