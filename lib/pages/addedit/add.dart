import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/pages/addedit/controllers/add_controller.dart';
import 'package:Acorn/pages/calendar/controllers/calendar_controller.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/custom_input.dart';
import 'package:Acorn/widgets/custom_input_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  static const List<String> addTypes = ['SUBSCRIPTION', 'PAYMENT'];

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final CalendarController calendarController = Get.find<CalendarController>();
  final InitialController initialController = Get.find<InitialController>();
  final AddController addController = Get.find<AddController>();

  @override
  void initState() {
    debugPrint(initialController.appData.value.services?.length.toString());

    addController.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Custom.header2(
                              DateFormat('MMMM d, y')
                                  .format(calendarController.currentDate.value),
                              color: AppColors.whiteColor,
                              isBold: true),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.lightGrayColor,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.close,
                                  size: 30,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      VertSpace.fifteen(),
                      VertSpace.thirty(),

                      //? Recurrence
                      Obx(
                        () => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ToggleButtons(
                            direction: Axis.horizontal,
                            onPressed: (int index) {
                              addController.selectedRecurrence.value =
                                  ReminderRecurrence.values[index];
                            },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            selectedBorderColor: AppColors.whiteSecondaryColor,
                            selectedColor: Colors.black87,
                            fillColor: AppColors.whiteSecondaryColor,
                            color: AppColors.whiteSecondaryColor,
                            constraints: const BoxConstraints(
                              minHeight: 30.0,
                              minWidth: 100.0,
                            ),
                            isSelected: ReminderRecurrence.values
                                .map((recurrence) =>
                                    recurrence ==
                                    addController.selectedRecurrence.value)
                                .toList(),
                            children: ReminderRecurrence.values
                                .map((recurrence) => Text(recurrence
                                    .toString()
                                    .split('.')
                                    .last
                                    .capitalize!))
                                .toList(),
                          ),
                        ),
                      ),
                      VertSpace.five(),

                      //? Search services
                      Obx(
                        () => CustomInputDropdown(
                          text: addController.selectedServiceName.value,
                          hintText: 'Search',
                          searchableData:
                              initialController.appData.value.services,
                          onTextChanged: (data) {
                            addController.selectedServiceName.value =
                                data.name ?? '';
                            addController.selectedServiceName.refresh();

                            //Reset
                            addController.resetAll();
                          },
                        ),
                      ),
                      VertSpace.five(),
                      Obx(
                        () => Visibility(
                          visible:
                              (addController.selectedServiceName.value ?? '')
                                      .isNotEmpty &&
                                  addController.selectedRecurrence.value !=
                                      ReminderRecurrence.once,
                          child: CustomInput(
                            text: addController.selectedAmount.value.toString(),
                            hintText: 'Price',
                            enabled: addController.isFixedPricing.value,
                            onTextChanged: (data) {
                              addController.selectedAmount.value =
                                  double.tryParse(data as String) ?? 0.0;
                              addController.selectedAmount.refresh();
                            },
                          ),
                        ),
                      ),

                      Obx(
                        () => Visibility(
                          visible:
                              (addController.selectedServiceName.value ?? '')
                                      .isNotEmpty &&
                                  addController.selectedRecurrence.value !=
                                      ReminderRecurrence.once,
                          child: Row(
                            children: [
                              Checkbox(
                                value: addController.isFixedPricing.value,
                                onChanged: (bool? newValue) {
                                  addController.isFixedPricing.value =
                                      newValue ?? true;
                                },
                                activeColor: AppColors
                                    .primaryColor, // Adjust to match your theme
                                checkColor: AppColors
                                    .whiteColor, // Customize the check mark color
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    addController.isFixedPricing.value =
                                        !addController.isFixedPricing.value;
                                  },
                                  child: Custom.body1(
                                    "The amount ${addController.isFixedPricing.value ? 'is fixed' : 'varies'} on ${addController.selectedRecurrence.value == ReminderRecurrence.daily ? 'a daily' : addController.selectedRecurrence.value == ReminderRecurrence.weekly ? 'a weekly' : addController.selectedRecurrence.value == ReminderRecurrence.monthly ? 'a monthly' : addController.selectedRecurrence.value == ReminderRecurrence.yearly ? 'a yearly' : 'a monthly'} basis.",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      VertSpace.five(),

                      VertSpace.fifteen(),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            addController.addNew();
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.lightGrayColor,
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.add,
                                size: 30,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ))));
  }
}
