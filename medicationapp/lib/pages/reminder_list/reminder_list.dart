import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/medication.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';
import 'package:medicationapp/pages/reminder_list/reminder_data.dart';
import 'package:medicationapp/services/reminder_service.dart';

class ReminderList extends StatefulWidget {
  const ReminderList({super.key});

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  List<ReminderGroup> reminderGroups = ReminderService.getReminderGroups();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          top: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children:
            reminderGroups.map(_convertReminderGroupToExpansionTile).toList(),
      ),
    );
  }

  ExpansionTile _convertReminderGroupToExpansionTile(ReminderGroup group) {
    return ExpansionTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${group.title} - ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Text(
            group.timeOfReminder.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10.0,
            ),
          ),
        ],
      ),
      collapsedBackgroundColor:
          group.color ?? Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).hoverColor,
      children: group.medications.isNotEmpty
          ? group.medications.map(_convertMedicationToWidget).toList()
          : [const Text('Empty group')],
    );
  }

  Widget _convertMedicationToWidget(MedicationType medication) {
    return Text(medication.name);
  }
}
