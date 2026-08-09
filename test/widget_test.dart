import 'package:flutter_test/flutter_test.dart';
import 'package:traceit/main.dart';

void main() {
  testWidgets('TraceIt app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const TraceItApp());

    expect(find.text('Devices'), findsOneWidget);
  });
}