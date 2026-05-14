import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silver_suite/core/constants/theme.dart';
import 'package:silver_suite/core/models/premium_state.dart';
import 'package:silver_suite/core/models/settings.dart';
import 'package:silver_suite/core/utils/responsive.dart';
import 'package:silver_suite/providers/iap_provider.dart';
import 'package:silver_suite/providers/settings_provider.dart';
import 'package:silver_suite/screens/calculator_screen.dart';
import 'package:silver_suite/screens/flashlight_screen.dart';
import 'package:silver_suite/screens/magnifier_screen.dart';
import 'package:silver_suite/screens/notes_screen.dart';
import 'package:silver_suite/screens/paywall_screen.dart';
import 'package:silver_suite/widgets/big_action_card.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final s = ref.read(settingsProvider.notifier);
    final premium = ref.watch(premiumProvider);
    final hideAds = ref.watch(hideAdsProvider);

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
            const Text(
              'MORE',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.mute,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tools & settings',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 18),
            _PremiumBanner(premium: premium, hideAds: hideAds),
            const SizedBox(height: 18),
            BigRowCard(
              title: 'Flashlight',
              subtitle: 'Turn on your camera light',
              icon: Icons.flashlight_on_outlined,
              color: AppTheme.amber,
              onTap: () => _push(context, const FlashlightScreen()),
            ),
            const SizedBox(height: 12),
            BigRowCard(
              title: 'Magnifier',
              subtitle: 'Big, bold, high-contrast text',
              icon: Icons.search,
              color: AppTheme.indigo,
              onTap: () => _push(context, const MagnifierScreen()),
            ),
            const SizedBox(height: 12),
            BigRowCard(
              title: 'Notes',
              subtitle: 'Simple, large-text notes',
              icon: Icons.edit_note_outlined,
              color: AppTheme.green,
              onTap: () => _push(context, const NotesScreen()),
            ),
            const SizedBox(height: 12),
            BigRowCard(
              title: 'Calculator',
              subtitle: 'Big keys, simple math',
              icon: Icons.calculate_outlined,
              color: AppTheme.blue,
              onTap: () => _push(context, const CalculatorScreen()),
            ),
            const SizedBox(height: 28),
            Text(
              'Accessibility',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dark mode',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Switch(
                        value: settings.darkMode,
                        activeThumbColor: AppTheme.blue,
                        onChanged: (v) => s.setDarkMode(v),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Text size',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      SegmentedButton<TextScaleOption>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: TextScaleOption.standard,
                            label: Text(
                              'Aa',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          ButtonSegment(
                            value: TextScaleOption.large,
                            label: Text(
                              'Aa',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          ButtonSegment(
                            value: TextScaleOption.xLarge,
                            label: Text(
                              'Aa',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                        selected: {settings.textScale},
                        onSelectionChanged: (set) => s.setTextScale(set.first),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Current: ${settings.textScale.label}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SettingsCard(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Silver Suite',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Big buttons. Clear text. Real help. Everything stays on this device â€” no account, no cloud, no tracking.',
                        style: TextStyle(fontSize: 15, height: 1.4),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: AppTheme.mute,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

class _PremiumBanner extends StatelessWidget {
  final PremiumState premium;
  final bool hideAds;
  const _PremiumBanner({required this.premium, required this.hideAds});

  @override
  Widget build(BuildContext context) {
    final active = premium.isPremium;
    final title = premium.hasLifetime
        ? 'Silver+ lifetime active'
        : (premium.isTrialActive
              ? 'Trial: ${premium.trialDaysRemaining} day${premium.trialDaysRemaining == 1 ? '' : 's'} left'
              : (hideAds ? 'Ads removed. Unlock forever' : 'Unlock Silver+'));
    final subtitle = premium.hasLifetime
        ? 'Thank you for supporting a calm, ad-free app.'
        : (premium.isTrialActive
              ? 'Enjoy everything now. Pay once after the trial to keep it forever.'
              : (hideAds
                    ? 'Unlock unlimited pills, contacts, and notes.'
                    : '7-day trial, then one lifetime purchase. No subscription.'));
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const PaywallScreen())),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: active
                ? AppTheme.greenGradient
                : AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: (active ? AppTheme.green : AppTheme.blue).withValues(
                  alpha: 0.3,
                ),
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
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(
                  active ? Icons.workspace_premium : Icons.auto_awesome,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF161A22) : AppTheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: dark ? const Color(0xFF2A2F3B) : AppTheme.outline,
        ),
      ),
      child: Column(children: children),
    );
  }
}
