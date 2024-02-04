// Type of medication with name, dosage and quantity remaining

import 'package:uuid/uuid.dart';

class MedicationType {
  String id;
  String name;
  int quantityRemaining;
  int dosage;


  MedicationType(this.name, this.quantityRemaining, this.dosage) : id = Uuid().v4();
  MedicationType.withId(this.id, this.name, this.quantityRemaining, this.dosage);

  factory MedicationType.fromJson(dynamic json) {
    return MedicationType.withId(
      json['id'] as String,
      json['name'] as String,
      json['quantityRemaining'] as int,
      json['dosage'] as int,
    );
  }

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'quantityRemaining': quantityRemaining,
      'dosage': dosage
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationType &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
