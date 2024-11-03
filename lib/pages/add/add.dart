import 'package:Acorn/models/app_data_model.dart';
import 'package:Acorn/pages/add/controllers/add_controller.dart';
import 'package:Acorn/pages/calendar/controllers/calendar_controller.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/services/strings.dart';
import 'package:Acorn/widgets/custom_input.dart';
import 'package:Acorn/widgets/icon_presenter.dart';
import 'package:Acorn/widgets/informational.dart';
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
                              Get.back();
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
                        () => CustomInput(
                          text: addController.selectedServiceName.value ?? '',
                          hintText: 'Search',
                          isSearchable: true,
                          searchableData:
                              initialController.appData.value.services,
                          prefixIcon: IconPresenter(
                              icon: addController.selectedService.value?.icon),
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

                      //? Search plans
                      Obx(() {
                        return Visibility(
                          visible:
                              addController.selectedServiceName.value != null &&
                                  addController.selectedServiceHasPlans,
                          child: CustomInput(
                            text: addController.selectedPlanName.value ?? '',
                            hintText: 'Select Plan',
                            isSearchable: true,
                            searchableData:
                                addController.selectedService.value?.plans,
                            prefixIcon: const IconPresenter(icon: null),
                            onTextChanged: (data) {
                              addController.selectedPlanName.value =
                                  (data as Plan).name;
                              addController.selectedPlanName.refresh();
                              addController.selectedPrice.value =
                                  (data).price ?? 0.0;
                              addController.selectedPrice.refresh();
                            },
                          ),
                        );
                      }),

                      //? Search periods
                      Obx(
                        () => Visibility(
                          visible: addController.selectedServiceHasPlans
                              ? addController.selectedPlanName.value != null
                                  ? true
                                  : false
                              : addController.selectedServiceName.value != null,
                          child: CustomInput(
                            text: addController.selectedPeriodName.value ?? '',
                            isSearchable: true,
                            searchableData:
                                initialController.appData.value.periods,
                            prefixIcon: const IconPresenter(icon: null),
                            hintText: 'Frequency',
                            onTextChanged: (data) {
                              addController.selectedPeriodName.value =
                                  (data as Period).name;
                              addController.selectedPeriodName.refresh();
                            },
                          ),
                        ),
                      ),

                      //? Input price
                      Obx(
                        () => Visibility(
                          visible:
                              addController.selectedPeriodName.value != null,
                          child: CustomInput(
                            text: addController.selectedPrice.value
                                .toStringAsFixed(2),
                            hintText: addController.selectedPrice.value
                                .toStringAsFixed(2),
                            prefixIcon: Custom.header3(Constants.currency,
                                color: AppColors.whiteColor.withOpacity(0.5)),
                            isTextField: true,
                            onTextChanged: (data) {
                              addController.selectedPrice.value =
                                  double.tryParse(data) ?? 0.0;
                              addController.selectedPrice.refresh();
                            },
                          ),
                        ),
                      ),

                      // CHECKBOX if price is fixed
                      Obx(
                        () => Visibility(
                          visible:
                              addController.selectedPeriodName.value != null &&
                                  addController.selectedPeriodName.value !=
                                      Strings.oneTime,
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
                                  "Price is fixed ${(addController.selectedPeriodName.value ?? '').toLowerCase()}",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Card or cash
                      // Obx(
                      //   () => Visibility(
                      //     visible: addController.selectedPrice.value != 0 &&
                      //         addController.selectedPrice.value != 0.0 &&
                      //         addController.selectedPeriod.value?.name != null,
                      //     child: CustomInput(
                      //       prefixIcon: Icon(Icons.credit_card_outlined,
                      //           color: AppColors.whiteColor.withOpacity(0.5)),
                      //       text: addController.selectedPaymentMethod.value,
                      //       hintText: 'Card or Cash',
                      //       isTextField: true,
                      //       onTextChanged: (data) {
                      //         addController.selectedPaymentMethod.value = data;
                      //         addController.selectedPaymentMethod.refresh();
                      //       },
                      //     ),
                      //   ),
                      // ),
                      VertSpace.thirty(),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            addController.addNew();
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.lightGrayColor,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add_outlined,
                                size: 40,
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
