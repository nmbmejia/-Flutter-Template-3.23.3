import 'package:Acorn/pages/home/controllers/homepage_controller.dart';
import 'package:Acorn/pages/home/pages/admin.dart';
import 'package:Acorn/pages/home/pages/default.dart';
import 'package:Acorn/pages/initial/auth.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/firebase/auth_service.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final initialController = Get.put(InitialController());
  @override
  void initState() {
    Get.lazyPut<HomePageController>(() => HomePageController());
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(builder: (homepageController) {
      return Scaffold(
          backgroundColor: const Color.fromARGB(255, 239, 239, 239),
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Custom.header3(
                            initialController.loggedUserDetails?.isAdmin ??
                                    false
                                ? 'Hi, Admin ${initialController.loggedUserDetails?.name?.split(' ')[0]}'
                                : 'Hi, ${initialController.loggedUserDetails?.name?.split(' ')[0]}',
                            color: Colors.black87),
                        GestureDetector(
                          onTap: () async {
                            showProfileDropdown(context);
                          },
                          child: const Icon(
                            CupertinoIcons.profile_circled,
                            size: 48,
                            color: Colors.black87,
                          ),
                        )
                      ],
                    ),
                    Visibility(
                      visible:
                          initialController.loggedUserDetails?.isAdmin ?? false,
                      child: ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0;
                                i < homepageController.selectedAccount.length;
                                i++) {
                              homepageController.selectedAccount[i] =
                                  i == index;
                            }
                          });
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        selectedBorderColor: Colors.black87,
                        selectedColor: Colors.white,
                        fillColor: Colors.black87,
                        color: Colors.black87,
                        constraints: const BoxConstraints(
                          minHeight: 30.0,
                          minWidth: 100.0,
                        ),
                        isSelected: homepageController.selectedAccount,
                        children: const [
                          Text('Default'),
                          Text('Admin'),
                        ],
                      ),
                    ),
                    VertSpace.fifteen(),

                    //! Homepage Switcher
                    homepageController.selectedAccount.first
                        ? const HomepageDefault()
                        : const HomepageAdmin()
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
