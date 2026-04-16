import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppTab { home, pills, contacts, more }

final tabProvider =
    NotifierProvider<TabNotifier, AppTab>(TabNotifier.new);

class TabNotifier extends Notifier<AppTab> {
  @override
  AppTab build() => AppTab.home;

  void go(AppTab t) => state = t;
}
