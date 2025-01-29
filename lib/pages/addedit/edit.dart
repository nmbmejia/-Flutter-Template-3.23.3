import 'package:Acorn/models/personal_data_model.dart';
import 'package:Acorn/pages/addedit/controllers/edit_controller.dart';
import 'package:Acorn/pages/calendar/controllers/calendar_controller.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/custom_functions.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/animated_fade_in.dart';
import 'package:Acorn/widgets/custom_input.dart';
import 'package:Acorn/widgets/custom_snackbar.dart';
import 'package:Acorn/widgets/icon_presenter.dart';
import 'package:Acorn/widgets/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Edit extends StatefulWidget {
  const Edit(
      {super.key,
      required this.id,
      required this.boxDate,
      required this.serviceSubscribed});
  final String id;
  final DateTime boxDate;
  final SubscribedService serviceSubscribed;

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final CalendarController calendarController = Get.find<CalendarController>();
  final InitialController initialController = Get.find<InitialController>();
  final EditController editController = Get.find<EditController>();
  late SubscribedService? service;
  int dynamicPriceGroupIndex = -1;

  @override
  void initState() {
    service = initialController.personalData.value.subscribedServices
        ?.firstWhere((service) => service.id == widget.id);

    if (service == null) {
      CustomSnackbar().simple("Not able to edit.");
      Get.back();
    }
    editController.init();
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
                          Custom.header2(''),
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
                      // VertSpace.fifteen(),
                      // VertSpace.thirty(),

                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconPresenter(
                              icon: service?.subscription?.icon,
                              size: 80,
                              enableAnimation: true,
                            ),
                            VertSpace.fifteen(),
                            AnimatedFadeInItem(
                              index: 1,
                              delayInMs: 250,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Custom.header2(service?.name ?? '',
                                      isBold: true),
                                  Visibility(
                                    visible: true,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 2),
                                      margin: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                        child: Custom.subheader2(
                                            service?.isFixedPricing ?? true
                                                ? Constants.currency +
                                                    (service?.price ?? 0)
                                                        .toMonetaryFormat()
                                                : CustomFunctions
                                                        .hasMadePayment(
                                                            service!,
                                                            widget.boxDate)
                                                    ? Constants.currency +
                                                        (CustomFunctions.getPaymentForToday(
                                                                    service!,
                                                                    widget
                                                                        .boxDate)
                                                                ?.price
                                                                ?.toMonetaryFormat() ??
                                                            '')
                                                    : 'Pending',
                                            color: AppColors.greenColor,
                                            isBold: true),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Custom.subheader2(
                                    DateFormat('MMMM d, y').format(
                                        calendarController.currentDate.value),
                                    color: AppColors.whiteTertiaryColor,
                                    isBold: false),
                              ],
                            ),
                            VertSpace.thirty(),
                            Obx(
                              () => Visibility(
                                visible: !(service?.isFixedPricing ?? true) &&
                                    !CustomFunctions.hasMadePayment(
                                        service!, widget.boxDate),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomInput(
                                      text: editController.selectedPrice.value
                                          .toString(),
                                      hintText: 'Payment',
                                      onTextChanged: (data) {
                                        editController.selectedPrice.value =
                                            double.tryParse(data as String) ??
                                                0.0;
                                        editController.selectedPrice.refresh();
                                      },
                                    ),
                                    VertSpace.thirty(),
                                    VertSpace.thirty(),
                                  ],
                                ),
                              ),
                            ),
                            // VertSpace.thirty(),

                            Visibility(
                              visible: !(service?.isFixedPricing ?? true) &&
                                  !CustomFunctions.hasMadePayment(
                                      service!, widget.boxDate),
                              child: GestureDetector(
                                onTap: () {
                                  editController.markAsPaid(
                                      widget.id, widget.boxDate);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xFFCBF231)),
                                  child: Row(
                                    children: [
                                      const Icon(
                                          CupertinoIcons.check_mark_circled),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Custom.subheader2('Mark as paid',
                                          color: Colors.black87, isBold: true),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            VertSpace.fifteen(),
                            Visibility(
                              visible: !(!(service?.isFixedPricing ?? true) &&
                                  !CustomFunctions.hasMadePayment(
                                      service!, widget.boxDate)),
                              child: GestureDetector(
                                onTap: () {
                                  editController.markAsUnpaid(
                                      widget.id, widget.boxDate);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 1,
                                          color: AppColors.dialogColor),
                                      color: Colors.transparent),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.xmark_circle,
                                        color: AppColors.dialogColor,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Custom.subheader2('Mark as unpaid',
                                          color: AppColors.dialogColor,
                                          isBold: false),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      VertSpace.fifteen(),
                      VertSpace.thirty(),
                    ],
                  ),
                ))));
  }
}
