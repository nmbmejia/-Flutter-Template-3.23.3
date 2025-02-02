import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/pages/initial/auth/login.dart';
import 'package:Acorn/services/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

enum AppStates { initial, inRoom }

// ignore: must_be_immutable
class CalendarController extends GetxController {
  // ignore: non_constant_identifier_names
  final LoginController loginController = Get.put(LoginController());

  final Rx<PageController> pageController =
      PageController(initialPage: DateTime.now().month - 1).obs;

  Rx<DateTime> currentDate = DateTime.now().obs;
  RxBool selectedcurrentyear = RxBool(false);
  RxDouble totalMonthAmount = 0.0.obs;

  bool isSelectedDayToday() {
    return DateUtils.isSameDay(currentDate.value, DateTime.now());
  }

  bool isWeekdayToday(int weekday) {
    return currentDate.value.weekday == weekday;
  }

  void goToNextMonth() {
    // Moves to the next page if it's not the last month of the year
    pageController.value.nextPage(
      duration: Duration(milliseconds: Constants.appAnimations),
      curve: Curves.easeInOut,
    );
    currentDate.value = Jiffy.parseFromDateTime(currentDate.value)
        .subtract(months: 1)
        .dateTime; // March 1, 2021
  }

  void goToLastMonth() {
    // Moves to the next page if it's not the last month of the year
    // Moves to the previous page if the current page index is greater than 0
    if (pageController.value.page! > 0) {
      pageController.value.previousPage(
        duration: Duration(milliseconds: Constants.appAnimations),
        curve: Curves.easeInOut,
      );
    }
    currentDate.value = Jiffy.parseFromDateTime(currentDate.value)
        .subtract(months: 1)
        .dateTime; // March 1, 2021
  }

  String getWeekdayFromInt(int weekday) {
    switch (weekday) {
      case 0:
        return 'SUN';
      case 1:
        return 'MON';
      case 2:
        return 'TUE';
      case 3:
        return 'WED';
      case 4:
        return 'THU';
      case 5:
        return 'FRI';
      case 6:
        return 'SAT';
      default:
        return 'NAN';
    }
  }

  Stream<List<Reminder>> getRemindersForDate(DateTime date) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(loginController.loggedUserDetails?.email)
        .collection('reminders')
        .snapshots()
        .map((snapshot) {
      List<Reminder> reminders = snapshot.docs
          .map((doc) => Reminder.fromFirestore(doc))
          .where((reminder) {
        // Convert both dates to date-only for comparison (no time component)
        DateTime targetDate = DateUtils.dateOnly(date);
        DateTime reminderStart = DateUtils.dateOnly(reminder.startDate);
        DateTime? reminderEnd = reminder.endDate != null
            ? DateUtils.dateOnly(reminder.endDate!)
            : null;

        // Check if the target date is within the reminder's date range
        if (reminderEnd != null && targetDate.isAfter(reminderEnd)) {
          return false;
        }
        if (targetDate.isBefore(reminderStart)) {
          return false;
        }

        // Handle different recurrence patterns
        switch (reminder.recurrence) {
          case ReminderRecurrence.once:
            return targetDate.isAtSameMomentAs(reminderStart);

          case ReminderRecurrence.daily:
            return true;

          case ReminderRecurrence.weekly:
            return targetDate.weekday == reminderStart.weekday;

          case ReminderRecurrence.monthly:
            return targetDate.day == reminder.dueDay;

          case ReminderRecurrence.yearly:
            return targetDate.month == reminderStart.month &&
                targetDate.day == reminderStart.day;
        }
      }).toList();

      return reminders;
    });
  }
}
