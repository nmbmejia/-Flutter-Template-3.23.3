// import 'package:Acorn/models/personal_data_model.dart';

import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/firestore/reminder_firestore_service.dart';
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
    if (allReminders.isEmpty) return [];
    return allReminders.where((reminder) {
      // Check if reminder falls within the month
      DateTime monthStart = DateTime(month.year, month.month, 1);
      DateTime monthEnd = DateTime(month.year, month.month + 1, 0);

      // For one-time reminders
      if (reminder.recurrence == ReminderRecurrence.once) {
        return reminder.startDate
                .isAfter(monthStart.subtract(const Duration(days: 1))) &&
            reminder.startDate.isBefore(monthEnd.add(const Duration(days: 1)));
      }

      // For recurring reminders
      bool withinDateRange =
          reminder.startDate.isBefore(monthEnd.add(const Duration(days: 1))) &&
              (reminder.endDate == null ||
                  reminder.endDate!
                      .isAfter(monthStart.subtract(const Duration(days: 1))));

      if (!withinDateRange) return false;

      switch (reminder.recurrence) {
        case ReminderRecurrence.daily:
          return true;
        case ReminderRecurrence.weekly:
          // Check if any day in the month matches the due weekday
          for (var day = monthStart;
              day.isBefore(monthEnd.add(const Duration(days: 1)));
              day = day.add(const Duration(days: 1))) {
            if (day.weekday == reminder.dueDay) return true;
          }
          return false;
        case ReminderRecurrence.monthly:
          return reminder.dueDay <= monthEnd.day;
        case ReminderRecurrence.yearly:
          return reminder.startDate.month == month.month;
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

  // returns true if payment has been made on the date
  static bool hasPaymentBeenMade(Reminder reminder, DateTime date) {
    final payment = reminder.payments.firstWhereOrNull((payment) {
      return payment.date.year == date.year && payment.date.month == date.month;
    });

    return payment != null;
  }

  static DateTime? whenPaymentBeenMade(Reminder reminder, DateTime date) {
    final payment = reminder.payments.firstWhereOrNull((payment) {
      return payment.date.year == date.year && payment.date.month == date.month;
    });

    if (payment == null) return null;

    return DateTime(payment.date.year, payment.date.month, payment.date.day);
  }

  // returns the amount of payment made on the date, null if no payment has been made
  static double? howMuchPaymentBeenMade(Reminder reminder, DateTime date) {
    if (reminder.isFixed) {
      return reminder.amount;
    }

    final payment = reminder.payments.firstWhereOrNull((payment) {
      return payment.date.year == date.year && payment.date.month == date.month;
    });

    return payment?.amount;
  }

  // returns true if any payment has been made on the date
  static bool hasMadeAnyPayment(List<Reminder> reminders, DateTime date) {
    for (var reminder in reminders) {
      for (var payment in reminder.payments) {
        if (DateUtils.isSameDay(payment.date, date)) {
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
