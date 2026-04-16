import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:silver_suite/core/constants/theme.dart';
import 'package:silver_suite/core/utils/responsive.dart';
import 'package:silver_suite/providers/navigation_provider.dart';
import 'package:silver_suite/screens/calculator_screen.dart';
import 'package:silver_suite/screens/flashlight_screen.dart';
import 'package:silver_suite/screens/magnifier_screen.dart';
import 'package:silver_suite/screens/notes_screen.dart';
import 'package:silver_suite/screens/sos_screen.dart';
import 'package:silver_suite/widgets/big_action_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _clockTimer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            _BigClock(now: _now),
            SizedBox(height: context.s(16)),
            _SosBanner(onTap: () => _push(const SosScreen())),
            SizedBox(height: context.s(18)),
            Text('Tools',
                style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: context.s(12)),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                BigActionCard(
                  title: 'Pills',
                  subtitle: 'Reminders & log',
                  icon: Icons.medication_liquid_outlined,
                  gradient: AppTheme.amberGradient,
                  onTap: () =>
                      ref.read(tabProvider.notifier).go(AppTab.pills),
                ),
                BigActionCard(
                  title: 'Contacts',
                  subtitle: 'One-tap call',
                  icon: Icons.groups_2_outlined,
                  gradient: AppTheme.tealGradient,
                  onTap: () =>
                      ref.read(tabProvider.notifier).go(AppTab.contacts),
                ),
                BigActionCard(
                  title: 'Flashlight',
                  subtitle: 'Quick torch',
                  icon: Icons.flashlight_on_outlined,
                  gradient: AppTheme.primaryGradient,
                  onTap: () => _push(const FlashlightScreen()),
                ),
                BigActionCard(
                  title: 'Magnifier',
                  subtitle: 'Big text & zoom',
                  icon: Icons.search,
                  gradient: AppTheme.indigoGradient,
                  onTap: () => _push(const MagnifierScreen()),
                ),
                BigActionCard(
                  title: 'Notes',
                  subtitle: 'Large, easy',
                  icon: Icons.edit_note_outlined,
                  gradient: AppTheme.greenGradient,
                  onTap: () => _push(const NotesScreen()),
                ),
                BigActionCard(
                  title: 'Calculator',
                  subtitle: 'Big keys',
                  icon: Icons.calculate_outlined,
                  gradient: AppTheme.redGradient,
                  onTap: () => _push(const CalculatorScreen()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _push(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

class _BigClock extends StatelessWidget {
  final DateTime now;
  const _BigClock({required this.now});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF161A22) : AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: dark ? const Color(0xFF2A2F3B) : AppTheme.outline,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('h:mm a').format(now),
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEEE, MMMM d').format(now),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.access_time,
                color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}

class _SosBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _SosBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: AppTheme.redGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.red.withValues(alpha: 0.30),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.emergency_outlined,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Emergency',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Big SOS button & 911 shortcut',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: Colors.white, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
