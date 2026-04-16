import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silver_suite/core/models/pill.dart';
import 'package:silver_suite/providers/storage_provider.dart';

final pillsProvider =
    NotifierProvider<PillsNotifier, List<PillSchedule>>(PillsNotifier.new);

class PillsNotifier extends Notifier<List<PillSchedule>> {
  @override
  List<PillSchedule> build() => ref.read(storageServiceProvider).loadPills();

  Future<void> add(PillSchedule p) async {
    state = [...state, p];
    await ref.read(storageServiceProvider).savePills(state);
  }

  Future<void> update(PillSchedule p) async {
    state = [for (final e in state) e.id == p.id ? p : e];
    await ref.read(storageServiceProvider).savePills(state);
  }

  Future<void> remove(String id) async {
    state = state.where((e) => e.id != id).toList();
    await ref.read(storageServiceProvider).savePills(state);
    // also drop logs
    final logs = ref.read(pillLogsProvider.notifier);
    await logs.removeForPill(id);
  }
}

final pillLogsProvider =
    NotifierProvider<PillLogsNotifier, List<PillLog>>(PillLogsNotifier.new);

class PillLogsNotifier extends Notifier<List<PillLog>> {
  @override
  List<PillLog> build() => ref.read(storageServiceProvider).loadPillLogs();

  Future<void> markTaken(String pillId, String timeOfDay) async {
    final log = PillLog(
      id: 'pl${DateTime.now().microsecondsSinceEpoch}',
      pillId: pillId,
      timeOfDay: timeOfDay,
      takenAt: DateTime.now(),
    );
    state = [log, ...state];
    await ref.read(storageServiceProvider).savePillLogs(state);
  }

  Future<void> undoToday(String pillId, String timeOfDay) async {
    final today = DateTime.now();
    state = state
        .where((l) => !(l.pillId == pillId &&
            l.timeOfDay == timeOfDay &&
            l.takenAt.year == today.year &&
            l.takenAt.month == today.month &&
            l.takenAt.day == today.day))
        .toList();
    await ref.read(storageServiceProvider).savePillLogs(state);
  }

  bool takenToday(String pillId, String timeOfDay) {
    final today = DateTime.now();
    return state.any((l) =>
        l.pillId == pillId &&
        l.timeOfDay == timeOfDay &&
        l.takenAt.year == today.year &&
        l.takenAt.month == today.month &&
        l.takenAt.day == today.day);
  }

  Future<void> removeForPill(String pillId) async {
    state = state.where((l) => l.pillId != pillId).toList();
    await ref.read(storageServiceProvider).savePillLogs(state);
  }
}
