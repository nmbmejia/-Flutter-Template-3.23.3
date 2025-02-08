import 'dart:async';
import 'dart:math';

import 'package:Acorn/models/consolidated_reminder_model.dart';
import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/pages/calendar/controllers/calendar_controller.dart';
import 'package:Acorn/pages/home/controllers/homepage_controller.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/currency.dart';
import 'package:Acorn/services/custom_functions.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/animated_fade_in.dart';
import 'package:Acorn/widgets/dialogs/custom.dart';
import 'package:Acorn/widgets/icon_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final CalendarController calendarController = Get.find<CalendarController>();

Widget buildHeader(List<Reminder> monthReminders) {
  double total = 0;

  // Get total from monthly reminders
  for (Reminder reminder in monthReminders) {
    total += reminder.amount ?? 0;
  }

  // Add payments made this month
  total += calendarController.totalMonthAmount.value;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Stack(
        children: [
          Custom.header3(
              '${DateFormat('MMMM').format(calendarController.currentDate.value)}, ${DateFormat('yyyy').format(calendarController.currentDate.value)}',
              isBold: true),
          Custom.header3(
              color: Colors.transparent,
              '${DateFormat('MMMM').format(calendarController.currentDate.value)}, ${DateFormat('yyyy').format(calendarController.currentDate.value)}',
              isBold: true),
        ],
      ),
      Row(
        children: [
          Custom.subheader1('Total: ',
              color: AppColors.lightGrayColor, isBold: true),
          Custom.subheader1(
            Currency.format(total),
            isBold: true,
          ),
        ],
      ),
    ],
  );
}

Widget buildCalendar(
  BuildContext context,
  DateTime month, {
  bool showPreviousMonthDays = false,
  required Animation<double> animation,
  Timer? holdTimer,
  required Function() holdAnimation,
  required Function() exitAnimation,
}) {
  int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
  int weekdayOfFirstDay = firstDayOfMonth.weekday;

  double deviceAspect = MediaQuery.of(context).size.width /
      (MediaQuery.of(context).size.height / 2.2);

  return Column(
    children: [
      GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 2.0,
            childAspectRatio: 2,
          ),
          // Calculating the total number of cells required in the grid
          itemCount: 7,
          itemBuilder: (context, index) {
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                decoration: BoxDecoration(
                    color: AppColors.darkGrayColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Custom.body1(
                      calendarController.getWeekdayFromInt(index),
                      color: calendarController.isWeekdayToday(index += 1)
                          ? AppColors.whiteColor
                          : AppColors.whiteColor.withOpacity(0.5),
                      isBold: calendarController.isWeekdayToday(index += 1)
                          ? true
                          : false),
                ));
          }),
      VertSpace.eight(),
      GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: deviceAspect,
        ),
        // Calculating the total number of cells required in the grid
        itemCount: daysInMonth + weekdayOfFirstDay - 1,
        itemBuilder: (context, index) {
          if (index < weekdayOfFirstDay - 1) {
            // Displaying dates from the previous month in grey
            return showPreviousMonthDays
                ? Container(
                    decoration: BoxDecoration(
                        color: AppColors.darkGrayColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10)),
                  )
                : const SizedBox();
          } else {
            // Displaying the current month's days
            DateTime date = DateTime(
                month.year, month.month, index - weekdayOfFirstDay + 2);
            String text = date.day.toString();
            bool isSelected =
                text == calendarController.currentDate.value.day.toString();

            // --------------------------- Filter reminders for this specific day based on due day and recurrence
            //* Non-exhaustive, only shows recurring reminders, that's why you pass all the original Reminders (allReminders) and not monthReminders variable.
            HomePageController homePageController =
                Get.find<HomePageController>();
            List<Reminder> remindersForDay = CustomFunctions.getRemindersForDay(
                homePageController.allReminders, date);

            return AnimatedFadeInItem(
              index: index,
              delayInMs: 10,
              child: GestureDetector(
                  onTapDown: (v) {
                    calendarController.currentDate.value = DateTime(
                        calendarController.currentDate.value.year,
                        calendarController.currentDate.value.month,
                        int.tryParse(text) ?? 0);
                    calendarController.currentDate.refresh();

                    debugPrint(
                        'Clicked $text day, value of current date is ${calendarController.currentDate.value}');
                  },
                  child: dayBox(
                      // boxDate: calendarController.currentDate.value,
                      boxDate: date,
                      servicesSubscribedThisDay: remindersForDay,
                      isSelected: isSelected,
                      deviceAspect: deviceAspect,
                      text: text,
                      animation: animation,
                      holdTimer: holdTimer,
                      holdAnimation: holdAnimation,
                      exitAnimation: exitAnimation)),
            );
          }
        },
      )
    ],
  );
}

Widget dayBox({
  required DateTime boxDate,
  List<Reminder>? servicesSubscribedThisDay,
  bool isSelected = false,
  double deviceAspect = 16,
  String text = '',
  required Animation<double> animation,
  Timer? holdTimer,
  required Function() holdAnimation,
  required Function() exitAnimation,
}) {
  bool isBoxDateTodaysDate = DateUtils.isSameDay(boxDate, Constants.dateToday);
  bool hasData = servicesSubscribedThisDay == null
      ? false
      : servicesSubscribedThisDay.isEmpty
          ? false
          : true;
  int servicesCount = servicesSubscribedThisDay == null
      ? 0
      : servicesSubscribedThisDay.isEmpty
          ? 0
          : servicesSubscribedThisDay.length;

  return Transform(
    transform: isSelected
        ? (Matrix4.identity()
          ..rotateZ(sin(animation.value * pi) * 0.03)
          ..translate(0.0, sin(animation.value * pi * 2) * 1.5))
        : Matrix4.identity(),
    child: GestureDetector(
      onLongPressDown: (details) {
        if (isSelected) {
          holdAnimation();
          holdTimer = Timer(const Duration(milliseconds: 250), () {
            CustomDialog.showServices(boxDate, servicesSubscribedThisDay ?? [],
                total: CustomFunctions.getTotalAmountForSubscriptions(
                    servicesSubscribedThisDay ?? []));
            exitAnimation();
          });
        }
      },
      onLongPressEnd: (_) {
        if (isSelected) {
          holdTimer?.cancel();
          exitAnimation();
        }
      },
      onLongPressCancel: () {
        if (isSelected) {
          holdTimer?.cancel();
          exitAnimation();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
            border: isSelected
                ? Border.all(
                    width: 2, color: AppColors.whiteColor.withOpacity(0.8))
                : isBoxDateTodaysDate
                    ? Border.all(
                        width: 1, color: Colors.blueAccent.withOpacity(0.5))
                    : null,
            color: AppColors.darkGrayColor,
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: hasData
                      //? IF MORE THAN ONE
                      ? servicesCount > 1
                          ? Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    child: IconPresenter(
                                      icon: CustomFunctions.getIconForReminder(
                                          servicesSubscribedThisDay.first),
                                      size: deviceAspect * 24,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 12),
                                    height: deviceAspect * 26,
                                    width: deviceAspect * 26,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 2,
                                            color: AppColors.darkGrayColor),
                                        color: AppColors.whiteTertiaryColor),
                                    child: Center(
                                      child: Custom.body2(
                                          '+${servicesCount - 1}',
                                          color: AppColors.whiteColor,
                                          isBold: true),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          //? IF JUST ONE
                          : IconPresenter(
                              icon: CustomFunctions.getIconForReminder(
                                  servicesSubscribedThisDay.first),
                              size: deviceAspect * 22,
                            )
                      : const SizedBox(),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible: true,
                child: Custom.body3(text,
                    color: isBoxDateTodaysDate
                        ? AppColors.whiteColor
                        : AppColors.whiteColor.withOpacity(0.4),
                    isBold: true),
              ),
            ),
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Visibility(
            //       visible: !CustomFunctions.hasMadeAnyPayment(
            //               servicesSubscribedThisDay ?? [], boxDate) &&
            //           (servicesSubscribedThisDay ?? []).isNotEmpty,
            //       child: Container(
            //         width: 7,
            //         height: 7,
            //         decoration: const BoxDecoration(
            //             shape: BoxShape.circle, color: Colors.red),
            //       )),
            // ),
          ],
        ),
      ),
    ),
  );
}
