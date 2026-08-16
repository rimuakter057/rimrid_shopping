import 'package:flutter_test/flutter_test.dart';
import 'package:rimrid_shopping/main.dart';

void main() {
  testWidgets('RimRid Shopping App basic initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const RimRidShoppingApp());
    expect(find.byType(RimRidShoppingApp), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });
}
