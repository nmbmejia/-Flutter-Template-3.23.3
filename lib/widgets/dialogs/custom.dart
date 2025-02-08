import 'dart:ui';
import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/pages/addedit/edit.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/custom_functions.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/go.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/animated_fade_in.dart';
import 'package:Acorn/widgets/icon_presenter.dart';
import 'package:Acorn/widgets/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog {
  static double deviceAspect = 16;
  static double blurStrength = 2;

  static generic(
    BuildContext context, {
    String title = '',
    String content = '',
    bool withActions = false,
    VoidCallback? onOk,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteSecondaryColor,
          title: Custom.header4(title,
              isBold: false, color: AppColors.primaryColor),
          content: Custom.body1(content,
              textAlign: TextAlign.justify,
              isBold: false,
              color: AppColors.primaryColor),
          actions: withActions
              ? [
                  OutlinedButton(
                    child: Custom.body1('Cancel',
                        textAlign: TextAlign.justify,
                        isBold: false,
                        color: AppColors.primaryColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  OutlinedButton(
                    child: Custom.body1('Ok',
                        textAlign: TextAlign.justify,
                        isBold: true,
                        color: AppColors.primaryColor),
                    onPressed: () {
                      if (onOk != null) {
                        onOk();
                      }
                      Navigator.pop(context);
                    },
                  ),
                ]
              : null,
        );
      },
    );
  }

  static showServices(DateTime boxDate, List<Reminder> subscribedServices,
      {double total = 0}) {
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: Duration(milliseconds: Constants.appAnimations),
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
                  header(total: total),
                  VertSpace.eight(),
                  Container(
                      width: 300,
                      height: Get.height * 0.30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppColors.dialogColor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (subscribedServices).isEmpty
                              ? emptyState()
                              : Expanded(
                                  child: listOfServicesForTheDay(
                                      boxDate, subscribedServices)),
                        ],
                      )),
                ],
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Slide transition from bottom to top
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0.01), // Start from bottom
          end: const Offset(0, 0), // End at center
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        ));

        // Fade transition
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurStrength * animation.value,
                sigmaY: blurStrength * animation.value,
              ),
              child: child,
            ),
          ),
        );
      },
      context: Get.context!,
    );
  }

  static Widget header({double total = 0}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.dialogColor),
      child: Custom.body1('TOTAL: ₱${total.toMonetaryFormat()}', isBold: true),
    );
  }

  static Widget listOfServicesForTheDay(
      DateTime boxDate, List<Reminder>? reminders) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shrinkWrap: true,
      itemCount: reminders?.length,
      itemBuilder: (context, index) {
        Reminder? reminder = reminders?[index];
        bool hasPaymentBeenMade =
            CustomFunctions.hasPaymentBeenMade(reminder!, boxDate);
        // Payment amount returns null if no payment has been made
        double? paymentAmount =
            CustomFunctions.howMuchPaymentBeenMade(reminder, boxDate);

        return AnimatedFadeInItem(
          index: index,
          child: GestureDetector(
            onTap: () {
              Get.back();
              Go.to(Edit(
                id: reminder.id,
                boxDate: boxDate,
                reminder: reminder,
                hasPaymentBeenMade: hasPaymentBeenMade,
                paymentAmount: paymentAmount,
              ));
            },
            child: Opacity(
              opacity: hasPaymentBeenMade ? 0.5 : 1,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.darkGrayColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconPresenter(
                            icon: CustomFunctions.getIconForReminder(reminder),
                            size: 28,
                          ),
                          HorizSpace.ten(),
                          Flexible(
                            child: Custom.subheader2(
                                (reminder.title).toString(),
                                isBold: true),
                          ),
                          HorizSpace.ten(),
                        ],
                      ),
                    ),
                    hasPaymentBeenMade
                        ? Custom.body1(
                            Constants.currency +
                                (paymentAmount ?? 0.0).toMonetaryFormat(),
                            isBold: false,
                            color: AppColors.pendingColor)
                        : Custom.body1('Pending',
                            isBold: false, color: AppColors.redColor)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget emptyState() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/empty.png',
            width: 80,
            height: 80,
            color: AppColors.whiteColor.withOpacity(0.25),
            fit: BoxFit.cover,
          ),
          VertSpace.fifteen(),
          Custom.body2("Oops! It's a ghost town in here.",
              textAlign: TextAlign.center,
              isBold: true,
              color: AppColors.whiteColor.withOpacity(0.5))
        ],
      ),
    );
  }
}
