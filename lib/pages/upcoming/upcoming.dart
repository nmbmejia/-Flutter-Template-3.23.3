import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/custom_functions.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/animated_fade_in.dart';
import 'package:Acorn/widgets/icon_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class UpcomingReminders extends StatefulWidget {
  final List<Reminder> allReminders;
  const UpcomingReminders({super.key, required this.allReminders});

  @override
  State<UpcomingReminders> createState() => _UpcomingRemindersState();
}

class _UpcomingRemindersState extends State<UpcomingReminders> {
  RxBool showUpcomingOnly = true.obs;
  RxList filteredReminders = [].obs;

  @override
  void initState() {
    super.initState();
    filterReminders(0);
  }

  void filterReminders(int index) {
    if (index == 0) {
      final now = DateTime.now();
      final fourteenDaysFromNow = now.add(const Duration(days: 20));

      // Get all reminders due in the next 14 days
      filteredReminders.value = widget.allReminders.where((reminder) {
        // Get all instances of this reminder in the next 14 days
        List<DateTime> dates = [];
        for (var date = now;
            date.isBefore(fourteenDaysFromNow);
            date = date.add(const Duration(days: 1))) {
          if (CustomFunctions.getRemindersForDay([reminder], date).isNotEmpty) {
            dates.add(date);
          }
        }

        return dates.isNotEmpty;
      }).toList();
      debugPrint('Upcoming reminders: ${filteredReminders.length}');
    } else {
      filteredReminders.value = widget.allReminders;
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
            Obx(() => ToggleButtons(
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
                  isSelected: [showUpcomingOnly.value, !showUpcomingOnly.value],
                  children: const [
                    Text('Upcoming'),
                    Text('All'),
                  ],
                )),
            VertSpace.ten(),
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredReminders.length,
                itemBuilder: (context, index) {
                  final reminder = filteredReminders[index];
                  DateTime now = DateTime.now();
                  DateTime dueDate =
                      DateTime(now.year, now.month, reminder.dueDay ?? 1);

                  if (dueDate.isBefore(now)) {
                    dueDate =
                        DateTime(now.year, now.month + 1, reminder.dueDay ?? 1);
                  }

                  return AnimatedFadeInItem(
                    index: index,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconPresenter(
                                    icon: CustomFunctions.getIconForReminder(
                                        reminder),
                                    size: 28,
                                  ),
                                  HorizSpace.ten(),
                                  Flexible(
                                    child: Custom.subheader2(
                                        reminder.title ?? 'Payment',
                                        isBold: true),
                                  ),
                                  HorizSpace.ten(),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Custom.subheader1(reminder.amount.toString(),
                                    // Constants.currency +
                                    //     ((reminder.amount ?? 0.0)
                                    //         .toMonetaryFormat()),
                                    isBold: true,
                                    color: AppColors.redColor),
                                Custom.body2(timeago.format(dueDate),
                                    isBold: true,
                                    color: AppColors.whiteSecondaryColor),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
