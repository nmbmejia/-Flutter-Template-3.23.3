import 'package:Acorn/pages/home/controllers/homepage_controller.dart';
import 'package:Acorn/pages/home/pages/admin.dart';
import 'package:Acorn/pages/home/pages/default.dart';
import 'package:Acorn/pages/initial/auth.dart';
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
  @override
  void initState() {
    Get.lazyPut<HomePageController>(() => HomePageController());
    super.initState();
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
                        Custom.header3('Hi, Neil', color: Colors.black87),
                        GestureDetector(
                          onTap: () async {
                            CustomSnackbar().simple('Logged out.');
                            await AuthService().signOut();
                            Get.offAll(const AuthGate());
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
                      visible: homepageController.isAdmin.value,
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
