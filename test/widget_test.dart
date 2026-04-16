import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silver_suite/app.dart';
import 'package:silver_suite/core/services/storage_service.dart';
import 'package:silver_suite/providers/storage_provider.dart';

void main() {
  testWidgets('App boots and shows Tools grid', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [storageServiceProvider.overrideWithValue(storage)],
        child: const SilverSuiteApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tools'), findsOneWidget);
    expect(find.text('Pills'), findsWidgets);
    expect(find.text('Contacts'), findsOneWidget);
    expect(find.text('Flashlight'), findsOneWidget);
  });
}
