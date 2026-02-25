import 'package:clipboard_app/app.dart';
import 'package:clipboard_app/injectable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('App starts smoke test', (tester) async {
    // Setup DI for testing
    configureDependencies();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: ClipboardApp(),
      ),
    );

    // Verify that the initial page is loaded
    expect(find.text('Clipboard History'), findsOneWidget);
  });
}
