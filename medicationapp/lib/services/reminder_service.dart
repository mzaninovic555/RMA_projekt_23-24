import '../pages/reminder_list/reminder_data.dart';
import 'medication_service.dart';

class ReminderService {
  static List<ReminderGroup> getReminderGroups() {
    return [
      ReminderGroup('Morning', DateTime.now(), [
        MedicationService.mockMedication[0],
        MedicationService.mockMedication[1],
        MedicationService.mockMedication[2],
      ]),
      ReminderGroup('Evening', DateTime.now(), [
        MedicationService.mockMedication[2],
      ]),
      ReminderGroup('Night', DateTime.now(), []),
    ];
  }
}
