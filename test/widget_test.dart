import 'package:flutter_test/flutter_test.dart';
import 'package:auto_garage_201/main.dart';

void main() {
  testWidgets('AutoGarageApp builds and renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AutoGarageApp());
    expect(find.text('201 AUTO GARAGE'), findsOneWidget);
  });
}
