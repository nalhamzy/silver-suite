import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:silver_suite/core/constants/iap_ids.dart';

class PremiumState extends Equatable {
  static const trialLength = Duration(days: 7);

  final String? activeProductId;
  final DateTime? activatedAt;
  final DateTime? trialStartedAt;
  final bool adsRemoved;

  const PremiumState({
    this.activeProductId,
    this.activatedAt,
    this.trialStartedAt,
    this.adsRemoved = false,
  });

  bool get hasLifetime =>
      activeProductId == IapProductIds.premiumLifetime ||
      IapProductIds.legacyPremiumIds.contains(activeProductId);
  bool get isLifetime => activeProductId == IapProductIds.premiumLifetime;
  DateTime? get trialEndsAt => trialStartedAt?.add(trialLength);
  bool get isTrialActive {
    final endsAt = trialEndsAt;
    return !hasLifetime && endsAt != null && DateTime.now().isBefore(endsAt);
  }

  int get trialDaysRemaining {
    final endsAt = trialEndsAt;
    if (endsAt == null || hasLifetime) return 0;
    final remaining = endsAt.difference(DateTime.now());
    if (remaining.isNegative) return 0;
    return remaining.inDays + (remaining.inHours.remainder(24) > 0 ? 1 : 0);
  }

  bool get isPremium => hasLifetime || isTrialActive;

  /// Ads are hidden during the trial and forever after lifetime purchase.
  bool get hideAds => adsRemoved || isPremium;

  PremiumState copyWith({
    String? activeProductId,
    DateTime? activatedAt,
    DateTime? trialStartedAt,
    bool? adsRemoved,
  }) => PremiumState(
    activeProductId: activeProductId ?? this.activeProductId,
    activatedAt: activatedAt ?? this.activatedAt,
    trialStartedAt: trialStartedAt ?? this.trialStartedAt,
    adsRemoved: adsRemoved ?? this.adsRemoved,
  );

  Map<String, dynamic> toJson() => {
    'activeProductId': activeProductId,
    'activatedAt': activatedAt?.toIso8601String(),
    'trialStartedAt': trialStartedAt?.toIso8601String(),
    'adsRemoved': adsRemoved,
  };

  factory PremiumState.fromJson(Map<String, dynamic> j) => PremiumState(
    activeProductId: j['activeProductId'] as String?,
    activatedAt: j['activatedAt'] == null
        ? null
        : DateTime.tryParse(j['activatedAt'] as String),
    trialStartedAt: j['trialStartedAt'] == null
        ? null
        : DateTime.tryParse(j['trialStartedAt'] as String),
    adsRemoved: j['adsRemoved'] as bool? ?? false,
  );

  String encode() => jsonEncode(toJson());
  factory PremiumState.decode(String raw) =>
      PremiumState.fromJson(jsonDecode(raw) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
    activeProductId,
    activatedAt,
    trialStartedAt,
    adsRemoved,
  ];
}
