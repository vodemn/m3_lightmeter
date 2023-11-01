import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/feature.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/remote_config_provider.dart';
import 'package:lightmeter/screens/settings/utils/show_buy_pro_dialog.dart';

import '../../../application_mock.dart';

void main() {
  Future<void> pumpApplication(WidgetTester tester) async {
    await tester.pumpWidget(
      RemoteConfig(
        config: const {Feature.unlockProFeaturesText: false},
        child: WidgetTestApplicationMock(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showBuyProDialog(context),
              child: const SizedBox(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    '`showBuyProDialog` and buy',
    (tester) async {
      await pumpApplication(tester);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(S.current.lightmeterPro), findsOneWidget);
      expect(find.text(S.current.cancel), findsOneWidget);
      expect(find.text(S.current.buy), findsOneWidget);

      await tester.tap(find.text(S.current.buy));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    },
  );

  testWidgets(
    '`showBuyProDialog` and cancel',
    (tester) async {
      await pumpApplication(tester);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(S.current.lightmeterPro), findsOneWidget);
      expect(find.text(S.current.cancel), findsOneWidget);
      expect(find.text(S.current.buy), findsOneWidget);

      await tester.tap(find.text(S.current.cancel));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    },
  );
}
