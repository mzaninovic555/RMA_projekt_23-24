import 'package:medicationapp/pages/medication/medication_data.dart';

import '../pages/reminder_list/reminder_data.dart';

class ReminderService {
  static List<ReminderGroup> getReminderGroups() {
    return [
      ReminderGroup('Morning', DateTime.now(), [
        MedicationType('Test 1', 1, 2),
        MedicationType('Test 2', 1, 2),
      ]),
      ReminderGroup('Evening', DateTime.now(), [
        MedicationType('Test 3', 1, 2),
      ]),
      ReminderGroup('Night', DateTime.now(), []),
    ];
  }
}
