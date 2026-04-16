import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:silver_suite/core/constants/iap_ids.dart';

class PremiumState extends Equatable {
  final String? activeProductId;
  final DateTime? activatedAt;
  final bool adsRemoved;

  const PremiumState({
    this.activeProductId,
    this.activatedAt,
    this.adsRemoved = false,
  });

  bool get isPremium => activeProductId != null &&
      activeProductId != IapProductIds.removeAds;
  bool get isLifetime => activeProductId == IapProductIds.premiumLifetime;

  /// Ads gone if either: explicit removeAds purchase, OR any premium tier.
  bool get hideAds => adsRemoved || isPremium;

  PremiumState copyWith({
    String? activeProductId,
    DateTime? activatedAt,
    bool? adsRemoved,
  }) =>
      PremiumState(
        activeProductId: activeProductId ?? this.activeProductId,
        activatedAt: activatedAt ?? this.activatedAt,
        adsRemoved: adsRemoved ?? this.adsRemoved,
      );

  Map<String, dynamic> toJson() => {
        'activeProductId': activeProductId,
        'activatedAt': activatedAt?.toIso8601String(),
        'adsRemoved': adsRemoved,
      };

  factory PremiumState.fromJson(Map<String, dynamic> j) => PremiumState(
        activeProductId: j['activeProductId'] as String?,
        activatedAt: j['activatedAt'] == null
            ? null
            : DateTime.tryParse(j['activatedAt'] as String),
        adsRemoved: j['adsRemoved'] as bool? ?? false,
      );

  String encode() => jsonEncode(toJson());
  factory PremiumState.decode(String raw) =>
      PremiumState.fromJson(jsonDecode(raw) as Map<String, dynamic>);

  @override
  List<Object?> get props => [activeProductId, activatedAt, adsRemoved];
}
