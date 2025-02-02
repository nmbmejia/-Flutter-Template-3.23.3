import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderStatus {
  final String id;
  final int month;
  final int year;
  final String status;
  final double? amount;

  ReminderStatus({
    required this.id,
    required this.month,
    required this.year,
    required this.status,
    this.amount,
  });

  // Convert from Firestore document
  factory ReminderStatus.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ReminderStatus(
      id: doc.id,
      month: data['month'],
      year: data['year'],
      status: data['status'],
      amount: data['amount']?.toDouble(),
    );
  }

  // Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'month': month,
      'year': year,
      'status': status,
      'amount': amount,
    };
  }
}
