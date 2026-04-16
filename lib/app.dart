import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silver_suite/core/constants/theme.dart';
import 'package:silver_suite/core/models/settings.dart';
import 'package:silver_suite/providers/iap_provider.dart';
import 'package:silver_suite/providers/navigation_provider.dart';
import 'package:silver_suite/providers/settings_provider.dart';
import 'package:silver_suite/widgets/ad_banner_widget.dart';
import 'package:silver_suite/screens/contacts_screen.dart';
import 'package:silver_suite/screens/home_screen.dart';
import 'package:silver_suite/screens/more_screen.dart';
import 'package:silver_suite/screens/pills_screen.dart';

class SilverSuiteApp extends ConsumerStatefulWidget {
  const SilverSuiteApp({super.key});

  @override
  ConsumerState<SilverSuiteApp> createState() => _SilverSuiteAppState();
}

class _SilverSuiteAppState extends ConsumerState<SilverSuiteApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final iap = ref.read(iapServiceProvider);
      iap.onPurchaseSuccess = (productId) {
        ref.read(premiumProvider.notifier).activate(productId);
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp(
      title: 'Silver Suite',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(settings.textScale.factor),
      darkTheme: AppTheme.dark(settings.textScale.factor),
      themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const _AppShell(),
    );
  }
}

class _AppShell extends ConsumerWidget {
  const _AppShell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(tabProvider);
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        child: KeyedSubtree(
          key: ValueKey(tab),
          child: _screenFor(tab),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          AdBannerWidget(),
          _BottomNav(),
        ],
      ),
    );
  }

  Widget _screenFor(AppTab t) {
    switch (t) {
      case AppTab.home:
        return const HomeScreen();
      case AppTab.pills:
        return const PillsScreen();
      case AppTab.contacts:
        return const ContactsScreen();
      case AppTab.more:
        return const MoreScreen();
    }
  }
}

class _BottomNav extends ConsumerWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(tabProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF161A22) : AppTheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: dark ? const Color(0xFF2A2F3B) : AppTheme.outline,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Item(
              icon: Icons.home_rounded,
              label: 'Home',
              selected: tab == AppTab.home,
              onTap: () => ref.read(tabProvider.notifier).go(AppTab.home),
            ),
            _Item(
              icon: Icons.medication_outlined,
              label: 'Pills',
              selected: tab == AppTab.pills,
              onTap: () => ref.read(tabProvider.notifier).go(AppTab.pills),
            ),
            _Item(
              icon: Icons.phone_rounded,
              label: 'Call',
              selected: tab == AppTab.contacts,
              onTap: () =>
                  ref.read(tabProvider.notifier).go(AppTab.contacts),
            ),
            _Item(
              icon: Icons.apps_rounded,
              label: 'More',
              selected: tab == AppTab.more,
              onTap: () => ref.read(tabProvider.notifier).go(AppTab.more),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Item({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppTheme.blue
        : (Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFB2B8C4)
            : AppTheme.mute);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: selected ? AppTheme.blue.withValues(alpha: 0.12) : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
