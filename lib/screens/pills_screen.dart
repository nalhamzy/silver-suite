import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silver_suite/core/constants/theme.dart';
import 'package:silver_suite/core/models/pill.dart';
import 'package:silver_suite/core/utils/responsive.dart';
import 'package:silver_suite/providers/pills_provider.dart';

class PillsScreen extends ConsumerWidget {
  const PillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pills = ref.watch(pillsProvider);
    final logs = ref.watch(pillLogsProvider);
    final logsNotifier = ref.read(pillLogsProvider.notifier);

    final todaySchedule = _buildSchedule(pills);

    return SafeArea(
      child: ResponsiveContentBox(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    context.s(20), context.s(18), context.s(20), 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('TODAY',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.mute,
                              )),
                          const SizedBox(height: 4),
                          Text('Pills',
                              style: Theme.of(context).textTheme.headlineMedium),
                        ],
                      ),
                    ),
                    _AddBtn(onTap: () => _openEditor(context, ref)),
                  ],
                ),
              ),
            ),
            if (pills.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyPills(),
              )
            else ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
                sliver: SliverList.separated(
                  itemCount: todaySchedule.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final slot = todaySchedule[i];
                    final taken = logsNotifier.takenToday(
                        slot.pill.id, slot.timeOfDay);
                    return _PillSlotTile(
                      pill: slot.pill,
                      timeOfDay: slot.timeOfDay,
                      taken: taken,
                      onToggle: () {
                        HapticFeedback.selectionClick();
                        if (taken) {
                          logsNotifier.undoToday(slot.pill.id, slot.timeOfDay);
                        } else {
                          logsNotifier.markTaken(slot.pill.id, slot.timeOfDay);
                        }
                      },
                      onEdit: () =>
                          _openEditor(context, ref, editing: slot.pill),
                    );
                  },
                ),
              ),
            ],
            if (pills.isNotEmpty && logs.isEmpty)
              const SliverToBoxAdapter(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  List<_Slot> _buildSchedule(List<PillSchedule> pills) {
    final slots = <_Slot>[];
    for (final p in pills) {
      for (final t in p.timesOfDay) {
        slots.add(_Slot(pill: p, timeOfDay: t));
      }
    }
    slots.sort((a, b) => a.timeOfDay.compareTo(b.timeOfDay));
    return slots;
  }

  Future<void> _openEditor(BuildContext context, WidgetRef ref,
      {PillSchedule? editing}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PillEditor(editing: editing),
    );
  }
}

class _Slot {
  final PillSchedule pill;
  final String timeOfDay;
  _Slot({required this.pill, required this.timeOfDay});
}

class _AddBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _AddBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.blue,
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
              Text('Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillSlotTile extends StatelessWidget {
  final PillSchedule pill;
  final String timeOfDay;
  final bool taken;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const _PillSlotTile({
    required this.pill,
    required this.timeOfDay,
    required this.taken,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        Color(int.parse('FF${pill.color}', radix: 16));
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: taken
            ? (dark
                ? AppTheme.green.withValues(alpha: 0.15)
                : AppTheme.green.withValues(alpha: 0.10))
            : (dark ? const Color(0xFF161A22) : AppTheme.surface),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: taken
              ? AppTheme.green
              : (dark ? const Color(0xFF2A2F3B) : AppTheme.outline),
          width: taken ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(timeOfDay),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: color,
                  ),
                ),
                Text(
                  _isPm(timeOfDay) ? 'PM' : 'AM',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pill.name,
                    style: Theme.of(context).textTheme.titleLarge),
                if (pill.dosage?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 2),
                  Text(pill.dosage!,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          _CircleBtn(
            icon: taken ? Icons.check : Icons.check_outlined,
            color: taken ? AppTheme.green : AppTheme.blue,
            label: taken ? 'Done' : 'Take',
            onTap: onToggle,
          ),
          const SizedBox(width: 8),
          IconButton(
            iconSize: 26,
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }

  String _formatTime(String hhmm) {
    final parts = hhmm.split(':');
    final h = int.parse(parts[0]);
    final m = parts[1];
    final hh = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$hh:$m';
  }

  bool _isPm(String hhmm) => int.parse(hhmm.split(':')[0]) >= 12;
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _CircleBtn(
      {required this.icon,
      required this.color,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPills extends StatelessWidget {
  const _EmptyPills();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.amber.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.medication_liquid_outlined,
                  color: AppTheme.amber, size: 40),
            ),
            const SizedBox(height: 16),
            Text('No medications yet',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(
              'Tap "Add" to schedule your first one. Names, times, colors — easy.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _PillEditor extends ConsumerStatefulWidget {
  final PillSchedule? editing;
  const _PillEditor({this.editing});

  @override
  ConsumerState<_PillEditor> createState() => _PillEditorState();
}

class _PillEditorState extends ConsumerState<_PillEditor> {
  late final TextEditingController _name;
  late final TextEditingController _dose;
  late List<TimeOfDay> _times;
  late String _color;

  static const _colorChoices = [
    'E08900', // amber
    '1864C0', // blue
    '077D83', // teal
    '2F8A3E', // green
    'C02B2B', // red
    '3A3BB7', // indigo
  ];

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.editing?.name ?? '');
    _dose = TextEditingController(text: widget.editing?.dosage ?? '');
    _times = (widget.editing?.timesOfDay ?? const ['08:00']).map((t) {
      final parts = t.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }).toList();
    _color = widget.editing?.color ?? _colorChoices.first;
  }

  @override
  void dispose() {
    _name.dispose();
    _dose.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    final pills = ref.read(pillsProvider.notifier);
    final schedule = PillSchedule(
      id: widget.editing?.id ??
          'p${DateTime.now().microsecondsSinceEpoch}',
      name: _name.text.trim(),
      dosage: _dose.text.trim().isEmpty ? null : _dose.text.trim(),
      timesOfDay: _times
          .map((t) =>
              '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}')
          .toList()
        ..sort(),
      color: _color,
    );
    if (widget.editing != null) {
      await pills.update(schedule);
    } else {
      await pills.add(schedule);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _addTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (t != null) setState(() => _times.add(t));
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
                widget.editing == null ? 'New medication' : 'Edit medication',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 18),
              _input('Name (e.g. Atorvastatin 20mg)', _name),
              const SizedBox(height: 12),
              _input('Dose (e.g. 1 tablet)', _dose),
              const SizedBox(height: 18),
              Text('Times', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (var i = 0; i < _times.length; i++)
                    InputChip(
                      label: Text(
                        _times[i].format(context),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      onDeleted: () => setState(() => _times.removeAt(i)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                    ),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 20),
                    label: const Text('Add time',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    onPressed: _addTime,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text('Color', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (final c in _colorChoices)
                    GestureDetector(
                      onTap: () => setState(() => _color = c),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Color(int.parse('FF$c', radix: 16)),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _color == c ? AppTheme.ink : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.blue,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _save,
                  child: Text(
                    widget.editing == null ? 'Add' : 'Save',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              if (widget.editing != null) ...[
                const SizedBox(height: 8),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: AppTheme.red),
                  onPressed: () async {
                    await ref
                        .read(pillsProvider.notifier)
                        .remove(widget.editing!.id);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text('Remove this medication',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController c) {
    return TextField(
      controller: c,
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
          borderSide: const BorderSide(color: AppTheme.blue, width: 2),
        ),
      ),
    );
  }
}

