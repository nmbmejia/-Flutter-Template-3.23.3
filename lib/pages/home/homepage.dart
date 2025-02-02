import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/pages/addedit/add.dart';
import 'package:Acorn/pages/calendar/calendar.dart';
import 'package:Acorn/pages/home/controllers/homepage_controller.dart';
import 'package:Acorn/pages/initial/auth/auth.dart';
import 'package:Acorn/pages/initial/auth/login.dart';
import 'package:Acorn/pages/upcoming/upcoming.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/firebase/auth_service.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/services/strings.dart';
import 'package:Acorn/widgets/custom_snackbar.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(Get.find<LoginController>().loggedUserDetails?.email)
                      .collection('reminders')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No data available'),
                      );
                    }
                    List<Reminder> allReminders = snapshot.hasData
                        ? snapshot.data!.docs
                            .map((doc) => Reminder.fromFirestore(doc))
                            .toList()
                        : [];
                    debugPrint('All reminders: ${allReminders.length}');

                    return Column(
                      mainAxisSize: MainAxisSize.min,
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
                                    showProfileDropdown(context);
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
                              transitionDuration: Duration(
                                  milliseconds: Constants.appAnimations),
                              openBuilder:
                                  (BuildContext context, VoidCallback _) {
                                return const Add();
                              },
                              closedColor: AppColors.primaryColor,
                              closedBuilder: (BuildContext context,
                                  VoidCallback openContainer) {
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
                        VertSpace.fifteen(),
                        const Divider(
                          color: AppColors.lightGrayColor,
                        ),
                        VertSpace.thirty(),
                        Obx(
                          () => CustomCalendar(
                            allReminders: allReminders,
                            type: homepageController.selectedHeader.value == 0
                                ? CalendarState.monthly
                                : CalendarState.oneTime,
                          ),
                        ),
                        UpcomingReminders(
                          allReminders: allReminders,
                        ),
                        VertSpace.thirty(),
                        VertSpace.thirty(),
                        VertSpace.thirty(),
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
                    );
                  }),
            ),
          ),
        ),
      );
    });
  }

  void showProfileDropdown(BuildContext context) {
    showMenu(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      menuPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      color: const Color.fromARGB(255, 239, 239, 239),
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width -
            120, // Adjust position based on icon location
        kToolbarHeight + 75, // Below the AppBar
        30,
        0,
      ),
      items: [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              const Icon(CupertinoIcons.person_crop_square_fill,
                  color: Colors.black87),
              const SizedBox(width: 15),
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700], // Adjust as per the design
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              const Icon(CupertinoIcons.square_arrow_right,
                  color: Colors.black87),
              const SizedBox(width: 15),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700], // Adjust as per the design
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) async {
      if (value == 'logout') {
        CustomSnackbar().simple('Logged out.');
        await AuthService().signOut();
        Get.offAll(const AuthGate());
      }
    });
  }
}
