import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silver_suite/core/models/settings.dart';
import 'package:silver_suite/providers/storage_provider.dart';

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(storageServiceProvider).loadSettings();

  Future<void> setTextScale(TextScaleOption o) async {
    state = state.copyWith(textScale: o);
    await ref.read(storageServiceProvider).saveSettings(state);
  }

  Future<void> setDarkMode(bool v) async {
    state = state.copyWith(darkMode: v);
    await ref.read(storageServiceProvider).saveSettings(state);
  }
}
