import 'package:flutter_test/flutter_test.dart';
import 'package:auto_garage_201/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AutoGarageApp());
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pumpAndSettle();
    expect(find.byType(AutoGarageApp), findsOneWidget);
  });
}
