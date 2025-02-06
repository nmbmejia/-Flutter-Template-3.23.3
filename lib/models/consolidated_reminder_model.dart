import 'package:Acorn/models/reminder_model.dart';

// Basically plots the reminders for a specific date, only those dates that have reminders are here.
class ConsolidatedReminder {
  final DateTime date;
  final List<Reminder> reminders;

  ConsolidatedReminder({required this.date, required this.reminders});
}
