import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:silver_suite/core/constants/theme.dart';
import 'package:silver_suite/core/models/note.dart';
import 'package:silver_suite/providers/iap_provider.dart';
import 'package:silver_suite/providers/notes_provider.dart';
import 'package:silver_suite/screens/paywall_screen.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});
  static const _freeNoteLimit = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = List<Note>.from(ref.watch(notesProvider));
    final isPremium = ref.watch(isPremiumProvider);
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 28),
            onPressed: () {
              if (!isPremium && notes.length >= _freeNoteLimit) {
                _showPremiumLimit(context);
                return;
              }
              _openEditor(context);
            },
          ),
        ],
      ),
      body: notes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.green.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_note_outlined,
                        color: AppTheme.green,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notes yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap the + to jot something big, clear, and easy to read later.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: notes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _NoteTile(
                note: notes[i],
                onTap: () => _openEditor(context, editing: notes[i]),
              ),
            ),
    );
  }

  void _openEditor(BuildContext context, {Note? editing}) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => _NoteEditor(editing: editing)));
  }

  void _showPremiumLimit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Note limit reached'),
        content: const Text(
          'The free version keeps 5 large-text notes. Silver+ unlocks '
          'unlimited notes, removes ads, and keeps your data on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Not now'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.green),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const PaywallScreen()));
            },
            child: const Text('See Silver+'),
          ),
        ],
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  const _NoteTile({required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: dark ? const Color(0xFF161A22) : AppTheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: dark ? const Color(0xFF2A2F3B) : AppTheme.outline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title.isEmpty ? 'Untitled' : note.title,
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (note.body.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  note.body,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                DateFormat('MMM d · h:mm a').format(note.updatedAt),
                style: const TextStyle(color: AppTheme.mute, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteEditor extends ConsumerStatefulWidget {
  final Note? editing;
  const _NoteEditor({this.editing});

  @override
  ConsumerState<_NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends ConsumerState<_NoteEditor> {
  late final TextEditingController _title;
  late final TextEditingController _body;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.editing?.title ?? '');
    _body = TextEditingController(text: widget.editing?.body ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final note = Note(
      id: widget.editing?.id ?? 'n${DateTime.now().microsecondsSinceEpoch}',
      title: _title.text.trim(),
      body: _body.text,
      updatedAt: DateTime.now(),
    );
    if (note.title.isEmpty && note.body.isEmpty) {
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }
    await ref.read(notesProvider.notifier).upsert(note);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (widget.editing != null) {
      await ref.read(notesProvider.notifier).remove(widget.editing!.id);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editing == null ? 'New note' : 'Edit note'),
        actions: [
          if (widget.editing != null)
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppTheme.red,
                size: 26,
              ),
              onPressed: _delete,
            ),
          IconButton(icon: const Icon(Icons.check, size: 28), onPressed: _save),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
            const Divider(height: 20),
            Expanded(
              child: TextField(
                controller: _body,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
                decoration: const InputDecoration(
                  hintText: 'Write here…',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
