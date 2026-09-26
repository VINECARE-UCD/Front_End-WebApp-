// Basic smoke test for VineCare.
//
// This just verifies the app builds without throwing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vinecare/main.dart';

void main() {
  testWidgets('VineCare app builds', (WidgetTester tester) async {
    await tester.pumpWidget(const VineCareApp());
    await tester.pumpAndSettle();

    // Just confirm something rendered without crashing.
    expect(find.byType(MaterialApp), findsWidgets);
  });
}
