import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/multiselect.dart';
import 'package:medicationapp/pages/reminder_list/reminder_data.dart';

import '../../common/time_formatter.dart';
import '../medication/medication_data.dart';

final _formKey = GlobalKey<FormState>();

//ignore: must_be_immutable
class EditReminderGroup extends StatefulWidget {
  final ReminderGroup existingGroup;

  late final TextEditingController nameController;
  TimeOfDay? timeOfDay = TimeOfDay.now();
  List<MedicationType> medication = [];

  EditReminderGroup({super.key, required this.existingGroup}) {
    nameController = TextEditingController(text: existingGroup.title);
    timeOfDay = existingGroup.timeOfReminder;
    medication = existingGroup.medications;
  }

  @override
  State<EditReminderGroup> createState() => _EditReminderGroupState();
}

class _EditReminderGroupState extends State<EditReminderGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Edit reminder group',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.note),
                  label: Text('Name *'),
                ),
                controller: widget.nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the name of the reminder group';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          var selectedTimeOfDay = await showTimePicker(
                              context: context,
                              initialTime: widget.timeOfDay!,
                              initialEntryMode: TimePickerEntryMode.dial,
                              builder: (BuildContext context, Widget? child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                              });
                          if (selectedTimeOfDay != null) {
                            setState(() {
                              widget.timeOfDay = selectedTimeOfDay;
                            });
                          }
                        },
                        child: const Text('Choose time'),
                      ),
                      const SizedBox(width: 10.0),
                      Text(TimeFormatter.formatTimeOfDay(
                          context, widget.timeOfDay!)),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() async {
                        widget.medication = await showDialog(
                            context: context,
                            builder: (BuildContext context) => MultiSelect(
                                reminderGroup: widget.existingGroup));
                      });
                    },
                    child: const Text('Choose medication'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Group edited successfully'),
                    ),
                  );

                  ReminderGroup result = ReminderGroup(
                      widget.nameController.text,
                      widget.timeOfDay!,
                      widget.medication);
                  Navigator.pop(context, result);
                }
              },
              child: const Text('Edit group'),
            ),
          ],
        ),
      ),
    );
  }
}
