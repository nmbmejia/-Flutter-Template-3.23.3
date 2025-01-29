import 'dart:ui';

import 'package:Acorn/models/app_data_model.dart';
import 'package:Acorn/models/personal_data_model.dart';
import 'package:Acorn/pages/calendar/controllers/calendar_controller.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/go.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class EditController extends GetxController {
  int defaultSelectionForDeletion = 0;
  static double blurStrength = 2;
  final InitialController initialController = Get.find<InitialController>();
  final CalendarController calendarController = Get.find<CalendarController>();

  // Input fields;
  RxDouble selectedPrice = 0.0.obs;

  void init() {}

  void delete(SubscribedService? service) async {
    if (service != null) {
      //calendarController.currentDate.value
      try {
        // Delete if one time, or if not one time but deleting the original subscribed service.
        // if (service.period == Strings.oneTime ||
        //     (service.period != Strings.oneTime &&
        //         (DateUtils.isSameDay(
        //             service.date, calendarController.currentDate.value)))) {
        //   showDeleteDialog(
        //       body: "It will delete this and all future occurrences.",
        //       onDelete: () => deleteOriginalService(service));
        // } else {
        //   showDeleteDialog(
        //       body: "It will delete this and all future occurrences.",
        //       onDelete: () => deleteThisAndFutureServices(service));
        // }
      } catch (e) {
        CustomSnackbar().simple(e.toString());
      }
    }
  }

  void deleteOriginalService(SubscribedService? service) {
    initialController.personalData.value.subscribedServices
        ?.removeWhere((s) => s.id == service?.id);
    debugPrint(
        'Services count ${initialController.personalData.value.subscribedServices?.length}');
  }

  void markAsPaid(String id, DateTime boxDate) {
    int index = (initialController.personalData.value.subscribedServices ?? [])
        .indexWhere((service) => service.id == id);
    if (index == -1) {
      return;
    }
    if (selectedPrice.value <= 1) {
      CustomSnackbar().simple('Payment is invalid.');
      return;
    }

    initialController.personalData.value.subscribedServices?[index].payments
        .add(Payment(date: boxDate, price: selectedPrice.value));
    initialController.personalData.refresh();
    CustomSnackbar().simple('Marked as paid.');
    Get.back();
  }

  void markAsUnpaid(String id, DateTime boxDate) {
    int index = (initialController.personalData.value.subscribedServices ?? [])
        .indexWhere((service) => service.id == id);
    if (index == -1) {
      return;
    }

    initialController.personalData.value.subscribedServices?[index].payments
        .removeWhere((payment) => payment.date == boxDate);
    initialController.personalData.refresh();
    CustomSnackbar().simple('Marked as unpaid.');
    Get.back();
  }

  Future<void> showDeleteDialog(
      {required String body, required VoidCallback onDelete}) {
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.dialogColor),
                    child:
                        Custom.body1('Are you sure about this?', isBold: true),
                  ),
                  VertSpace.eight(),
                  Container(
                    width: Get.width * 0.75,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.dialogColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Custom.body1(body, textAlign: TextAlign.center),
                        // Add a spacer
                        VertSpace.fifteen(),
                        // Delete and Cancel buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilledButton.icon(
                              onPressed: () {
                                onDelete();
                                CustomSnackbar().simple("Deleted");
                                initialController.personalData.refresh();
                                Get.back(); // Handle delete action here
                                Get.back(); // Handle delete action here
                              },
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.white),
                              label: Custom.body1('Delete', isBold: true),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                              ),
                            ),
                            HorizSpace.eight(),
                            OutlinedButton(
                              onPressed: () {
                                Get.back(); // Close the dialog
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                              ),
                              child: Custom.body1('Cancel', isBold: true),
                            ),
                          ],
                        ),
                        VertSpace.eight(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurStrength * anim1.value,
          sigmaY: blurStrength * anim1.value,
        ),
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      ),
      context: Get.context!,
    );
  }
}
