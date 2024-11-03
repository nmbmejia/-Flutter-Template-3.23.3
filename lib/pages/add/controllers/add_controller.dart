import 'package:Acorn/models/app_data_model.dart';
import 'package:Acorn/models/personal_data_model.dart';
import 'package:Acorn/pages/calendar/controllers/calendar_controller.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AddController extends GetxController {
  // Input fields;
  Rxn<Service> selectedService = Rxn<Service>(null);
  RxnString selectedServiceName = RxnString(null);
  RxnString selectedPlanName = RxnString(null);
  RxnString selectedPeriodName = RxnString(null);
  RxBool isFixedPricing = RxBool(true);
  RxDouble selectedPrice = 0.0.obs;
  RxString selectedPaymentMethod = ''.obs;

  bool get selectedServiceHasPlans =>
      selectedService.value?.plans?.isNotEmpty ?? false;

  void init() {
    selectedServiceName.value = null;
    resetAll();
  }

  void resetAll() {
    selectedPlanName.value = null;
    selectedPeriodName.value = null;
    selectedPrice.value = 0.0;
    isFixedPricing.value = false;
    selectedPaymentMethod.value = '';
    selectedPlanName.refresh();
    selectedPeriodName.refresh();
    selectedPrice.refresh();
    selectedPaymentMethod.refresh();
  }

  void addNew() {
    if (selectedServiceName.value == null) {
      CustomSnackbar().simple("Please select a service.");
      return;
    }
    if (selectedServiceHasPlans && selectedPlanName.value == null) {
      CustomSnackbar().simple("Please select a plan.");
      return;
    }
    if (selectedPeriodName.value == null) {
      CustomSnackbar().simple("Please select a period.");
      return;
    }

    // if (selectedPaymentMethod.value.isEmpty) {
    //   CustomSnackbar().simple("Please add a payment method.");
    //   return;
    // }
    if (selectedPrice.value < 0) {
      CustomSnackbar().simple("Price cannot be lower than 0.");
      return;
    }

    // if (validatePaymentMethod(selectedPaymentMethod.value)) {
    //   CustomSnackbar()
    //       .simple("Payment method should be Cash or last 4 digits of card");
    //   return;
    // }

    final InitialController initialController = Get.find<InitialController>();
    final CalendarController calendarController =
        Get.find<CalendarController>();
    initialController.personalData.value.subscribedServices
        ?.add(SubscribedService(
      subscription: selectedService.value,
      date: calendarController.currentDate.value,
      updatedDate: DateTime.now(),
      name: selectedServiceName.value,
      plan: selectedPlanName.value,
      period: selectedPeriodName.value,
      price: selectedPrice.value,
      isFixedPricing: isFixedPricing.value,
      paymentMethod: selectedPaymentMethod.value,
      remindMe: '',
    ));
    initialController.personalData.refresh();
    CustomSnackbar().simple("Added service");
    Get.back();
  }

  bool validatePaymentMethod(String arg) =>
      (selectedPaymentMethod.value.toLowerCase() != 'cash' &&
          (selectedPaymentMethod.value.length != 4 ||
              (int.tryParse(selectedPaymentMethod.value) is! int)));
  bool isInteger(num value) => value is int || value == value.roundToDouble();
}
