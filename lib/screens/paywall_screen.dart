import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silver_suite/core/constants/iap_ids.dart';
import 'package:silver_suite/core/constants/theme.dart';
import 'package:silver_suite/core/services/iap_service.dart';
import 'package:silver_suite/core/utils/responsive.dart';
import 'package:silver_suite/providers/iap_provider.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  String _selected = IapProductIds.premiumLifetime;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final hideAds = ref.watch(hideAdsProvider);
    final premium = ref.watch(premiumProvider);
    final productsAsync = ref.watch(iapProductsProvider);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveContentBox(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              context.s(20),
              context.s(12),
              context.s(20),
              context.s(40),
            ),
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 30),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.blue.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'SILVER+',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.blue,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                premium.isTrialActive
                    ? 'Your 7-day trial is active.'
                    : 'Unlock everything forever.',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 10),
              Text(
                premium.isTrialActive
                    ? '${premium.trialDaysRemaining} day${premium.trialDaysRemaining == 1 ? '' : 's'} left, then one payment keeps Silver+ forever. No subscription.'
                    : 'One payment, no subscription. Keeps the people you call and the pills you take at your fingertips.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 22),
              if (premium.hasLifetime)
                _DoneCard(msg: 'Silver+ lifetime active. Thank you.')
              else if (premium.isTrialActive)
                _DoneCard(
                  msg:
                      'Trial active: ${premium.trialDaysRemaining} day${premium.trialDaysRemaining == 1 ? '' : 's'} left.',
                )
              else if (hideAds)
                _DoneCard(msg: 'Ads removed. Upgrade for unlimited features.'),
              if (!premium.hasLifetime) ...[
                const _PerksList(),
                const SizedBox(height: 18),
                productsAsync.when(
                  data: (products) => _ProductPicker(
                    products: products,
                    selected: _selected,
                    onSelect: (id) => setState(() => _selected = id),
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: AppTheme.blue),
                    ),
                  ),
                  error: (_, _) => _ProductPicker(
                    products: _fallbackProducts,
                    selected: _selected,
                    onSelect: (id) => setState(() => _selected = id),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.blue,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _busy ? null : () => _handleBuy(_selected),
                    child: _busy
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.4,
                            ),
                          )
                        : const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: _handleRestore,
                    child: const Text(
                      'Restore purchases',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const _FinePrint(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleBuy(String productId) async {
    setState(() => _busy = true);
    HapticFeedback.mediumImpact();
    final ok = await ref.read(iapServiceProvider).buy(productId);
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't start checkout. Try again.")),
      );
    }
  }

  Future<void> _handleRestore() async {
    HapticFeedback.selectionClick();
    await ref.read(iapServiceProvider).restore();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Restored purchases (if any).')),
    );
  }

  static const _fallbackProducts = <IapProduct>[
    IapProduct(
      id: IapProductIds.premiumLifetime,
      title: 'Silver+ Lifetime',
      description: 'One payment after the 7-day trial. Keep forever.',
      price: r'$29.99',
      rawPrice: 29.99,
      currencyCode: 'USD',
    ),
  ];
}

class _PerksList extends StatelessWidget {
  const _PerksList();
  @override
  Widget build(BuildContext context) {
    const perks = [
      ('ðŸš«', 'No ads, ever', 'A calm screen when you\'re tired or stressed.'),
      ('ðŸ’Š', 'Unlimited pills', 'Track every medication. No caps.'),
      ('ðŸ“ž', 'Unlimited contacts', 'Every family member + every doctor.'),
      (
        'ðŸ“',
        'Unlimited notes',
        'Write as much as you need, as large as you need.',
      ),
      (
        'ðŸ”',
        'Privacy forever',
        'No trackers. No accounts. Data stays on this device.',
      ),
    ];
    return Column(
      children: [
        for (final p in perks)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.blue.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(p.$1, style: const TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.$2, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(p.$3, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ProductPicker extends StatelessWidget {
  final List<IapProduct> products;
  final String selected;
  final void Function(String) onSelect;
  const _ProductPicker({
    required this.products,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final order = <String>[IapProductIds.premiumLifetime];
    final sorted = [
      for (final id in order)
        products.firstWhere(
          (p) => p.id == id,
          orElse: () => _PaywallScreenState._fallbackProducts.firstWhere(
            (p) => p.id == id,
          ),
        ),
    ];
    return Column(
      children: [
        for (final p in sorted)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ProductTile(
              product: p,
              selected: selected == p.id,
              onTap: () => onSelect(p.id),
            ),
          ),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  final IapProduct product;
  final bool selected;
  final VoidCallback onTap;
  const _ProductTile({
    required this.product,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final badge = product.id == IapProductIds.premiumLifetime
        ? 'PAY ONCE'
        : null;
    return Material(
      color: selected
          ? AppTheme.blue.withValues(alpha: 0.10)
          : (dark ? const Color(0xFF161A22) : AppTheme.surface),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? AppTheme.blue
                  : (dark ? const Color(0xFF2A2F3B) : AppTheme.outline),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppTheme.blue : Colors.transparent,
                  border: Border.all(
                    color: selected ? AppTheme.blue : AppTheme.outline,
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            product.title,
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.blue,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              badge,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                product.price,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinePrint extends StatelessWidget {
  const _FinePrint();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Text(
        'Your trial is stored on this device. Silver+ Lifetime is a one-time '
        'purchase processed by the App Store or Google Play. Restore anytime '
        'on any device signed in to the same store account.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, height: 1.5),
      ),
    );
  }
}

class _DoneCard extends StatelessWidget {
  final String msg;
  const _DoneCard({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.green.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              gradient: AppTheme.greenGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              msg,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.green),
            ),
          ),
        ],
      ),
    );
  }
}
