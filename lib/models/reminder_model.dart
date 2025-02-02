import 'package:cloud_firestore/cloud_firestore.dart';

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
  final bool isPaid;

  Payment({
    required this.amount,
    required this.date,
    this.isPaid = false,
  });

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      amount: map['amount']?.toDouble() ?? 0.0,
      date: (map['date'] as Timestamp).toDate(),
      isPaid: map['isPaid'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'isPaid': isPaid,
    };
  }
}

class Reminder {
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
    if (data['sharedTo'] != null) {
      sharedToList = (data['sharedTo'] as List)
          .map((item) => SharedInfo.fromMap(item))
          .toList();
    }
    List<Payment> paymentsList = [];
    if (data['payments'] != null) {
      paymentsList = (data['payments'] as List)
          .map((item) => Payment.fromMap(item))
          .toList();
    }
    return Reminder(
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
      payments: paymentsList,
    );
  }

  // Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
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
