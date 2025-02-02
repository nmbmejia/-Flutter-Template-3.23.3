import 'package:Acorn/models/reminder_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderFirestoreService {
  Future<void> addReminder(Reminder reminder) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(reminder.userEmail)
        .collection('reminders')
        .add(reminder.toFirestore());
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
