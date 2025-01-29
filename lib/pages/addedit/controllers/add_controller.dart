import 'package:Acorn/models/app_data_model.dart';
import 'package:Acorn/models/personal_data_model.dart';
import 'package:Acorn/pages/calendar/controllers/calendar_controller.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/id_generation.dart';
import 'package:Acorn/widgets/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AddController extends GetxController {
  // Input fields;
  Rxn<Service> selectedService = Rxn<Service>(null);
  RxnString selectedServiceName = RxnString(null);
  RxnString selectedReminderName = RxnString(null);
  RxBool isFixedPricing = RxBool(false);
  RxDouble selectedPrice = 0.0.obs;

  void init() {
    selectedService.value = null;
    selectedServiceName.value = null;
    resetAll();
  }

  void resetAll() {
    selectedPrice.value = 0.0;
    isFixedPricing.value = false;
    selectedReminderName.value = '';

    selectedReminderName.refresh();
    selectedPrice.refresh();
  }

  void addNew() {
    debugPrint('Selected Price: ${selectedPrice.value}');
    if (selectedServiceName.value == null) {
      CustomSnackbar().simple("Please select a biller.");
      return;
    }

    if (selectedPrice.value < 1) {
      CustomSnackbar().simple("Price cannot be empty.");
      return;
    }

    if (isFixedPricing.value && (selectedPrice.value < 0)) {
      CustomSnackbar().simple("Price cannot be blank if it's fixed.");
      return;
    }

    final InitialController initialController = Get.find<InitialController>();
    final CalendarController calendarController =
        Get.find<CalendarController>();

    // Form data
    String mainId = idGenerator();
    SubscribedService subscribedService = SubscribedService(
        id: mainId,
        subscription: selectedService.value,
        date: calendarController.currentDate.value,
        name: selectedServiceName.value,
        price: selectedPrice.value,
        isFixedPricing: isFixedPricing.value,
        payments: []);

    initialController.personalData.value.subscribedServices
        ?.add(subscribedService);

    initialController.personalData.refresh();
    CustomSnackbar().simple("Added payment reminder.");

    Get.back();
  }

  bool isInteger(num value) => value is int || value == value.roundToDouble();
}
