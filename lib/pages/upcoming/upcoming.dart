import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/pages/addedit/edit.dart';
import 'package:Acorn/pages/home/controllers/homepage_controller.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/custom_functions.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/go.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/animated_fade_in.dart';
import 'package:Acorn/widgets/dialogs/custom.dart';
import 'package:Acorn/widgets/icon_presenter.dart';
import 'package:Acorn/widgets/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpcomingReminders extends StatefulWidget {
  const UpcomingReminders({super.key});

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
    // Initial filter
    filterReminders(0);

    // Add listeners to update filtered reminders when source lists change
    ever(homePageController.monthReminders, (_) {
      if (showUpcomingOnly.value) {
        filterReminders(0);
      }
    });

    ever(homePageController.allReminders, (_) {
      if (!showUpcomingOnly.value) {
        filterReminders(1);
      }
    });
  }

  void filterReminders(int index) {
    if (index == 0) {
      // Get all reminders due in the next 14 days
      filteredReminders.value =
          homePageController.monthReminders.where((reminder) {
        final now = Constants.dateToday;
        final dueDate = DateTime(now.year, now.month, reminder.dueDay);

        // Adjust due date if it's already passed this month
        // final adjustedDueDate = dueDate.isBefore(now)
        //     ? DateTime(now.year, now.month + 1, reminder.dueDay)
        //     : dueDate;
        final adjustedDueDate = dueDate;

        // Check if due date is within next 14 days
        return adjustedDueDate.difference(now).inDays <= 14 &&
            adjustedDueDate.difference(now).inDays >= 0;
      }).toList();
    } else {
      filteredReminders.value = homePageController.allReminders;
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
                                        ? 'Payments due in two weeks'
                                        : 'Payments due this ${DateFormat('MMMM').format(Constants.dateToday)}',
                                    color: Colors.grey),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey)),
                          ],
                        ),
                        VertSpace.ten(),
                        Obx(
                          () {
                            var reminders =
                                List<Reminder>.from(filteredReminders);
                            if (!showUpcomingOnly.value) {
                              reminders.sort((a, b) {
                                DateTime dateA = DateTime(
                                    Constants.dateToday.year,
                                    Constants.dateToday.month,
                                    a.dueDay);
                                DateTime dateB = DateTime(
                                    Constants.dateToday.year,
                                    Constants.dateToday.month,
                                    b.dueDay);
                                return dateA.compareTo(dateB);
                              });
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: reminders.length,
                              itemBuilder: (context, index) {
                                Reminder reminder = reminders[index];
                                DateTime now = Constants.dateToday;
                                DateTime dueDate = DateTime(
                                    now.year, now.month, reminder.dueDay);

                                bool hasPaymentBeenMade =
                                    CustomFunctions.hasPaymentBeenMade(
                                        reminder, Constants.dateToday);
                                // Payment amount returns null if no payment has been made
                                double? paymentAmount =
                                    CustomFunctions.howMuchPaymentBeenMade(
                                        reminder, Constants.dateToday);

                                return AnimatedFadeInItem(
                                  index: index,
                                  delayInMs: 100,
                                  child: GestureDetector(
                                    onTap: () {
                                      Go.to(Edit(
                                        id: reminder.id,
                                        boxDate: DateTime(now.year, now.month,
                                            reminder.dueDay),
                                        reminder: reminder,
                                        hasPaymentBeenMade: hasPaymentBeenMade,
                                        paymentAmount: paymentAmount,
                                      ));
                                    },
                                    child: Opacity(
                                      opacity: hasPaymentBeenMade ? 0.3 : 1,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                                hasPaymentBeenMade
                                                    ? Custom.subheader1(
                                                        Constants.currency +
                                                            (paymentAmount ??
                                                                    0.0)
                                                                .toMonetaryFormat(),
                                                        isBold: true,
                                                        color: AppColors
                                                            .greenColor)
                                                    : reminder.isFixed
                                                        ? Custom.subheader1(
                                                            Constants.currency +
                                                                (reminder.amount ??
                                                                        0.0)
                                                                    .toMonetaryFormat(),
                                                            isBold: true,
                                                            color: AppColors
                                                                .greenColor)
                                                        : const SizedBox(),
                                                showUpcomingOnly.value
                                                    ? Custom.body2(
                                                        daysBetween(
                                                                    DateTime
                                                                        .now(),
                                                                    dueDate) ==
                                                                0
                                                            ? 'Today'
                                                            : daysBetween(
                                                                        Constants
                                                                            .dateToday,
                                                                        dueDate) ==
                                                                    1
                                                                ? 'Tomorrow'
                                                                : 'in ${daysBetween(Constants.dateToday, dueDate)} days',
                                                        isBold: true,
                                                        color: AppColors
                                                            .whiteSecondaryColor)
                                                    : Custom.body2(
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
                                  ),
                                );
                              },
                            );
                          },
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
