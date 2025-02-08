import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/services/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReminderFirestoreService {
  Future<void> addReminder(Reminder reminder) async {
    // Create custom ID from start date and title
    final String customId =
        '${reminder.startDate.month.toString().padLeft(2, '0')}${reminder.startDate.day.toString().padLeft(2, '0')}${reminder.startDate.year}_${Constants.dateToday.hour.toString().padLeft(2, '0')}${Constants.dateToday.minute.toString().padLeft(2, '0')}${Constants.dateToday.second.toString().padLeft(2, '0')}_${reminder.title.replaceAll(' ', '')}';

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(reminder.userEmail)
        .collection('reminders')
        .doc(customId); // Use custom ID instead of auto-generated

    // Add the document ID to the reminder data
    final reminderData = reminder.toFirestore();
    reminderData['id'] = customId;

    await docRef.set(reminderData);
  }

  Future<void> removeReminder(Reminder reminder, DateTime inputDate) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(reminder.userEmail)
        .collection('reminders')
        .doc(reminder.id);

    // Get the reminder document
    final doc = await docRef.get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['endDate'] != null) {
        // Update end date to be one month earlier
        final DateTime newEndDate = DateTime(
          inputDate.year,
          inputDate.month - 1,
          inputDate.day,
        );
        await docRef.update({'endDate': Timestamp.fromDate(newEndDate)});
      } else {
        // Set new end date minus one month from input date
        final DateTime newEndDate = DateTime(
          inputDate.year,
          inputDate.month - 1,
          inputDate.day,
        );
        await docRef.update({'endDate': Timestamp.fromDate(newEndDate)});
      }
    }
  }

  Stream<List<Reminder>> getUserReminders(String userEmail) {
    return FirebaseFirestore.instance
        .collection('reminders')
        .where('userEmail', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Reminder.fromFirestore(doc)).toList());
  }

  Future<Reminder> getReminderById(String id) async {
    final docRef = FirebaseFirestore.instance.collection('reminders').doc(id);
    final docSnapshot = await docRef.get();
    return Reminder.fromFirestore(docSnapshot);
  }

  Future<bool> addPayment(
      String userEmail, String reminderId, Payment payment) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('reminders')
          .doc(reminderId);

      // Get current document
      final doc = await docRef.get();
      if (!doc.exists) {
        return false;
      }

      // Get existing payments and add new one
      List<dynamic> payments = doc.data()?['payments'] ?? [];
      payments.add(payment.toMap());

      // Update document with new payments array
      await docRef.update({'payments': payments});
      return true;
    } catch (e) {
      debugPrint('Error adding payment: $e');
      return false;
    }
  }

  Future<bool> deletePayment(
      String userEmail, String reminderId, DateTime date) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('reminders')
          .doc(reminderId);

      // Get current document
      final doc = await docRef.get();
      if (!doc.exists) {
        return false;
      }

      // Get existing payments and remove matching date
      List<dynamic> payments = doc.data()?['payments'] ?? [];
      payments.removeWhere((payment) {
        final paymentDate = (payment['date'] as Timestamp).toDate();
        return paymentDate.year == date.year &&
            paymentDate.month == date.month &&
            paymentDate.day == date.day;
      });

      // Update document with new payments array
      await docRef.update({'payments': payments});
      return true;
    } catch (e) {
      debugPrint('Error deleting payment: $e');
      return false;
    }
  }
}
