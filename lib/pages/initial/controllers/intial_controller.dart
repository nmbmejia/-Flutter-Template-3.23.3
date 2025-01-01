// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'dart:async';
import 'dart:io';

import 'package:Acorn/models/app_data_model.dart';
import 'package:Acorn/models/personal_data_model.dart';
import 'package:Acorn/pages/home/homepage.dart';
import 'package:Acorn/pages/initial/startup.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/widgets/custom_snackbar.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class InitialController extends GetxController {
  late String subscriptionOptionsData;
  late String otherOptionsData;

  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController contactTextController = TextEditingController();

  // Local user data
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString contactNumber = ''.obs;

  final Rx<PersonalDataModel> personalData =
      Rx<PersonalDataModel>(PersonalDataModel());
  final Rx<AppDataModel> appData =
      Rx<AppDataModel>(AppDataModel(services: [], periods: []));

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
      Get.offAll(const StartupWidget());
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

  void nextOnboardingStep() {
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
    }
  }

  void login() {
    if ((email.value ?? '').isEmpty) {
      CustomSnackbar().simple('Email cannot be blank');
      return;
    }
    if ((password.value ?? '').isEmpty) {
      CustomSnackbar().simple('Password cannot be blank');
      return;
    }
    CustomSnackbar().simple('Logged in as $email');
  }

  void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}
