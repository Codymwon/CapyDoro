import 'package:flutter_test/flutter_test.dart';
import 'package:capydoro/main.dart';

void main() {
  testWidgets('CapyDoro app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CapyDoroApp());

    // Verify the app title is shown
    expect(find.text('CapyDoro'), findsOneWidget);

    // Verify the idle state shows "Ready?"
    expect(find.text('Ready?'), findsOneWidget);

    // Verify the start button is present
    expect(find.text('Start'), findsOneWidget);
  });
}
