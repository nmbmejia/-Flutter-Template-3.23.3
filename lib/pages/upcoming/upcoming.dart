import 'package:Acorn/models/consolidated_reminder_model.dart';
import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/pages/home/controllers/homepage_controller.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/custom_functions.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/animated_fade_in.dart';
import 'package:Acorn/widgets/icon_presenter.dart';
import 'package:Acorn/widgets/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpcomingReminders extends StatefulWidget {
  final List<Reminder> allReminders;
  final List<Reminder> monthReminders;
  const UpcomingReminders(
      {super.key, required this.allReminders, required this.monthReminders});

  @override
  State<UpcomingReminders> createState() => _UpcomingRemindersState();
}

class _UpcomingRemindersState extends State<UpcomingReminders> {
  HomePageController homePageController = Get.find<HomePageController>();
  RxBool showUpcomingOnly = true.obs;
  RxList filteredReminders = [].obs;

  @override
  void initState() {
    super.initState();

    filterReminders(0);
  }

  void filterReminders(int index) {
    if (index == 0) {
      // Get all reminders due in the next 14 days
      filteredReminders.value = widget.monthReminders.where((reminder) {
        final now = DateTime.now();
        final dueDate = DateTime(now.year, now.month, reminder.dueDay);

        // Adjust due date if it's already passed this month
        final adjustedDueDate = dueDate.isBefore(now)
            ? DateTime(now.year, now.month + 1, reminder.dueDay)
            : dueDate;

        // Check if due date is within next 14 days
        return adjustedDueDate.difference(now).inDays <= 14 &&
            adjustedDueDate.difference(now).inDays >= 0;
      }).toList();
    } else {
      filteredReminders.value = widget.monthReminders;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300,
        child: Column(
          children: [
            // Add toggle buttons
            Obx(() => Stack(
                  children: [
                    ToggleButtons(
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        showUpcomingOnly.value = index == 0;
                        filterReminders(index);
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      selectedBorderColor: AppColors.whiteSecondaryColor,
                      selectedColor: Colors.black87,
                      fillColor: AppColors.whiteSecondaryColor,
                      color: AppColors.whiteSecondaryColor,
                      constraints: const BoxConstraints(
                        minHeight: 35.0,
                        minWidth: 100.0,
                      ),
                      isSelected: [
                        showUpcomingOnly.value,
                        !showUpcomingOnly.value
                      ],
                      children: [
                        Custom.body1('Upcoming',
                            color: showUpcomingOnly.value
                                ? AppColors.primaryColor
                                : AppColors.whiteSecondaryColor),
                        Custom.body1('All',
                            color: !showUpcomingOnly.value
                                ? AppColors.primaryColor
                                : AppColors.whiteSecondaryColor),
                      ],
                    ),
                  ],
                )),
            VertSpace.ten(),
            Obx(
              () => filteredReminders.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Custom.body2(
                            showUpcomingOnly.value
                                ? 'No upcoming payments'
                                : 'No payments due this month',
                            color: Colors.grey),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Obx(
                                () => Custom.body2(
                                    showUpcomingOnly.value
                                        ? 'Payments due soon'
                                        : 'Payments due this ${DateFormat('MMMM').format(DateTime.now())}',
                                    color: Colors.grey),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey)),
                          ],
                        ),
                        VertSpace.ten(),
                        Obx(
                          () => ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredReminders.length,
                            itemBuilder: (context, index) {
                              Reminder reminder = filteredReminders[index];
                              DateTime now = DateTime.now();
                              DateTime dueDate = DateTime(
                                  now.year, now.month, reminder.dueDay);

                              // if (dueDate.isBefore(now)) {
                              //   dueDate = DateTime(
                              //       now.year, now.month + 1, reminder.dueDay);
                              // }
                              // debugPrint(
                              // '${filteredReminders[index].title} is due on ${dueDate}');

                              return AnimatedFadeInItem(
                                index: index,
                                delayInMs: 100,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    margin: const EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppColors.darkGrayColor),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconPresenter(
                                                icon: CustomFunctions
                                                    .getIconForReminder(
                                                        reminder),
                                                size: 28,
                                              ),
                                              HorizSpace.ten(),
                                              Flexible(
                                                child: Custom.subheader2(
                                                    reminder.title,
                                                    isBold: true),
                                              ),
                                              HorizSpace.ten(),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Visibility(
                                              visible: reminder.isFixed,
                                              child: Custom.subheader1(
                                                  Constants.currency +
                                                      (reminder.amount ?? 0.0)
                                                          .toMonetaryFormat(),
                                                  // Constants.currency +
                                                  //     ((reminder.amount ?? 0.0)
                                                  //         .toMonetaryFormat()),
                                                  isBold: true,
                                                  color: AppColors.greenColor),
                                            ),
                                            showUpcomingOnly.value
                                                ? Custom.body1(
                                                    daysBetween(DateTime.now(),
                                                                dueDate) ==
                                                            0
                                                        ? 'Today'
                                                        : daysBetween(
                                                                    DateTime
                                                                        .now(),
                                                                    dueDate) ==
                                                                1
                                                            ? 'Tomorrow'
                                                            : 'in ${daysBetween(DateTime.now(), dueDate)} days',
                                                    isBold: true,
                                                    color: AppColors
                                                        .whiteSecondaryColor)
                                                : Custom.body1(
                                                    DateFormat('MMM d')
                                                        .format(dueDate),
                                                    isBold: true,
                                                    color: AppColors
                                                        .whiteSecondaryColor),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  // https://stackoverflow.com/questions/52713115/flutter-find-the-number-of-days-between-two-dates
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
