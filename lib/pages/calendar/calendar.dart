import 'package:Acorn/models/personal_data_model.dart';
import 'package:Acorn/pages/add/controllers/add_controller.dart';
import 'package:Acorn/pages/calendar/components/clickable_legends.dart';
import 'package:Acorn/pages/calendar/controllers/calendar_controller.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/currency.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/custom_dialog.dart';
import 'package:Acorn/widgets/custom_snackbar.dart';
import 'package:Acorn/widgets/icon_presenter.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shake_detector/shake_detector.dart';

enum CalendarState { monthly, oneTime }

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key, this.type = CalendarState.monthly});
  final CalendarState type;

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar>
    with SingleTickerProviderStateMixin {
  late ShakeDetector detector;
  final CalendarController calendarController = Get.put(CalendarController());
  final AddController addController = Get.put(AddController());
  final InitialController initialController = Get.find<InitialController>();

  //? FOR ANIMATIONS
  late Animation<double> animation;
  late AnimationController animationController;
  double scale = 1;
  double maxScale = 1.3;
  final duration = const Duration(milliseconds: 2000);
  final reverse = const Duration(milliseconds: 900);

  @override
  void initState() {
    detector = ShakeDetector.autoStart(onShake: () {
      debugPrint('SHAKE SHAKE SHAKE!!!');
    });

    detector.startListening();
    final scaleTween = Tween(begin: 1.0, end: maxScale);
    animationController = AnimationController(
        duration: duration, reverseDuration: reverse, vsync: this);
    animation = scaleTween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    )..addListener(() {
        setState(() => scale = animation.value);
      });
    super.initState();
  }

  void holdAnimation() {
    animation.addStatusListener((AnimationStatus status) {
      if (scale == maxScale) {
        EasyThrottle.throttle('throttler', const Duration(seconds: 2), () {
          debugPrint('SHOW DIALOG HERE');

          exitAnimation();
        });
      }
    });
    animationController.forward();
  }

  void exitAnimation() {
    // animation.addStatusListener((AnimationStatus status) {
    //   if (scale == maxScale) {
    //     animationController.reverse();
    //   }
    // });
    animationController.reverse();
  }

  @override
  void dispose() {
    detector.stopListening();
    calendarController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildHeader(),
            VertSpace.thirty(),
            AspectRatio(
              aspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 2),
              child: PageView.builder(
                pageSnapping: true,

                controller: calendarController.pageController.value,
                onPageChanged: (index) {
                  // +- a year
                  calendarController.currentDate.value = DateTime(
                      calendarController.currentDate.value.year, index + 1, 1);
                },
                itemCount: 12 * 1, // Show 1 years, adjust this count as needed
                itemBuilder: (context, pageIndex) {
                  DateTime month = DateTime(
                      calendarController.currentDate.value.year,
                      (pageIndex % 12) + 1,
                      1);

                  return buildCalendar(month);
                },
              ),
            ),
            const Visibility(visible: false, child: ClickableLegends())
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
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
              Currency.format(initialController.getTotal()),
              isBold: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildCalendar(DateTime month, {bool showPreviousMonthDays = false}) {
    // Calculating various details for the month's display
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth.weekday;

    DateTime lastDayOfPreviousMonth =
        firstDayOfMonth.subtract(const Duration(days: 1));
    // int daysInPreviousMonth = lastDayOfPreviousMonth.day;

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                      color: AppColors.darkGrayColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Obx(
                      () => Custom.body1(
                          calendarController.getWeekdayFromInt(index),
                          color: calendarController.isWeekdayToday(index += 1)
                              ? AppColors.whiteColor
                              : AppColors.whiteColor.withOpacity(0.5),
                          isBold: calendarController.isWeekdayToday(index += 1)
                              ? true
                              : false),
                    ),
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
              // int previousMonthDay =
              // daysInPreviousMonth - (weekdayOfFirstDay - index) + 2;
              return showPreviousMonthDays
                  ? Container(
                      decoration: BoxDecoration(
                          color: AppColors.darkGrayColor.withOpacity(0.5),
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

              List<SubscribedService>? allData =
                  initialController.personalData.value.subscribedServices;
              List<SubscribedService>? servicesSubscribedThisDay = allData
                  ?.where(
                    (e) => DateUtils.isSameDay(e.date, date),
                  )
                  .toList();

              debugPrint('Day $text: ${servicesSubscribedThisDay?.length}');
              return GestureDetector(
                  onTapDown: (v) {
                    calendarController.currentDate.value = DateTime(
                        calendarController.currentDate.value.year,
                        calendarController.currentDate.value.month,
                        int.tryParse(text) ?? 0);
                    calendarController.currentDate.refresh();
                    if (!calendarController.isSelectedDayToday() &&
                        !calendarController
                            .alreadyShownForThisSession_Shake.value) {
                      CustomSnackbar()
                          .simple("Shake your device to go back to today");
                      calendarController
                          .alreadyShownForThisSession_Shake.value = true;
                    }
                    debugPrint(
                        'Clicked $text day, value of current date is ${calendarController.currentDate.value}');
                  },
                  child: box(
                      servicesSubscribedThisDay: servicesSubscribedThisDay,
                      isSelected: isSelected,
                      deviceAspect: deviceAspect,
                      text: text));
            }
          },
        ),
      ],
    );
  }

  Widget box(
      {List<SubscribedService>? servicesSubscribedThisDay,
      bool isSelected = false,
      double deviceAspect = 16,
      String text = ''}) {
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

    return Transform.scale(
      scale: isSelected ? scale : 1,
      child: GestureDetector(
        onLongPressDown: (v) {
          holdAnimation();
        },
        onLongPressStart: (details) {
          CustomDialog.simple(title: '', body: '');
        },
        onLongPressEnd: (v) {
          exitAnimation();
        },
        onLongPressCancel: () {
          exitAnimation();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(
                      width: 2, color: AppColors.whiteColor.withOpacity(0.8))
                  : null,
              color: AppColors.darkGrayColor,
              borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.center,
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
                                      icon: servicesSubscribedThisDay
                                          .first.subscription?.icon,
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
                              icon: servicesSubscribedThisDay
                                  .first.subscription?.icon,
                              size: deviceAspect * 22,
                            )
                      : const SizedBox()),
              Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: true,
                  // visible: !isSelected,
                  child: Custom.body3(text,
                      color: AppColors.whiteColor.withOpacity(0.5),
                      isBold: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
