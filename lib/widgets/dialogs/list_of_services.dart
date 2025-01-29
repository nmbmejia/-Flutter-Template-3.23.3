import 'dart:ui';
import 'package:Acorn/models/personal_data_model.dart';
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

  static showServices(
      DateTime boxDate, List<SubscribedService>? subscribedServices,
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
                      width: Get.width * 0.75,
                      height: Get.height * 0.30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppColors.dialogColor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (subscribedServices ?? []).isEmpty
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
      DateTime boxDate, List<SubscribedService>? subscribedServices) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shrinkWrap: true,
      itemCount: subscribedServices?.length,
      itemBuilder: (context, index) {
        SubscribedService? service = subscribedServices?[index];

        // int dynamicPriceGroupIndex = DateExtensions.findIndexByMonthYear(
        //     service?.dynamicPriceGroup, boxDate.month, boxDate.year);
        // bool isPaymentPending =
        //     isPartOfDynamicPriceGroup && dynamicPriceGroupIndex == -1;

        // bool priceIsFromMain = service?.period == Strings.oneTime ||
        //         (service?.period != Strings.oneTime && service!.isFixedPricing)
        //     // ? Constants.currency + service!.price.toMonetaryFormat()
        //     ? true
        //     : isPaymentPending
        //         ? false
        //         : false;

        // // Could be from main price, pending, or from dynamic group price.
        // String price = service?.period == Strings.oneTime ||
        //         (service!.period != Strings.oneTime && service.isFixedPricing)
        //     ? Constants.currency + service!.price.toMonetaryFormat()
        //     : isPaymentPending
        //         ? 'Pending'
        //         : Constants.currency +
        //             (service.dynamicPriceGroup?[dynamicPriceGroupIndex].price ??
        //                     0)
        //                 .toMonetaryFormat();

        return AnimatedFadeInItem(
          index: index,
          child: GestureDetector(
            onTap: () {
              Get.back();
              Go.to(Edit(
                  id: service.id ?? '',
                  boxDate: boxDate,
                  serviceSubscribed: service));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                          icon: service?.subscription?.icon,
                          size: 28,
                        ),
                        HorizSpace.ten(),
                        Flexible(
                          child: Custom.subheader2(
                              (service?.name ?? '').toString(),
                              isBold: true),
                        ),
                        HorizSpace.ten(),
                      ],
                    ),
                  ),
                  CustomFunctions.hasMadePayment(service!, boxDate)
                      ? Custom.body1(
                          Constants.currency + service.price.toMonetaryFormat(),
                          isBold: false,
                          color: AppColors.pendingColor)
                      : Custom.body1('Pending',
                          isBold: false, color: AppColors.redColor)
                  // service.period == Strings.oneTime ||
                  //         (service.period != Strings.oneTime &&
                  //             service.isFixedPricing)
                  //     ? Custom.body1(
                  //         Constants.currency + service.price.toMonetaryFormat(),
                  //         isBold: true,
                  //         color: AppColors.whiteColor)
                  //     : isPaymentPending
                  //         ? Custom.body1('Pending',
                  //             isBold: false, color: AppColors.pendingColor)
                  //         : Custom.body1(
                  //             Constants.currency +
                  //                 (service
                  //                             .dynamicPriceGroup?[
                  //                                 dynamicPriceGroupIndex]
                  //                             .price ??
                  //                         0)
                  //                     .toMonetaryFormat(),
                  //             isBold: false,
                  //             color: AppColors.pendingColor)
                ],
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
