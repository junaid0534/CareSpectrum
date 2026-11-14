import 'package:flutter_test/flutter_test.dart';
import 'package:carespectrum/main.dart';

void main() {
  testWidgets('CareSpectrum app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CareSpectrumApp());
    expect(find.byType(CareSpectrumApp), findsOneWidget);
  });
}
