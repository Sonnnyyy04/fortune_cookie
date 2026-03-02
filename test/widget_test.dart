import 'package:flutter_test/flutter_test.dart';

import 'package:untitled/main.dart';

void main() {
  testWidgets('Splash screen displays app title', (WidgetTester tester) async {
    await tester.pumpWidget(const FortuneCookieApp());
    await tester.pumpAndSettle();

    expect(find.text('Печенька'), findsOneWidget);
    expect(find.text('с предсказанием'), findsOneWidget);
    expect(find.text('Войти'), findsOneWidget);
  });
}
