import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/firestore/reminder_firestore_service.dart';
import 'package:Acorn/widgets/custom_snackbar.dart';
import 'package:Acorn/widgets/string_extension.dart';
import 'package:get/get.dart';

class EditController extends GetxController {
  double specifiedAmount = 0;

  void markAsPaid(bool isFixed, String userEmail, String reminderId,
      double fixAmount, DateTime date) async {
    if (specifiedAmount < 1 && !isFixed) {
      CustomSnackbar().simple('Amount cannot be less than 1.');
      return;
    }
    Get.back();
    final success = await ReminderFirestoreService().addPayment(
        userEmail,
        reminderId,
        Payment(amount: isFixed ? fixAmount : specifiedAmount, date: date));
    if (success) {
      CustomSnackbar().simple(
          'Marked as paid (${Constants.currency}${isFixed ? fixAmount.toMonetaryFormat() : specifiedAmount.toMonetaryFormat()})');
    } else {
      CustomSnackbar().simple('Failed to add payment');
    }
  }

  void deletePayment(String userEmail, String reminderId, DateTime date) async {
    Get.back();
    final success = await ReminderFirestoreService()
        .deletePayment(userEmail, reminderId, date);
    if (success) {
      CustomSnackbar().simple('Marked as unpaid.');
    } else {
      CustomSnackbar().simple('Failed to delete payment');
    }
  }
}
