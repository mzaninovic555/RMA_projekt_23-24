// Type of medication with name, dosage and quantity remaining

import 'package:medicationapp/auth/auth.dart';
import 'package:uuid/uuid.dart';

class MedicationType {
  String id;
  String name;
  int quantityRemaining;
  int dosage;
  String? userId;

  MedicationType(this.name, this.quantityRemaining, this.dosage)
      : id = Uuid().v4(),
        userId = Auth().currentUser?.uid;

  MedicationType.withId(this.id, this.name, this.quantityRemaining, this.dosage)
      : userId = Auth().currentUser?.uid;

  MedicationType.withIdAndUserId(
      this.id, this.name, this.quantityRemaining, this.dosage, this.userId);

  factory MedicationType.fromJson(dynamic json) {
    return MedicationType.withIdAndUserId(
      json['id'] as String,
      json['name'] as String,
      json['quantityRemaining'] as int,
      json['dosage'] as int,
      json['userId'] is String ? json['userId'] as String : null,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'quantityRemaining': quantityRemaining,
      'dosage': dosage,
      'userId': userId
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
