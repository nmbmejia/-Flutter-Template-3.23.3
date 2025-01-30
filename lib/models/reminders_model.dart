import 'dart:convert';

class Reminder {
  final int? id;
  final int userId;
  final String title;
  final double? amount;
  final bool isFixed;
  final int dueDay;
  final String recurrence;
  final DateTime startDate;
  final DateTime? endDate;

  Reminder({
    this.id,
    required this.userId,
    required this.title,
    this.amount,
    required this.isFixed,
    required this.dueDay,
    required this.recurrence,
    required this.startDate,
    this.endDate,
  });

  // Convert from JSON
  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      amount: json['amount'] != null ? json['amount'].toDouble() : null,
      isFixed:
          json['is_fixed'] == 1, // SQLite stores BOOLEAN as INTEGER (0 or 1)
      dueDay: json['due_day'],
      recurrence: json['recurrence'],
      startDate: DateTime.parse(json['start_date']),
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'amount': amount,
      'is_fixed': isFixed ? 1 : 0, // Convert BOOLEAN to SQLite format
      'due_day': dueDay,
      'recurrence': recurrence,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }

  // SQLite Table Creation Query
  static String createTableQuery = '''
    CREATE TABLE reminders (
      id INTEGER PRIMARY KEY,
      user_id INTEGER,
      title TEXT,
      amount DECIMAL(10,2) NULL,
      is_fixed BOOLEAN DEFAULT 1,
      due_day INTEGER,
      recurrence TEXT DEFAULT 'monthly',
      start_date DATE,
      end_date DATE NULL
    );
  ''';
}

class ReminderStatus {
  final int? id;
  final int reminderId;
  final int month;
  final int year;
  final String status;
  final double? amount;

  ReminderStatus({
    this.id,
    required this.reminderId,
    required this.month,
    required this.year,
    required this.status,
    this.amount,
  });

  // Convert from JSON
  factory ReminderStatus.fromJson(Map<String, dynamic> json) {
    return ReminderStatus(
      id: json['id'],
      reminderId: json['reminder_id'],
      month: json['month'],
      year: json['year'],
      status: json['status'],
      amount: json['amount'] != null ? json['amount'].toDouble() : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reminder_id': reminderId,
      'month': month,
      'year': year,
      'status': status,
      'amount': amount,
    };
  }
}
