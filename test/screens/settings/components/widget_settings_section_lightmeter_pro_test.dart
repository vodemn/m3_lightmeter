import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/lightmeter_pro/components/buy_pro/widget_list_tile_buy_pro.dart';
import 'package:lightmeter/screens/settings/components/lightmeter_pro/widget_settings_section_lightmeter_pro.dart';
import 'package:lightmeter/screens/shared/transparent_dialog/widget_dialog_transparent.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

import '../../../application_mock.dart';

const _price = '0.0\$';

void main() {
  Future<void> pumpApplication(WidgetTester tester) async {
    await tester.pumpWidget(
      IAPProducts(
        products: [
          IAPProduct(
            storeId: IAPProductType.paidFeatures.storeId,
            price: _price,
          ),
        ],
        child: const WidgetTestApplicationMock(
          child: LightmeterProSettingsSection(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    '`showBuyProDialog` and buy',
    (tester) async {
      await pumpApplication(tester);
      await tester.tap(find.byType(BuyProListTile));
      await tester.pumpAndSettle();
      expect(find.byType(TransparentDialog), findsOneWidget);
      expect(find.text(S.current.proFeaturesTitle), findsNWidgets(2));
      expect(find.text(S.current.cancel), findsOneWidget);
      expect(find.text(S.current.unlockFor(_price)), findsOneWidget);

      await tester.tap(find.text(S.current.unlockFor(_price)));
      await tester.pumpAndSettle();
      expect(find.byType(TransparentDialog), findsNothing);
    },
  );

  testWidgets(
    '`showBuyProDialog` and cancel',
    (tester) async {
      await pumpApplication(tester);
      await tester.tap(find.byType(BuyProListTile));
      await tester.pumpAndSettle();
      expect(find.byType(TransparentDialog), findsOneWidget);
      expect(find.text(S.current.proFeaturesTitle), findsNWidgets(2));
      expect(find.text(S.current.cancel), findsOneWidget);
      expect(find.text(S.current.unlockFor(_price)), findsOneWidget);

      await tester.tap(find.text(S.current.cancel));
      await tester.pumpAndSettle();
      expect(find.byType(TransparentDialog), findsNothing);
    },
  );
}
