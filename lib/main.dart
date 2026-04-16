import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silver_suite/app.dart';
import 'package:silver_suite/core/services/ad_service.dart';
import 'package:silver_suite/core/services/iap_service.dart';
import 'package:silver_suite/core/services/storage_service.dart';
import 'package:silver_suite/providers/iap_provider.dart';
import 'package:silver_suite/providers/storage_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  final prefs = await SharedPreferences.getInstance();
  final storage = StorageService(prefs);

  final ads = AdService();
  final iap = IapService();

  // never block launch — both are fire-and-forget handshakes
  ads.initialize().catchError((_) {});
  iap.initialize().catchError((_) {});

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
        adServiceProvider.overrideWithValue(ads),
        iapServiceProvider.overrideWithValue(iap),
      ],
      child: const SilverSuiteApp(),
    ),
  );
}
