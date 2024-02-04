import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/add_medication.dart';
import 'package:medicationapp/services/local_data_service.dart';
import 'package:medicationapp/services/reminder_service.dart';

import '../../services/medication_service.dart';
import 'medication_data.dart';

//ignore: must_be_immutable
class Medication extends StatefulWidget {
  LocalDataService localDataService;

  Medication(this.localDataService, {super.key});

  @override
  State<Medication> createState() => _MedicationState();
}

class _MedicationState extends State<Medication> {
  List<MedicationType> medicationList = MedicationService.getMedication();

  @override
  Widget build(BuildContext context) {
    if (medicationList.isEmpty) {
      return Scaffold(
        body: const Padding(
          padding: EdgeInsets.all(30.0),
          child: Center(
            child:
            Text(
              'No medication currently added. '
                  'Add one with the floating button on the bottom',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            MedicationType newMedication = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMedication(),
                ));
            setState(() {
              MedicationService.addMedication(newMedication, widget.localDataService);
            });
            // TODO add database etc.
          },
          child: const Icon(Icons.add),
        ),
      );
    }

    return Scaffold(
      body: ListView.separated(
        itemCount: medicationList.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    '${medicationList[index].quantityRemaining}'),
                const Text('remaining')
              ],
            ),
            title: Column(
              children: [
                Text(
                  medicationList[index].name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'Dosage: ${medicationList[index].dosage.toString()}',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    var editedMedication = await showEditDialog(
                        medicationList[index]);
                    if (editedMedication != null) {
                      setState(() {
                        MedicationService.setMedicationByIndex(
                            index, editedMedication, widget.localDataService);
                      });
                    }
                  },
                  child: const Icon(Icons.edit),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () async {
                    var modalValue = await showRefillDialog(
                        medicationList[index]);
                    setState(() {
                      MedicationService.refillMedicationByIndex(
                          index, modalValue ?? 0, widget.localDataService);
                    });
                  },
                  child: const Icon(Icons.add_circle),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          MedicationType newMedication = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMedication(),
              ));
          setState(() {
            MedicationService.addMedication(newMedication, widget.localDataService);
          });
          // TODO add database etc.
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<int?> showRefillDialog(MedicationType medication) {
    var editModalController =
        TextEditingController(text: medication.dosage.toString());
    return showDialog<int?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Refill ${medication.name}'),
        content: TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.add_chart_sharp),
            hintText: 'Refill amount',
            label: Text('Refill'),
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
          controller: editModalController,
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Medication refilled!'),
                ),
              );
              Navigator.pop(
                  context, int.tryParse(editModalController.text) ?? 0);
            },
            child: const Text('Refill'),
          )
        ],
      ),
    );
  }

  Future<MedicationType?> showEditDialog(MedicationType medication) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: medication.name);
    final dosageController =
        TextEditingController(text: medication.dosage.toString());

    return showDialog<MedicationType?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${medication.name}'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.medication),
                  hintText: 'Name on the label',
                  label: Text('Name *'),
                ),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the name of the medication';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.medication),
                  hintText: 'How many do you take at a time?',
                  label: Text('Dosage *'),
                ),
                keyboardType: TextInputType.number,
                controller: dosageController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Dosage is required';
                  }
                  if (int.tryParse(value) == 0) {
                    return 'Your dosage cannot be zero';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Delete'),
            onPressed: () async {
              bool res = await showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Confirmation'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Are you sure you want to delete this medication?'),
                      Text(
                        'This will also remove it from any reminder group',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, null);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          MedicationService.removeFromMedicationList(
                              medication, widget.localDataService);
                          ReminderService.removeMedicationFromReminders(
                              medication);
                        });
                        Navigator.pop(context, true);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );

              if (res && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Medication deleted successfully'),
                  ),
                );
                Navigator.pop(context);
              }
            },
          ),
          TextButton(
            child: const Text('Edit'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Medication edited successfully'),
                  ),
                );
                var editedMedication = MedicationType(
                    nameController.text,
                    medication.quantityRemaining,
                    int.tryParse(dosageController.text)!);
                Navigator.pop(context, editedMedication);
              }
            },
          ),
        ],
      ),
    );
  }
}
