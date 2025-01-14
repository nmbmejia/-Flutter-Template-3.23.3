// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'dart:async';
import 'dart:io';
import 'package:Acorn/pages/home/homepage.dart';
import 'package:Acorn/pages/initial/auth.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/firebase/auth_service.dart';
import 'package:Acorn/services/go.dart';
import 'package:Acorn/widgets/custom_snackbar.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class InitialController extends GetxController {
  // User related
  UserCredential? loggedUser;

  // Onboarding
  late PageController pageController;

  //? STEP 1
  RxInt activeStep = 0.obs;
  RxnString name = RxnString(null);
  Rxn<DateTime> birthDate = Rxn<DateTime>(null);
  final RxList<bool> selectedSkill = [false, false, false].obs;

  //? STEP 2 && Login
  RxnString email = RxnString(null);
  RxnString password = RxnString(null);
  RxnString confirmPassword = RxnString(null);

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  void redirect(int seconds) {
    Future.delayed(Duration(seconds: seconds), () {
      Get.offAll(const AuthGate());
    });
  }

  Future<void> getDate(BuildContext context) async {
    await showRangePickerDialog(
      context: context,
      minDate: DateTime(1960, 1, 1),
      maxDate: DateTime.now(),
    );
  }

  void goToHomePage() {
    Get.offAll(const HomePage());
  }

  void reinitializeOnboarding() {
    activeStep.value = 0;
    name.value = null;
    birthDate.value = null;
    email.value = null;
    password.value = null;
    confirmPassword.value = null;
    for (int i = 0; i < selectedSkill.length; i++) {
      selectedSkill[i] = false;
    }
  }

  void reinitializeLogin() {
    email.value = null;
    password.value = null;
  }

  Future<void> nextOnboardingStep() async {
    if (activeStep.value == 0) {
      if ((name.value ?? '').isEmpty) {
        CustomSnackbar().simple('Name cannot be blank');
        return;
      }
      if (birthDate.value == null) {
        CustomSnackbar().simple('Birthdate cannot be blank');
        return;
      }
      if (!selectedSkill.contains(true)) {
        CustomSnackbar().simple('Skill level cannot be blank');
        return;
      }

      activeStep.value = 1;
      pageController.animateToPage(1,
          duration: Duration(milliseconds: Constants.appAnimations),
          curve: Curves.fastLinearToSlowEaseIn);
    } else if (activeStep.value == 1) {
      if ((email.value ?? '').isEmpty) {
        CustomSnackbar().simple('Email cannot be blank');
        return;
      }
      if ((password.value ?? '').isEmpty) {
        CustomSnackbar().simple('Password cannot be blank');
        return;
      }
      if ((confirmPassword.value ?? '').isEmpty) {
        CustomSnackbar().simple('Confirm password cannot be blank');
        return;
      }
      if ((password.value ?? '') != (confirmPassword.value ?? '')) {
        CustomSnackbar().simple('Passwords are not the same');
        return;
      }

      List<String> skills = ['Beginner', 'Intermediate', 'Advanced'];
      String selectedSkillString =
          skills[selectedSkill.indexWhere((sel) => true)];

      loggedUser = await AuthService().registerWithEmailAndPassword(
          email.value ?? '',
          password.value ?? '',
          name.value ?? '',
          birthDate.value ?? DateTime.now(),
          selectedSkillString);
      if (loggedUser != null) {
        CustomSnackbar().simple('Logged in as ${email.value}');
        Go.offAll(const HomePage());
      }
    }
  }

  Future<void> login() async {
    if ((email.value ?? '').isEmpty) {
      CustomSnackbar().simple('Email cannot be blank');
      return;
    }
    if ((password.value ?? '').isEmpty) {
      CustomSnackbar().simple('Password cannot be blank');
      return;
    }
    loggedUser = await AuthService()
        .signInWithEmailAndPassword(email.value ?? '', password.value ?? '');
    if (loggedUser != null) {
      CustomSnackbar().simple('Logged in as ${email.value}');
      Go.offAll(const HomePage());
    }
  }

  void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}
