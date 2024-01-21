import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/add_medication.dart';

import 'medication_data.dart';

class Medication extends StatefulWidget {
  const Medication({super.key});

  @override
  State<Medication> createState() => _MedicationState();
}

class _MedicationState extends State<Medication> {
  List<MedicationType> mockMedication = [
    MedicationType('Ibuprofen', 20, 2),
    MedicationType('Cijanid tablet', 20, 2),
    MedicationType('Xanax', 5, 0.5),
    MedicationType('Metanfetamin tablet', 15, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          MedicationType newMedication = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMedication(),
              ));
          setState(() {
            mockMedication.add(newMedication);
          });
          // TODO add database etc.
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        itemCount: mockMedication.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text('${mockMedication[index].quantityRemaining}'),
            title: Text(mockMedication[index].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Icon(Icons.edit),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () async {
                    var modalValue = await showRefillDialog(mockMedication[index]);
                    setState(() {
                      mockMedication[index].quantityRemaining += modalValue ?? 0;
                    });
                  },
                  child: const Icon(Icons.add_circle),
                ),
              ],
            ),
          );
        },
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
              print('test test ${editModalController.text}');
              Navigator.pop(
                  context, int.tryParse(editModalController.text) ?? 0);
            },
            child: const Text('Refill'),
          )
        ],
      ),
    );
  }
}
