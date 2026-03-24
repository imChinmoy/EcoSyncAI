import 'package:ecosyncai/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EcoSyncApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
