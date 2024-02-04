import 'package:medicationapp/pages/reminder_list/reminder_data.dart';

import '../pages/medication/medication_data.dart';

class MedicationService {
  static List<MedicationType> mockMedication = [
    MedicationType('Ibuprofen', 20, 2),
    MedicationType('Cijanid tablet', 20, 2),
    MedicationType('Xanax', 5, 1),
    MedicationType('Metanfetamin tablet', 15, 3),
  ];

  static List<MedicationType> _medicationList = [];

  static set setMedicationList(List<MedicationType>? newList) {
    _medicationList = newList ?? [];
  }

  static List<MedicationType> getMedication() {
    return _medicationList;
  }

  static void addMedication(MedicationType medication) {
    _medicationList.add(medication);
  }

  static void setMedicationByIndex(int index, MedicationType medication) {
    _medicationList[index] = medication;
  }

  static void refillMedicationByIndex(int index, int quantityToAdd) {
    _medicationList[index].quantityRemaining += quantityToAdd;
  }

  static void removeFromMedicationList(MedicationType medication) {
    _medicationList.remove(medication);
  }

  static List<MedicationType> getMedicationNotInGroup(ReminderGroup group) {
    return _medicationList
        .where((medication) => !group.medications.contains(medication))
        .toList();
  }
}
