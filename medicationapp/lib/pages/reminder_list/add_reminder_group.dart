import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/multiselect.dart';
import 'package:medicationapp/pages/reminder_list/reminder_data.dart';

import '../medication/medication_data.dart';

final _formKey = GlobalKey<FormState>();

class AddReminderGroup extends StatelessWidget {
  AddReminderGroup({super.key});

  final nameController = TextEditingController();
  TimeOfDay? timeOfDay = TimeOfDay.now();
  List<MedicationType> medication = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Add new reminder group',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.note),
                  label: Text('Name *'),
                ),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the name of the reminder group';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      var selectedTimeOfDay = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.dial,
                      );
                      if (selectedTimeOfDay != null) {
                        timeOfDay = selectedTimeOfDay;
                      }
                    },
                    child: const Text('Choose time'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      medication = await showDialog(
                          context: context,
                          builder: (BuildContext context) => MultiSelect());
                    },
                    child: const Text('Choose medication'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('New group added successfully'),
                      ),
                    );

                    ReminderGroup result = ReminderGroup(nameController.text, timeOfDay!, medication);
                    Navigator.pop(context, result);
                  }
                },
                child: const Text('Add group'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
