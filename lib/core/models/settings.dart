import 'dart:convert';
import 'package:equatable/equatable.dart';

enum TextScaleOption { standard, large, xLarge }

extension TextScaleOptionX on TextScaleOption {
  double get factor => switch (this) {
        TextScaleOption.standard => 1.0,
        TextScaleOption.large => 1.15,
        TextScaleOption.xLarge => 1.3,
      };
  String get label => switch (this) {
        TextScaleOption.standard => 'Standard',
        TextScaleOption.large => 'Large',
        TextScaleOption.xLarge => 'Extra Large',
      };
}

class AppSettings extends Equatable {
  final TextScaleOption textScale;
  final bool darkMode;

  const AppSettings({
    this.textScale = TextScaleOption.large,
    this.darkMode = false,
  });

  AppSettings copyWith({TextScaleOption? textScale, bool? darkMode}) =>
      AppSettings(
        textScale: textScale ?? this.textScale,
        darkMode: darkMode ?? this.darkMode,
      );

  Map<String, dynamic> toJson() => {
        'textScale': textScale.name,
        'darkMode': darkMode,
      };

  factory AppSettings.fromJson(Map<String, dynamic> j) => AppSettings(
        textScale: TextScaleOption.values.firstWhere(
          (e) => e.name == j['textScale'],
          orElse: () => TextScaleOption.large,
        ),
        darkMode: j['darkMode'] as bool? ?? false,
      );

  String encode() => jsonEncode(toJson());
  factory AppSettings.decode(String s) =>
      AppSettings.fromJson(jsonDecode(s) as Map<String, dynamic>);

  @override
  List<Object?> get props => [textScale, darkMode];
}
