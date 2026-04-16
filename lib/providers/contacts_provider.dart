import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silver_suite/core/models/contact_entry.dart';
import 'package:silver_suite/providers/storage_provider.dart';

final contactsProvider =
    NotifierProvider<ContactsNotifier, List<ContactEntry>>(ContactsNotifier.new);

class ContactsNotifier extends Notifier<List<ContactEntry>> {
  @override
  List<ContactEntry> build() => ref.read(storageServiceProvider).loadContacts();

  Future<void> add(ContactEntry c) async {
    state = [...state, c];
    await ref.read(storageServiceProvider).saveContacts(state);
  }

  Future<void> update(ContactEntry c) async {
    state = [for (final e in state) e.id == c.id ? c : e];
    await ref.read(storageServiceProvider).saveContacts(state);
  }

  Future<void> remove(String id) async {
    state = state.where((e) => e.id != id).toList();
    await ref.read(storageServiceProvider).saveContacts(state);
  }
}
