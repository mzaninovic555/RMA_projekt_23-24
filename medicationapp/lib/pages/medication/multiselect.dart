import 'package:flutter/material.dart';
import 'package:medicationapp/pages/reminder_list/reminder_data.dart';

import '../../services/medication_service.dart';
import 'medication_data.dart';

class MultiSelect extends StatefulWidget {
  late final List<MedicationType> items;
  final ReminderGroup? reminderGroup;

  MultiSelect({super.key, this.reminderGroup}) {
    if (reminderGroup != null) {
      items = MedicationService.getMedicationNotInGroup(reminderGroup!);
    } else {
      items = MedicationService.mockMedication;
    }
  }

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<MedicationType> _selectedItems = [];

  void _itemChange(MedicationType itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
        return;
      }
      _selectedItems.remove(itemValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reminderGroup != null) {
      AlertDialog(
        title: Text('Add medication to \'${widget.reminderGroup!.title}\''),
        content: SingleChildScrollView(
          child: ListBody(
            children: widget.items
                .map((item) => CheckboxListTile(
              value: _selectedItems.contains(item),
              title: Text(item.name),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (isChecked) => _itemChange(item, isChecked!),
            ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, []);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedItems);
            },
            child: const Text('Add'),
          ),
        ],
      );
    }
    return AlertDialog(
      title: const Text('Select medication'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item.name),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked!),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, []);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, _selectedItems);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
