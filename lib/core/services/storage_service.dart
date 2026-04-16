import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silver_suite/core/models/contact_entry.dart';
import 'package:silver_suite/core/models/note.dart';
import 'package:silver_suite/core/models/pill.dart';
import 'package:silver_suite/core/models/settings.dart';

class StorageService {
  static const _kContacts = 'ss_contacts';
  static const _kPills = 'ss_pills';
  static const _kPillLogs = 'ss_pill_logs';
  static const _kNotes = 'ss_notes';
  static const _kSettings = 'ss_settings';

  final SharedPreferences _prefs;
  StorageService(this._prefs);

  // contacts
  List<ContactEntry> loadContacts() => _decodeList(
      _kContacts, ContactEntry.fromJson, _defaultContacts);

  Future<void> saveContacts(List<ContactEntry> list) =>
      _encodeList(_kContacts, list.map((e) => e.toJson()).toList());

  // pills
  List<PillSchedule> loadPills() =>
      _decodeList(_kPills, PillSchedule.fromJson, () => const []);

  Future<void> savePills(List<PillSchedule> list) =>
      _encodeList(_kPills, list.map((e) => e.toJson()).toList());

  List<PillLog> loadPillLogs() =>
      _decodeList(_kPillLogs, PillLog.fromJson, () => const []);

  Future<void> savePillLogs(List<PillLog> list) =>
      _encodeList(_kPillLogs, list.map((e) => e.toJson()).toList());

  // notes
  List<Note> loadNotes() =>
      _decodeList(_kNotes, Note.fromJson, () => const []);

  Future<void> saveNotes(List<Note> list) =>
      _encodeList(_kNotes, list.map((e) => e.toJson()).toList());

  // settings
  AppSettings loadSettings() {
    final s = _prefs.getString(_kSettings);
    if (s == null) return const AppSettings();
    try {
      return AppSettings.decode(s);
    } catch (_) {
      return const AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings s) =>
      _prefs.setString(_kSettings, s.encode());

  // helpers
  List<T> _decodeList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
    List<T> Function() defaults,
  ) {
    final raw = _prefs.getString(key);
    if (raw == null) return defaults();
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return defaults();
    }
  }

  Future<void> _encodeList(String key, List<Map<String, dynamic>> list) =>
      _prefs.setString(key, jsonEncode(list));
}

List<ContactEntry> _defaultContacts() => const [];
