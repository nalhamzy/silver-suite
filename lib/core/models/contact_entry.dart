import 'package:equatable/equatable.dart';

class ContactEntry extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String relation;    // e.g. Son, Doctor, Neighbor
  final bool isEmergency;

  const ContactEntry({
    required this.id,
    required this.name,
    required this.phone,
    this.relation = '',
    this.isEmergency = false,
  });

  ContactEntry copyWith({
    String? name,
    String? phone,
    String? relation,
    bool? isEmergency,
  }) =>
      ContactEntry(
        id: id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        relation: relation ?? this.relation,
        isEmergency: isEmergency ?? this.isEmergency,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'relation': relation,
        'isEmergency': isEmergency,
      };

  factory ContactEntry.fromJson(Map<String, dynamic> j) => ContactEntry(
        id: j['id'] as String,
        name: j['name'] as String,
        phone: j['phone'] as String,
        relation: j['relation'] as String? ?? '',
        isEmergency: j['isEmergency'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [id, name, phone, relation, isEmergency];
}
