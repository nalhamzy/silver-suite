import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silver_suite/core/constants/theme.dart';
import 'package:silver_suite/providers/contacts_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SosScreen extends ConsumerWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergency =
        ref.watch(contactsProvider).where((c) => c.isEmergency).toList();

    return Scaffold(
      backgroundColor: AppTheme.red,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Emergency',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Expanded(child: _BigSOSButton()),
              const SizedBox(height: 12),
              if (emergency.isNotEmpty) ...[
                const Text(
                  'EMERGENCY CONTACTS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                for (final c in emergency)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          launchUrl(Uri(scheme: 'tel', path: c.phone));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.red.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.phone,
                                    color: AppTheme.red, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(c.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.ink,
                                        )),
                                    if (c.relation.isNotEmpty)
                                      Text(c.relation,
                                          style: const TextStyle(
                                              color: AppTheme.mute,
                                              fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              Text(c.phone,
                                  style: const TextStyle(
                                    color: AppTheme.red,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ] else ...[
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Tip: mark a family member as an Emergency contact so they appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BigSOSButton extends StatefulWidget {
  const _BigSOSButton();

  @override
  State<_BigSOSButton> createState() => _BigSOSButtonState();
}

class _BigSOSButtonState extends State<_BigSOSButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _confirmAndCall() async {
    HapticFeedback.heavyImpact();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Call emergency services?'),
        content: const Text(
          'This will attempt to dial 911 on your phone.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(fontSize: 16)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Call 911', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await launchUrl(Uri(scheme: 'tel', path: '911'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _confirmAndCall,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) {
            final v = _ctrl.value;
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 260 + 40 * v,
                  height: 260 + 40 * v,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12 * (1 - v)),
                  ),
                ),
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.call, color: AppTheme.red, size: 56),
                      SizedBox(height: 12),
                      Text('CALL 911',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.red,
                            letterSpacing: 1.5,
                          )),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
