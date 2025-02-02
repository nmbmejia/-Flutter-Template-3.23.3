import 'package:Acorn/models/user_model.dart';
import 'package:Acorn/pages/home/homepage.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/firebase/auth_service.dart';
import 'package:Acorn/services/firestore/user_firestore_service.dart';
import 'package:Acorn/services/go.dart';
import 'package:Acorn/services/loader.dart';
import 'package:Acorn/widgets/animated_fade_in.dart';
import 'package:Acorn/widgets/custom_input.dart';
import 'package:Acorn/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Container(
          color: AppColors.primaryColor,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedFadeInItem(
                  index: 1,
                  delayInMs: 450,
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.asset(
                      'assets/images/acorn.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: CustomInput(
                    focus: true,
                    hintText: 'Email',
                    onTextChanged: (data) {
                      String text = data as String;
                      controller.email = text;

                      if (controller.isRegistering.value) {
                        controller.isFormComplete.value =
                            controller.email.isNotEmpty &&
                                controller.password.isNotEmpty &&
                                controller.confirmPassword.isNotEmpty;
                      } else {
                        controller.isFormComplete.value =
                            controller.email.isNotEmpty &&
                                controller.password.isNotEmpty;
                      }
                    },
                    icon: const Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: CustomInput(
                    hintText: 'Password',
                    onTextChanged: (data) {
                      String text = data as String;
                      controller.password = text;

                      if (controller.isRegistering.value) {
                        controller.isFormComplete.value =
                            controller.email.isNotEmpty &&
                                controller.password.isNotEmpty &&
                                controller.confirmPassword.isNotEmpty;
                      } else {
                        controller.isFormComplete.value =
                            controller.email.isNotEmpty &&
                                controller.password.isNotEmpty;
                      }
                    },
                    icon: const Icon(Icons.lock_outline),
                    obscureText: true,
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.isRegistering.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: CustomInput(
                            hintText: 'Confirm Password',
                            onTextChanged: (data) {
                              String text = data as String;
                              controller.confirmPassword = text;

                              if (controller.isRegistering.value) {
                                controller.isFormComplete.value =
                                    controller.email.isNotEmpty &&
                                        controller.password.isNotEmpty &&
                                        controller.confirmPassword.isNotEmpty;
                              } else {
                                controller.isFormComplete.value =
                                    controller.email.isNotEmpty &&
                                        controller.password.isNotEmpty;
                              }
                            },
                            icon: const Icon(Icons.lock_outline),
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => controller.isRegistering.value
                      ? GestureDetector(
                          onTap: () {
                            controller.isRegistering.value = false;
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 0, top: 20),
                            child: Custom.body1('Back to login',
                                textAlign: TextAlign.justify,
                                isBold: false,
                                color: AppColors.whiteSecondaryColor),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            controller.isRegistering.value = true;
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 0, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 1,
                                  color: AppColors.whiteColor.withOpacity(0.2),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Custom.body1('or Register',
                                      textAlign: TextAlign.justify,
                                      isBold: false,
                                      color: AppColors.whiteSecondaryColor),
                                ),
                                Container(
                                  width: 50,
                                  height: 1,
                                  color: AppColors.whiteColor.withOpacity(0.2),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => Opacity(
                    opacity: controller.isFormComplete.value ? 1 : 0.2,
                    child: GestureDetector(
                      onTap: () {
                        controller.isFormComplete.value
                            ? controller.isRegistering.value
                                ? controller.register()
                                : controller.login(context)
                            : null;
                      },
                      child: controller.isLoading.value
                          ? const AnimatedFadeInItem(
                              index: 2, delayInMs: 250, child: LoaderWidget())
                          : AnimatedFadeInItem(
                              index: 2,
                              delayInMs: 250,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.lightGrayColor,
                                ),
                                child: const Icon(
                                  Icons.navigate_next_outlined,
                                  size: 30,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginController extends GetxController {
  UserCredential? loggedUser;
  UserModel? loggedUserDetails;

  RxBool isLoading = false.obs;
  RxBool isFormComplete = false.obs;
  RxBool isRegistering = false.obs;
  String email = '';
  String password = '';
  String confirmPassword = '';

  void goToHomePage({String? savedEmail}) async {
    loggedUserDetails = await UserFirestoreService.getUser(
        email.isNotEmpty ? email : savedEmail ?? '');
    CustomSnackbar().simple('Logged in as ${loggedUserDetails?.email}');
    Go.offAll(const HomePage());
  }

  Future<void> login(BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      CustomSnackbar().simple('Please fill in all fields');
      return;
    }

    if (!email.isEmail) {
      CustomSnackbar().simple('Please enter a valid email');
      return;
    }

    if (password.length < 8) {
      CustomSnackbar().simple('Password must be at least 8 characters');
      return;
    }
    isLoading.value = true;
    loggedUser =
        await AuthService().signInWithEmailAndPassword(email, password);
    if (loggedUser != null) {
      goToHomePage();
    }
    isLoading.value = false;
    // CustomDialog.generic(context,
    //     title: 'Account does not exist',
    //     content: 'Do you want to register instead?',
    //     withActions: true, onOk: () {
    //   isRegistering.value = true;
    // });
  }

  Future<void> register() async {
    if (email.isEmpty || password.isEmpty) {
      CustomSnackbar().simple('Please fill in all fields');
      return;
    }
    if (email.isEmpty || password.isEmpty) {
      CustomSnackbar().simple('Please fill in all fields');
      return;
    }

    if (!email.isEmail) {
      CustomSnackbar().simple('Please enter a valid email');
      return;
    }

    if (password.length < 8) {
      CustomSnackbar().simple('Password must be at least 8 characters');
      return;
    }
    if (password != confirmPassword) {
      CustomSnackbar().simple('Passwords do not match');
      return;
    }
    isLoading.value = true;

    loggedUser =
        await AuthService().registerWithEmailAndPassword(email, password);
    if (loggedUser != null) {
      goToHomePage();
    }
    isLoading.value = false;
  }
}
