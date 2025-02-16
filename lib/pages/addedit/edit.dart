import 'package:Acorn/models/reminder_model.dart';
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
import 'package:Acorn/widgets/dialogs/custom.dart';
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
      required this.reminder,
      required this.hasPaymentBeenMade,
      required this.paymentAmount});
  final String id;
  final DateTime boxDate;
  final Reminder reminder;
  final bool hasPaymentBeenMade;
  // Payment amount returns null if no payment has been made
  final double? paymentAmount;
  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final CalendarController calendarController = Get.find<CalendarController>();
  final InitialController initialController = Get.find<InitialController>();
  final EditController editController = Get.find<EditController>();

  @override
  void initState() {
    debugPrint(
        'hasPaymentBeenMade: ${widget.hasPaymentBeenMade}: ${widget.paymentAmount}');
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
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
                              ),
                            ],
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
                              icon: CustomFunctions.getIconForReminder(
                                  widget.reminder),
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
                                  Flexible(
                                    child: Custom.header2(widget.reminder.title,
                                        isBold: true,
                                        maxLines: 1,
                                        textAlign: TextAlign.center),
                                  ),
                                  Visibility(
                                    visible: widget.reminder.isFixed,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 2),
                                        margin: const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Custom.body1(
                                            Constants.currency +
                                                (widget.reminder.amount ?? 0)
                                                    .toMonetaryFormat(),
                                            isBold: true,
                                            color: AppColors.greenColor)),
                                  )
                                ],
                              ),
                            ),
                            AnimatedFadeInItem(
                              index: 2,
                              delayInMs: 250,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Custom.subheader2(
                                      'Due ${DateFormat('MMMM d, y').format(calendarController.currentDate.value)}',
                                      color: AppColors.whiteTertiaryColor,
                                      isBold: false),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: CustomFunctions.whenPaymentBeenMade(
                                      widget.reminder,
                                      calendarController.currentDate.value) !=
                                  null,
                              child: AnimatedFadeInItem(
                                index: 3,
                                delayInMs: 250,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Custom.subheader2(
                                        'Paid ${DateFormat('MMMM d, y').format(CustomFunctions.whenPaymentBeenMade(widget.reminder, calendarController.currentDate.value) ?? Constants.dateToday)}',
                                        color: AppColors.whiteTertiaryColor,
                                        isBold: false),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: CustomFunctions.whenPaymentBeenMade(
                                      widget.reminder,
                                      calendarController.currentDate.value) ==
                                  null,
                              child: AnimatedFadeInItem(
                                index: 3,
                                delayInMs: 250,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Custom.subheader2('Unpaid',
                                        color: AppColors.whiteTertiaryColor,
                                        isBold: false),
                                  ],
                                ),
                              ),
                            ),
                            VertSpace.thirty(),

                            Visibility(
                              visible: !widget.reminder.isFixed,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: CustomInput(
                                      text: widget.paymentAmount
                                              ?.toMonetaryFormat() ??
                                          '',
                                      hintText: widget.paymentAmount
                                              ?.toMonetaryFormat() ??
                                          '',
                                      onTextChanged: (data) {
                                        editController.specifiedAmount =
                                            double.tryParse(data as String) ??
                                                0.0;
                                      },
                                    ),
                                  ),
                                  VertSpace.fifteen(),
                                ],
                              ),
                            ),
                            !widget.hasPaymentBeenMade
                                ? GestureDetector(
                                    onTap: () {
                                      editController.markAsPaid(
                                          widget.reminder.isFixed,
                                          widget.reminder.userEmail,
                                          widget.reminder.id,
                                          widget.reminder.amount ?? 0,
                                          Constants.dateToday,
                                          widget.boxDate);
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color(0xFFCBF231)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(CupertinoIcons
                                              .check_mark_circled),
                                          const SizedBox(width: 10),
                                          Custom.body1('Mark as Paid',
                                              isBold: true,
                                              color: AppColors.primaryColor)
                                        ],
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      editController.markAsUnpaid(
                                        widget.reminder.userEmail,
                                        widget.reminder.id,
                                        widget.boxDate,
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: AppColors.redColor),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(CupertinoIcons
                                              .check_mark_circled),
                                          const SizedBox(width: 10),
                                          Custom.body1('Mark as Unpaid',
                                              isBold: true,
                                              color: AppColors.primaryColor)
                                        ],
                                      ),
                                    ),
                                  ),

                            // Visibility(
                            //   visible: !(service?.isFixedPricing ?? true) &&
                            //       !CustomFunctions.hasMadePayment(
                            //           service!, widget.boxDate),
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       editController.markAsPaid(
                            //           widget.id, widget.boxDate);
                            //     },
                            //     child: Container(
                            //       width:
                            //           MediaQuery.of(context).size.width * 0.5,
                            //       padding: const EdgeInsets.symmetric(
                            //           horizontal: 20, vertical: 15),
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(15),
                            //           color: const Color(0xFFCBF231)),
                            //       child: Row(
                            //         children: [
                            //           const Icon(
                            //               CupertinoIcons.check_mark_circled),
                            //           const SizedBox(
                            //             width: 10,
                            //           ),
                            //           Custom.subheader2('Mark as paid',
                            //               color: Colors.black87, isBold: true),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            VertSpace.fifteen(),
                            // Visibility(
                            //   visible: !(!(service?.isFixedPricing ?? true) &&
                            //       !CustomFunctions.hasMadePayment(
                            //           service!, widget.boxDate)),
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       editController.markAsUnpaid(
                            //           widget.id, widget.boxDate);
                            //     },
                            //     child: Container(
                            //       width:
                            //           MediaQuery.of(context).size.width * 0.5,
                            //       padding: const EdgeInsets.symmetric(
                            //           horizontal: 20, vertical: 15),
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(15),
                            //           border: Border.all(
                            //               width: 1,
                            //               color: AppColors.dialogColor),
                            //           color: Colors.transparent),
                            //       child: Row(
                            //         children: [
                            //           const Icon(
                            //             CupertinoIcons.xmark_circle,
                            //             color: AppColors.dialogColor,
                            //           ),
                            //           const SizedBox(
                            //             width: 10,
                            //           ),
                            //           Custom.subheader2('Mark as unpaid',
                            //               color: AppColors.dialogColor,
                            //               isBold: false),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          CustomDialog.generic(context,
                              title: 'Delete all payments',
                              content:
                                  'This will delete all instances of this reminder and all associated payments.',
                              withActions: true, onOk: () {
                            editController.deleteReminder(
                              widget.reminder.userEmail,
                              widget.reminder.id,
                            );
                          });
                        },
                        child: Center(
                          child: Icon(
                            CupertinoIcons.delete_simple,
                            size: 25,
                            color: AppColors.redColor.withOpacity(0.9),
                          ),
                        ),
                      ),
                      VertSpace.fifteen(),
                      VertSpace.thirty(),
                    ],
                  ),
                ))));
  }
}
