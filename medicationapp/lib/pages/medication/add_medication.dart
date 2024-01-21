import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';

final _formKey = GlobalKey<FormState>();

class AddMedication extends StatelessWidget {
  AddMedication({super.key});

  final nameController = TextEditingController() ;
  final quantityController = TextEditingController(text: '0.0');
  final dosageController = TextEditingController() ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Add new medication',
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
                  icon: Icon(Icons.add_chart_sharp),
                  hintText: 'Do you have any amount currently',
                  label: Text('Quantity *'),
                ),
                keyboardType: TextInputType.number,
                controller: quantityController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'If you don\'t have any medication currently, input zero';
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
                  if (double.tryParse(value) == 0.0) {
                    return 'Your dosage cannot be zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Medication added successfully'),
                      ),
                    );

                    int quantity = int.tryParse(quantityController.text) ?? 0;
                    double dosage = double.tryParse(dosageController.text.replaceAll(',', '.'))!;
                    MedicationType result = MedicationType(nameController.text, quantity, dosage);
                    Navigator.pop(context, result);
                  }
                },
                child: const Text('Add medication'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
