import 'package:Acorn/pages/addedit/add.dart';
import 'package:Acorn/pages/calendar/calendar.dart';
import 'package:Acorn/pages/home/container.dart';
import 'package:Acorn/pages/home/controllers/homepage_controller.dart';
import 'package:Acorn/pages/home/shared_axis.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/go.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/services/strings.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Get.lazyPut<HomePageController>(() => HomePageController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(builder: (homepageController) {
      return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // HorizSpace.fifteen(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Custom.header1(Strings.myCalendar,
                            color: AppColors.whiteColor, isBold: true),
                        HorizSpace.eight(),
                        GestureDetector(
                          onTap: () {
                            Go.to(SharedAxisTransitionDemo());
                          },
                          child: const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.whiteSecondaryColor,
                            size: 32,
                          ),
                        )
                      ],
                    ),
                    OpenContainer(
                      transitionType: ContainerTransitionType.fade,
                      transitionDuration:
                          Duration(milliseconds: Constants.appAnimations),
                      openBuilder: (BuildContext context, VoidCallback _) {
                        return const Add();
                      },
                      closedColor: AppColors.primaryColor,
                      closedBuilder:
                          (BuildContext context, VoidCallback openContainer) {
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.lightGrayColor,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 30,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Obx(
                //       () => Row(
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: [
                //           GestureDetector(
                //             onTap: () {
                //               homepageController.selectedHeader.value = 0;
                //             },
                //             child: Custom.header1(Strings.monthly,
                //                 color:
                //                     homepageController.selectedHeader.value == 0
                //                         ? AppColors.whiteColor
                //                         : AppColors.lightGrayColor,
                //                 isBold:
                //                     homepageController.selectedHeader.value == 0
                //                         ? true
                //                         : false),
                //           ),
                //           const SizedBox(
                //             width: 20,
                //           ),
                //           GestureDetector(
                //             onTap: () {
                //               homepageController.selectedHeader.value = 1;
                //             },
                //             child: Custom.header2(Strings.oneTime,
                //                 color:
                //                     homepageController.selectedHeader.value == 1
                //                         ? AppColors.whiteColor
                //                         : AppColors.lightGrayColor,
                //                 isBold:
                //                     homepageController.selectedHeader.value == 1
                //                         ? true
                //                         : false),
                //           )
                //         ],
                //       ),
                //     ),

                VertSpace.fifteen(),
                const Divider(
                  color: AppColors.lightGrayColor,
                ),
                VertSpace.thirty(),
                Obx(
                  () => CustomCalendar(
                    type: homepageController.selectedHeader.value == 0
                        ? CalendarState.monthly
                        : CalendarState.oneTime,
                  ),
                ),
                Opacity(
                  opacity: 0.9,
                  child: Image.asset(
                    'assets/images/acorn.png',
                    width: 18,
                    height: 18,
                    fit: BoxFit.cover,
                  ),
                ),
                Custom.body2('v1.0.0')
              ],
            ),
          ),
        ),
      );
    });
  }
}
