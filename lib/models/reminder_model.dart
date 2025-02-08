import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ReminderRecurrence {
  once,
  daily,
  weekly,
  monthly,
  yearly,
}

class SharedInfo {
  final String email;
  final DateTime date;

  SharedInfo({required this.email, required this.date});

  factory SharedInfo.fromMap(Map<String, dynamic> map) {
    return SharedInfo(
      email: map['email'],
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'date': Timestamp.fromDate(date),
    };
  }
}

class Payment {
  final double amount;
  final DateTime date;

  Payment({
    required this.amount,
    required this.date,
  });

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      amount: map['amount']?.toDouble() ?? 0.0,
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': Timestamp.fromDate(date),
    };
  }
}

class Reminder {
  String id;
  final String userEmail;
  final String title;
  final double? amount;
  final bool isFixed;
  final int dueDay;
  final ReminderRecurrence recurrence;
  final DateTime startDate;
  final DateTime? endDate;
  final List<SharedInfo> sharedTo;
  final List<Payment> payments;

  Reminder({
    this.id = '',
    required this.userEmail,
    required this.title,
    this.amount,
    required this.isFixed,
    required this.dueDay,
    required this.recurrence,
    required this.startDate,
    this.endDate,
    this.sharedTo = const [],
    this.payments = const [],
  });

  // Convert from Firestore document
  factory Reminder.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    List<SharedInfo> sharedToList = [];
    List<Payment> paymentsList = [];
    if (data['sharedTo'] != null) {
      sharedToList = (data['sharedTo'] as List)
          .map((item) => SharedInfo.fromMap(item))
          .toList();
    }
    if (data['payments'] != null) {
      paymentsList = (data['payments'] as List)
          .map((item) => Payment.fromMap(item))
          .toList();
    }
    // Payments are now in a subcollection, not in the document data
    return Reminder(
      id: doc.id,
      userEmail: data['userEmail'],
      title: data['title'],
      amount: data['amount']?.toDouble(),
      isFixed: data['isFixed'] ?? true,
      dueDay: data['dueDay'],
      recurrence: ReminderRecurrence.values.firstWhere(
        (e) => e.toString().split('.').last == data['recurrence'],
        orElse: () => ReminderRecurrence.once,
      ),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: data['endDate'] != null
          ? (data['endDate'] as Timestamp).toDate()
          : null,
      sharedTo: sharedToList,
      payments: paymentsList, // Empty list since payments are in subcollection
    );
  }

  // Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userEmail': userEmail,
      'title': title,
      'amount': amount,
      'isFixed': isFixed,
      'dueDay': dueDay,
      'recurrence': recurrence.toString().split('.').last,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'sharedTo': sharedTo.map((info) => info.toMap()).toList(),
      'payments': payments.map((payment) => payment.toMap()).toList(),
    };
  }
}
