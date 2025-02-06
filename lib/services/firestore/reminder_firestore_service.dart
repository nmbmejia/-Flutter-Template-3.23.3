import 'package:Acorn/models/reminder_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderFirestoreService {
  Future<void> addReminder(Reminder reminder) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(reminder.userEmail)
        .collection('reminders')
        .doc(); // Create doc reference with auto-generated ID

    // Add the document ID to the reminder data
    final reminderData = reminder.toFirestore();
    reminderData['id'] = docRef.id;

    await docRef.set(reminderData);
  }

  Stream<List<Reminder>> getUserReminders(String userEmail) {
    return FirebaseFirestore.instance
        .collection('reminders')
        .where('userEmail', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Reminder.fromFirestore(doc)).toList());
  }
}
