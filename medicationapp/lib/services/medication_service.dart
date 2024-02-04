import 'dart:convert';

import 'package:medicationapp/pages/reminder_list/reminder_data.dart';
import 'package:medicationapp/services/local_data_service.dart';

import '../pages/medication/medication_data.dart';

class MedicationService {
  static List<MedicationType> mockMedication = [
    MedicationType('Ibuprofen', 20, 2),
    MedicationType('Cijanid tablet', 20, 2),
    MedicationType('Xanax', 5, 1),
    MedicationType('Metanfetamin tablet', 15, 3),
  ];

  static List<MedicationType> _medicationList = [];


  static List<MedicationType> getMedication() {
    return _medicationList;
  }

  static void setMedication(List<MedicationType> newList) {
    _medicationList = newList;
  }

  static void addMedication(
      MedicationType medication, LocalDataService localDataService) {
    _medicationList.add(medication);
    _saveToPreferences(localDataService);
  }

  static void setMedicationByIndex(
      int index, MedicationType medication, LocalDataService localDataService) {
    _medicationList[index] = medication;
    _saveToPreferences(localDataService);
  }

  static void refillMedicationByIndex(
      int index, int quantityToAdd, LocalDataService localDataService) {
    _medicationList[index].quantityRemaining += quantityToAdd;
    _saveToPreferences(localDataService);
  }

  static void removeFromMedicationList(
      MedicationType medication, LocalDataService localDataService) {
    _medicationList.remove(medication);
    _saveToPreferences(localDataService);
  }

  static List<MedicationType> getMedicationNotInGroup(ReminderGroup group) {
    return _medicationList
        .where((medication) => !group.medications.contains(medication))
        .toList();
  }

  static void _saveToPreferences(LocalDataService localDataService) {
    var medicationJson = json.encode(_medicationList);
    localDataService.setMedication(medicationJson);
  }

  static Future<void> getFromPreferences(
      LocalDataService localDataService) async {
    var fromStorage = localDataService.getMedication();

    if (fromStorage == null) {
      _medicationList = [];
      return;
    }

    _medicationList = (json.decode(fromStorage) as List)
        .map((object) => MedicationType.fromJson(object))
        .toList();
  }
}
