import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';
import 'package:medicationapp/pages/medication/multiselect.dart';
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
        onPressed: () {},
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
                reminderGroup.timeOfReminder.toString(),
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
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
            icon: const Icon(Icons.add_circle),
          )
        ],
      ),
      const SizedBox(
        height: 15.0,
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
