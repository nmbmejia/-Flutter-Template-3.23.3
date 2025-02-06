import 'dart:async';

import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/pages/addedit/controllers/add_controller.dart';
import 'package:Acorn/pages/calendar/controllers/calendar_controller.dart';
import 'package:Acorn/pages/calendar/controllers/calendar_widgets.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shake_detector/shake_detector.dart';

enum CalendarState { monthly, oneTime }

/*
  *     allReminders - comes from Firebase, all reminders for the user
  *     monthReminders (non-exhaustive, meaning only shows recurring) - comes from CustomFunctions.getRemindersForMonth, reminders for the current month
  *     dayReminders (non-exhaustive, meaning only shows recurring) - comes from CustomFunctions.getRemindersForDay, reminders for the current day
  *
  *
  *
  *
  *
  *
  *
*/

class CustomCalendar extends StatefulWidget {
  const CustomCalendar(
      {super.key,
      this.type = CalendarState.monthly,
      this.allReminders = const [],
      this.monthReminders = const []});
  final CalendarState type;
  final List<Reminder> allReminders;
  final List<Reminder> monthReminders;

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar>
    with SingleTickerProviderStateMixin {
  late ShakeDetector detector;
  final AddController addController = Get.put(AddController());
  final InitialController initialController = Get.find<InitialController>();
  final CalendarController calendarController = Get.find<CalendarController>();

  //? FOR ANIMATIONS
  Timer? holdTimer;
  late Animation<double> animation;
  late AnimationController animationController;
  double offset = 0;
  double maxOffset = 2.0;
  final duration = const Duration(milliseconds: 300);
  final reverse = const Duration(milliseconds: 300);

  @override
  void initState() {
    detector = ShakeDetector.autoStart(onShake: () {
      debugPrint('SHAKE SHAKE SHAKE!!!');
    });

    detector.startListening();
    final offsetTween = Tween(begin: 0.0, end: maxOffset);
    animationController = AnimationController(
        duration: duration, reverseDuration: reverse, vsync: this);
    animation = offsetTween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() => offset = animation.value);
      });
    super.initState();
  }

  void holdAnimation() {
    animation.addStatusListener((AnimationStatus status) {
      if (offset == maxOffset) {
        EasyThrottle.throttle('throttler', const Duration(seconds: 2), () {
          debugPrint('SHOW DIALOG HERE');
          exitAnimation();
        });
      }
    });
    animationController.forward();
  }

  void exitAnimation() {
    animationController.reverse();
  }

  @override
  void dispose() {
    detector.stopListening();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildHeader(widget.monthReminders),
          VertSpace.thirty(),
          AspectRatio(
              aspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 2),
              child: PageView.builder(
                pageSnapping: true,
                controller: calendarController.pageController.value,
                onPageChanged: (index) {
                  // Calculate the current date based on the page index
                  calendarController.currentDate.value = DateTime(
                    DateTime.now().year +
                        (index ~/ 12), // Increment year correctly
                    (index % 12) + 1, // Get the correct month
                    1,
                  );
                },
                itemCount: 12 * 2, // Show 2 years (24 months)
                itemBuilder: (context, pageIndex) {
                  // Calculate the correct month and year for each page
                  DateTime month = DateTime(
                    DateTime.now().year +
                        (pageIndex ~/ 12), // Calculate the correct year
                    (pageIndex % 12) + 1, // Calculate the correct month
                    1,
                  );

                  return buildCalendar(context, month, widget.allReminders,
                      widget.monthReminders,
                      animation: animation,
                      holdAnimation: holdAnimation,
                      exitAnimation: exitAnimation,
                      showPreviousMonthDays: true);
                },
              )),
          // const Visibility(visible: false, child: ClickableLegends())
        ],
      ),
    );
  }
}
