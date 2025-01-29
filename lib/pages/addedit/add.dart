import 'package:Acorn/models/app_data_model.dart';
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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   CustomSnackbar()
    //       .simple("Leave price blank if price varies on a monthly basis.");
    // });
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

                      //? Search services
                      Obx(
                        () => CustomInputDropdown(
                          text: addController.selectedServiceName.value,
                          hintText: 'Search',
                          searchableData:
                              initialController.appData.value.services,
                          onTextChanged: (data) {
                            addController.selectedService.value =
                                data as Service;
                            addController.selectedServiceName.value =
                                data.name ?? '';
                            addController.selectedServiceName.refresh();
                            addController.selectedService.refresh();

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
                                  .isNotEmpty,
                          child: CustomInput(
                            text: addController.selectedPrice.value.toString(),
                            hintText: 'Price',
                            enabled: !addController.isFixedPricing.value,
                            onTextChanged: (data) {
                              addController.selectedPrice.value =
                                  double.tryParse(data as String) ?? 0.0;
                              addController.selectedPrice.refresh();
                            },
                          ),
                        ),
                      ),

                      Obx(
                        () => Visibility(
                          visible:
                              (addController.selectedServiceName.value ?? '')
                                  .isNotEmpty,
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
                              HorizSpace.eight(),
                              Expanded(
                                child: Custom.body1(
                                  "Price is fixed on a monthly basis.",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      VertSpace.thirty(),
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
