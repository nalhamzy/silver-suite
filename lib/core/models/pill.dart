import 'package:equatable/equatable.dart';

class PillSchedule extends Equatable {
  final String id;
  final String name;       // Atorvastatin 20mg
  final String? dosage;    // "1 tablet"
  final List<String> timesOfDay; // HH:mm strings (24h)
  final String color;      // hex without #, e.g. "FFB347"
  final String? notes;

  const PillSchedule({
    required this.id,
    required this.name,
    this.dosage,
    this.timesOfDay = const ['08:00'],
    this.color = '1864C0',
    this.notes,
  });

  PillSchedule copyWith({
    String? name,
    String? dosage,
    List<String>? timesOfDay,
    String? color,
    String? notes,
  }) =>
      PillSchedule(
        id: id,
        name: name ?? this.name,
        dosage: dosage ?? this.dosage,
        timesOfDay: timesOfDay ?? this.timesOfDay,
        color: color ?? this.color,
        notes: notes ?? this.notes,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dosage': dosage,
        'timesOfDay': timesOfDay,
        'color': color,
        'notes': notes,
      };

  factory PillSchedule.fromJson(Map<String, dynamic> j) => PillSchedule(
        id: j['id'] as String,
        name: j['name'] as String,
        dosage: j['dosage'] as String?,
        timesOfDay: List<String>.from(j['timesOfDay'] ?? const ['08:00']),
        color: j['color'] as String? ?? '1864C0',
        notes: j['notes'] as String?,
      );

  @override
  List<Object?> get props => [id, name, dosage, timesOfDay, color, notes];
}

/// Single taken log.
class PillLog extends Equatable {
  final String id;
  final String pillId;
  final String timeOfDay; // HH:mm
  final DateTime takenAt;

  const PillLog({
    required this.id,
    required this.pillId,
    required this.timeOfDay,
    required this.takenAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'pillId': pillId,
        'timeOfDay': timeOfDay,
        'takenAt': takenAt.toIso8601String(),
      };

  factory PillLog.fromJson(Map<String, dynamic> j) => PillLog(
        id: j['id'] as String,
        pillId: j['pillId'] as String,
        timeOfDay: j['timeOfDay'] as String,
        takenAt: DateTime.parse(j['takenAt'] as String),
      );

  @override
  List<Object?> get props => [id, pillId, timeOfDay, takenAt];
}
