import 'package:Acorn/models/reminder_status_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderStatusFirestoreService {
  Future<void> addReminderStatus(
      String reminderId, ReminderStatus status) async {
    await FirebaseFirestore.instance
        .collection('reminders')
        .doc(reminderId)
        .collection('statuses')
        .doc('${status.year}_${status.month}')
        .set(status.toFirestore());
  }

  Stream<List<ReminderStatus>> getReminderStatuses(String reminderId) {
    return FirebaseFirestore.instance
        .collection('reminders')
        .doc(reminderId)
        .collection('statuses')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReminderStatus.fromFirestore(doc))
            .toList());
  }
}
