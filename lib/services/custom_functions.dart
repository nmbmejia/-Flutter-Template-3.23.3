// import 'package:Acorn/models/personal_data_model.dart';

import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomFunctions {
  // Others

  static String? getIconForReminder(Reminder reminder) {
    final InitialController initialController = Get.find<InitialController>();

    return initialController.appData.value.services
            ?.firstWhereOrNull((service) => service.name == reminder.title)
            ?.icon ??
        'others.png'; // Placeholder return
  }

  // Subscription related

  static List<Reminder> getRemindersForMonth(
      List<Reminder> allReminders, DateTime month) {
    return allReminders.where((reminder) {
      // For one-time reminders, check if it falls in this month
      if (reminder.recurrence == ReminderRecurrence.once) {
        return reminder.startDate.year == month.year &&
            reminder.startDate.month == month.month;
      }

      // For recurring reminders, check if this month falls within start/end dates
      bool withinDateRange = DateTime(month.year, month.month)
              .isAfter(reminder.startDate.subtract(const Duration(days: 1))) &&
          (reminder.endDate == null ||
              DateTime(month.year, month.month).isBefore(
                  DateTime(reminder.endDate!.year, reminder.endDate!.month)
                      .add(const Duration(days: 32))));

      if (!withinDateRange) return false;

      switch (reminder.recurrence) {
        case ReminderRecurrence.daily:
          return true;
        case ReminderRecurrence.weekly:
          // Check if any day in this month matches the due weekday
          final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
          for (int day = 1; day <= daysInMonth; day++) {
            if (DateTime(month.year, month.month, day).weekday ==
                reminder.dueDay) {
              return true;
            }
          }
          return false;
        case ReminderRecurrence.monthly:
          // Check if due day exists in this month
          final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
          return reminder.dueDay <= daysInMonth;
        case ReminderRecurrence.yearly:
          return month.month == reminder.startDate.month;
        default:
          return false;
      }
    }).toList();
  }

  static List<Reminder> getRemindersForDay(
      List<Reminder> allReminders, DateTime date) {
    return allReminders.where((reminder) {
      // For one-time reminders, check if the start date matches
      if (reminder.recurrence == ReminderRecurrence.once) {
        return reminder.startDate.year == date.year &&
            reminder.startDate.month == date.month &&
            reminder.startDate.day == date.day;
      }

      // For recurring reminders, check if date falls within start/end dates
      bool withinDateRange = date
              .isAfter(reminder.startDate.subtract(const Duration(days: 1))) &&
          (reminder.endDate == null ||
              date.isBefore(reminder.endDate!.add(const Duration(days: 1))));

      if (!withinDateRange) return false;

      switch (reminder.recurrence) {
        case ReminderRecurrence.daily:
          return true;
        case ReminderRecurrence.weekly:
          return date.weekday == reminder.dueDay;
        case ReminderRecurrence.monthly:
          return date.day == reminder.dueDay;
        case ReminderRecurrence.yearly:
          return date.month == reminder.startDate.month &&
              date.day == reminder.startDate.day;
        default:
          return false;
      }
    }).toList();
  }

  static double getTotalAmountForSubscriptions(List<Reminder> reminders) {
    return reminders.fold(0.0, (total, reminder) => total + reminder.amount!);
  }

  static double? hasPaymentBeenMade(Reminder reminder, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    final payment = reminder.payments.firstWhereOrNull((payment) {
      final paymentDate =
          DateTime(payment.date.year, payment.date.month, payment.date.day);

      return paymentDate == normalizedDate && payment.isPaid == true;
    });

    return payment?.amount;
  }

  static bool hasMadeAnyPayment(List<Reminder> reminders, DateTime date) {
    for (var reminder in reminders) {
      for (var payment in reminder.payments) {
        if (DateUtils.isSameDay(payment.date, date) && payment.isPaid) {
          return true;
        }
      }
    }
    return false;
  }
}

// class CustomFunctions {
//   //General (List of subscribed services for the day)
//   static List<SubscribedService> getSubscriptionsByDay(
//       List<SubscribedService> subscriptions, int day) {
//     return subscriptions.where((subscription) {
//       if (subscription.date == null) return false;

//       // Check if the day and month match the subscription date's day and month
//       return subscription.date!.day == day;
//     }).toList();
//   }

//   static double getTotalAmountForSubscriptions(
//       List<SubscribedService>? servicesSubscribedThisDay) {
//     if (servicesSubscribedThisDay == null ||
//         servicesSubscribedThisDay.isEmpty) {
//       return 0.0; // Return 0 if the list is null or empty
//     }

//     return servicesSubscribedThisDay.fold(
//         0.0, (total, subscription) => total + subscription.price);
//   }

//   static bool hasMadeAnyPayment(
//       List<SubscribedService> services, DateTime currentDate) {
//     DateTime normalizedDate =
//         DateTime(currentDate.year, currentDate.month, currentDate.day);

//     for (SubscribedService service in services) {
//       bool hasPayment = service.payments.any((payment) {
//         if (payment.date != null) {
//           DateTime paymentDate = DateTime(
//               payment.date!.year, payment.date!.month, payment.date!.day);
//           return paymentDate == normalizedDate;
//         }
//         return false;
//       });

//       if (hasPayment) {
//         return true;
//       }
//     }

//     return false;
//   }

//   // Specfici service related for a specific date

//   static bool hasMadePayment(SubscribedService subscription, DateTime date) {
//     return subscription.payments.any((payment) =>
//         payment.date != null &&
//         payment.date!.year == date.year &&
//         payment.date!.month == date.month &&
//         payment.date!.day == date.day);
//   }

//   static Payment? getPaymentForToday(
//       SubscribedService subscription, DateTime date) {
//     try {
//       return subscription.payments.firstWhere(
//         (payment) =>
//             payment.date != null &&
//             payment.date!.year == date.year &&
//             payment.date!.month == date.month &&
//             payment.date!.day == date.day,
//       );
//     } catch (e) {
//       return null; // Return null when no match is found.
//     }
//   }
// }
