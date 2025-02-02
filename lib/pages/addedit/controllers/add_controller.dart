import 'package:Acorn/models/personal_data_model.dart';
import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/pages/calendar/controllers/calendar_controller.dart';
import 'package:Acorn/pages/initial/auth/login.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/firestore/reminder_firestore_service.dart';
import 'package:Acorn/services/firestore/reminder_status_firestore_service.dart';
import 'package:Acorn/services/id_generation.dart';
import 'package:Acorn/widgets/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable

class AddController extends GetxController {
  // Input fields;
  final RxBool isLoading = false.obs;

  RxnString selectedServiceName = RxnString(null);
  RxDouble selectedAmount = 0.0.obs;
  RxBool isFixedPricing = RxBool(false);
  Rxn<ReminderRecurrence> selectedRecurrence =
      Rxn<ReminderRecurrence>(ReminderRecurrence.once);

  void init() {
    resetAll();
  }

  void resetAll() {
    selectedAmount.value = 0.0;
    isFixedPricing.value = false;
    selectedAmount.refresh();
  }

  void resetGroup() {}

  void addNew() {
    debugPrint('Selected Price: ${selectedAmount.value}');
    if (selectedServiceName.value == null) {
      CustomSnackbar().simple("Please select a biller.");
      return;
    }

    if (isFixedPricing.value && (selectedAmount.value < 0)) {
      CustomSnackbar().simple("Price cannot be blank if it's fixed.");
      return;
    }

    final CalendarController calendarController =
        Get.find<CalendarController>();

    final LoginController loginController = Get.find<LoginController>();

    // Form data
    debugPrint('Selected Recurrence: ${selectedRecurrence.value}');
    ReminderFirestoreService().addReminder(Reminder(
      userEmail: loginController.loggedUserDetails?.email ?? '',
      title: selectedServiceName.value ?? '',
      amount: selectedAmount.value,
      isFixed: isFixedPricing.value,
      dueDay: calendarController.currentDate.value.day,
      recurrence: selectedRecurrence.value ?? ReminderRecurrence.once,
      startDate: calendarController.currentDate.value,
      endDate: selectedRecurrence.value == ReminderRecurrence.once
          ? calendarController.currentDate.value
          : null,
      payments: [],
    ));

    CustomSnackbar().simple("Added payment reminder.");

    Get.back();
  }

  bool isInteger(num value) => value is int || value == value.roundToDouble();
}
