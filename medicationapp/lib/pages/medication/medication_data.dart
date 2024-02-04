// Type of medication with name, dosage and quantity remaining
class MedicationType {
  String name;
  int quantityRemaining;
  int dosage;

  MedicationType(this.name, this.quantityRemaining, this.dosage);

  factory MedicationType.fromJson(dynamic json) {
    return MedicationType(
      json['name'] as String,
      json['quantityRemaining'] as int,
      json['dosage'] as int,
    );
  }

  Map toJson() {
    return {
      'name': name,
      'quantityRemaining': quantityRemaining,
      'dosage': dosage
    };
  }
}
