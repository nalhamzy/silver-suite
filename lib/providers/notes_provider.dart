import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silver_suite/core/models/note.dart';
import 'package:silver_suite/providers/storage_provider.dart';

final notesProvider =
    NotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);

class NotesNotifier extends Notifier<List<Note>> {
  @override
  List<Note> build() => ref.read(storageServiceProvider).loadNotes();

  Future<void> upsert(Note n) async {
    final existing = state.any((e) => e.id == n.id);
    state = existing
        ? [for (final e in state) e.id == n.id ? n : e]
        : [n, ...state];
    await ref.read(storageServiceProvider).saveNotes(state);
  }

  Future<void> remove(String id) async {
    state = state.where((e) => e.id != id).toList();
    await ref.read(storageServiceProvider).saveNotes(state);
  }
}
