import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';

class RepositoryService {
  final CollectionReference reminderCollection =
      FirebaseFirestore.instance.collection('reminder');

  final CollectionReference medicationCollection =
      FirebaseFirestore.instance.collection('medication');

  // List<MedicationType> _medicationListFromSnapshot(QuerySnapshot snapshot) {
  //   snapshot.docs.
  // }
}
