import 'package:Acorn/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

enum AppStates { initial, inRoom }

// ignore: must_be_immutable
class CalendarController extends GetxController {
  // ignore: non_constant_identifier_names
  RxBool alreadyShownForThisSession_Shake = false.obs;

  final Rx<PageController> pageController =
      PageController(initialPage: DateTime.now().month - 1).obs;

  Rx<DateTime> currentDate = DateTime.now().obs;
  RxBool selectedcurrentyear = RxBool(false);

  bool isSelectedDayToday() {
    return DateUtils.isSameDay(currentDate.value, DateTime.now());
  }

  bool isWeekdayToday(int weekday) {
    return currentDate.value.weekday == weekday;
  }

  void goToNextMonth() {
    // Moves to the next page if it's not the last month of the year
    pageController.value.nextPage(
      duration: Duration(milliseconds: Constants.pageAnimations),
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
        duration: Duration(milliseconds: Constants.pageAnimations),
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
}
