import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silver_suite/core/constants/theme.dart';
import 'package:silver_suite/core/models/contact_entry.dart';
import 'package:silver_suite/core/utils/responsive.dart';
import 'package:silver_suite/providers/contacts_provider.dart';
import 'package:silver_suite/providers/iap_provider.dart';
import 'package:silver_suite/screens/paywall_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});
  static const _freeContactLimit = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(contactsProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final emergency = all.where((c) => c.isEmergency).toList();
    final rest = all.where((c) => !c.isEmergency).toList();

    return SafeArea(
      child: ResponsiveContentBox(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            context.s(20),
            context.s(18),
            context.s(20),
            context.s(120),
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CONTACTS',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.mute,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'One-tap call',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                _AddBtn(
                  onTap: () {
                    if (!isPremium && all.length >= _freeContactLimit) {
                      _showPremiumLimit(context);
                      return;
                    }
                    _openEditor(context, ref);
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (all.isEmpty)
              const _EmptyContacts()
            else ...[
              if (emergency.isNotEmpty) ...[
                const _SectionLabel(text: 'EMERGENCY', color: AppTheme.red),
                const SizedBox(height: 10),
                for (final c in emergency)
                  _ContactCard(
                    contact: c,
                    onEdit: () => _openEditor(context, ref, editing: c),
                  ),
              ],
              if (rest.isNotEmpty) ...[
                if (emergency.isNotEmpty) const SizedBox(height: 20),
                const _SectionLabel(
                  text: 'FAMILY & FRIENDS',
                  color: AppTheme.teal,
                ),
                const SizedBox(height: 10),
                for (final c in rest)
                  _ContactCard(
                    contact: c,
                    onEdit: () => _openEditor(context, ref, editing: c),
                  ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref, {
    ContactEntry? editing,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ContactEditor(editing: editing),
    );
  }

  void _showPremiumLimit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Contact limit reached'),
        content: const Text(
          'The free version keeps 3 favorite contacts. Silver+ unlocks '
          'unlimited family, doctor, and emergency contacts.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Not now'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.teal),
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

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel({required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _AddBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _AddBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.teal,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.white, size: 22),
              SizedBox(width: 6),
              Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyContacts extends StatelessWidget {
  const _EmptyContacts();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.teal.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.groups_2_outlined,
                color: AppTheme.teal,
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No contacts yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Add the people you call most. Mark family like "Son" or "Daughter" to reach them fast.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final ContactEntry contact;
  final VoidCallback onEdit;
  const _ContactCard({required this.contact, required this.onEdit});

  Future<void> _dial() async {
    HapticFeedback.mediumImpact();
    final uri = Uri(scheme: 'tel', path: contact.phone);
    // ignore: deprecated_member_use
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = contact.isEmergency ? AppTheme.red : AppTheme.teal;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF161A22) : AppTheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: contact.isEmergency
              ? AppTheme.red.withValues(alpha: 0.5)
              : (dark ? const Color(0xFF2A2F3B) : AppTheme.outline),
          width: contact.isEmergency ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Text(
              _initials(contact.name),
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  contact.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (contact.relation.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    contact.relation,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  contact.phone,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: accent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _dial,
              onLongPress: onEdit,
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Icon(Icons.phone, color: Colors.white, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _ContactEditor extends ConsumerStatefulWidget {
  final ContactEntry? editing;
  const _ContactEditor({this.editing});

  @override
  ConsumerState<_ContactEditor> createState() => _ContactEditorState();
}

class _ContactEditorState extends ConsumerState<_ContactEditor> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _relation;
  late bool _isEmergency;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.editing?.name ?? '');
    _phone = TextEditingController(text: widget.editing?.phone ?? '');
    _relation = TextEditingController(text: widget.editing?.relation ?? '');
    _isEmergency = widget.editing?.isEmergency ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _relation.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _phone.text.trim().isEmpty) return;
    final notifier = ref.read(contactsProvider.notifier);
    final entry = ContactEntry(
      id: widget.editing?.id ?? 'c${DateTime.now().microsecondsSinceEpoch}',
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      relation: _relation.text.trim(),
      isEmergency: _isEmergency,
    );
    if (widget.editing != null) {
      await notifier.update(entry);
    } else {
      await notifier.add(entry);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.viewInsetsOf(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(bottom: insets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF0C0F15) : AppTheme.bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.outline,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.editing == null ? 'New contact' : 'Edit contact',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 18),
              _input('Name', _name),
              const SizedBox(height: 12),
              _input('Phone number', _phone, keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              _input('Relation (e.g. Son, Doctor)', _relation),
              const SizedBox(height: 18),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Emergency contact',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                ),
                subtitle: const Text(
                  'Shown at top in red, easy to call in a panic.',
                ),
                value: _isEmergency,
                activeThumbColor: AppTheme.red,
                onChanged: (v) => setState(() => _isEmergency = v),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.teal,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _save,
                  child: Text(
                    widget.editing == null ? 'Add contact' : 'Save',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              if (widget.editing != null) ...[
                const SizedBox(height: 8),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: AppTheme.red),
                  onPressed: () async {
                    await ref
                        .read(contactsProvider.notifier)
                        .remove(widget.editing!.id);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Remove contact',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController c, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: c,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF161A22)
            : AppTheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.teal, width: 2),
        ),
      ),
    );
  }
}
