import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';
import 'package:medicationapp/pages/medication/multiselect.dart';
import 'package:medicationapp/pages/reminder_list/edit_reminder_group.dart';
import 'package:medicationapp/pages/reminder_list/reminder_data.dart';
import 'package:medicationapp/services/reminder_service.dart';

import '../../common/time_formatter.dart';
import 'add_reminder_group.dart';

class ReminderList extends StatefulWidget {
  const ReminderList({super.key});

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  List<ReminderGroup> reminderGroups = ReminderService.getReminderGroups();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 15.0, bottom: 80.0),
          decoration: BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 1.0,
              ),
            ),
          ),
          child: Column(
            children: ReminderService.getReminderGroups()
                .map((group) => _mapReminderGroupToWidget(group))
                .toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ReminderGroup newReminderGroup = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddReminderGroup(),
              ));

          setState(() {
            ReminderService.addNewReminderGroup(newReminderGroup);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _mapReminderGroupToWidget(ReminderGroup reminderGroup) {
    int groupIndex = ReminderService.getReminderGroups().indexOf(reminderGroup);

    List<Widget> medicationChildren = [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reminderGroup.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 24.0,
                ),
              ),
              Text(
                TimeFormatter.formatTimeOfDay(context, reminderGroup.timeOfReminder),
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      const SizedBox(height: 5,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () async {
              setState(() {
                ReminderService.takeMedicationInGroup(reminderGroup);
              });
            },
            child: const Text('Take'),
          ),
          TextButton(
            onPressed: () async {
              List<MedicationType> selectedTypes = await showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      MultiSelect(reminderGroup: reminderGroup));
              setState(() {
                ReminderService.addMedicationItemsToGroup(
                    groupIndex, selectedTypes);
              });
            },
            child: const Text('Add'),
          ),
          TextButton(
            onPressed: () async {
              ReminderGroup newReminderGroup = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditReminderGroup(existingGroup: reminderGroup),
                  ));

              setState(() {
                ReminderService.editReminderGroup(reminderGroup, newReminderGroup);
              });
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () async {
              bool res = await showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      AlertDialog(
                        title: Text('Delete ${reminderGroup.title}'),
                        content: const Text('Are you sure you want to delete this reminder group?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ));

              if (res) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Group deleted successfully'),
                    ),
                  );
                }

                setState(() {
                  ReminderService.removeReminderGroup(reminderGroup);
                });
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
      const SizedBox(
        height: 5.0,
      ),
    ];
    medicationChildren.addAll(reminderGroup.medications.isEmpty
        ? [const Text('No medication in this group')]
        : reminderGroup.medications
            .map((medication) => _mapMedicationToWidget(groupIndex, medication))
            .toList());
    medicationChildren.add(const SizedBox(
      height: 10.0,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: medicationChildren,
          ),
        ),
        Divider(
          thickness: 0.5,
          color: Colors.grey[700],
        ),
        const SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget _mapMedicationToWidget(int groupIndex, MedicationType medication) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.medication),
            title: Text(medication.name),
            subtitle: Text('${medication.quantityRemaining} remaining.'),
            trailing: TextButton(
              child: const Text('REMOVE'),
              onPressed: () {
                setState(() {
                  ReminderService.removeFromReminderGroup(
                      groupIndex, medication);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
