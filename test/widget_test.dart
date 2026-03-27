import 'package:ecosyncai/core/locale/locale_controller.dart';
import 'package:ecosyncai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final localeController = LocaleController();
    await localeController.load();
    await tester.pumpWidget(EcoSyncApp(localeController: localeController));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
