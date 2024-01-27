import 'package:medicationapp/pages/reminder_list/reminder_data.dart';

import '../pages/medication/medication_data.dart';

class MedicationService {
  static List<MedicationType> mockMedication = [
    MedicationType('Ibuprofen', 20, 2),
    MedicationType('Cijanid tablet', 20, 2),
    MedicationType('Xanax', 5, 0.5),
    MedicationType('Metanfetamin tablet', 15, 1),
  ];

  static List<MedicationType> getMedicationNotInGroup(ReminderGroup group) {
    return mockMedication
        .where((medication) => !group.medications.contains(medication))
        .toList();
  }
}
