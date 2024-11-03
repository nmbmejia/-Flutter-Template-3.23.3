// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Acorn/models/app_data_model.dart';
import 'package:Acorn/models/personal_data_model.dart';
import 'package:Acorn/pages/home/homepage.dart';
import 'package:Acorn/services/shared_storage.dart';
import 'package:Acorn/services/strings.dart';
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

  @override
  void onInit() {
    checkPermissions();
    getUserData();
    fetchPeriods();
    fetchSubscriptionOptions();

    super.onInit();
  }

  void fetchSubscriptionOptions() async {
    subscriptionOptionsData =
        await rootBundle.loadString('assets/data/subscription_options.json');
    Map<String, dynamic> subscriptionOptions =
        jsonDecode(subscriptionOptionsData);
    List<Service> services =
        subscriptionOptions['subscriptions'].map<Service>((option) {
      return Service.fromJson(option);
    }).toList();
    appData.value.services?.addAll(services);
    fetchOtherptions();
  }

  void fetchOtherptions() async {
    otherOptionsData =
        await rootBundle.loadString('assets/data/other_options.json');
    Map<String, dynamic> otherOptions = jsonDecode(otherOptionsData);
    List<Service> others = otherOptions['others'].map<Service>((option) {
      return Service.fromJson(option);
    }).toList();
    appData.value.services?.addAll(others);
    (appData.value.services ?? [])
        .sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
  }

  void fetchPeriods() async {
    Map<String, dynamic> periods = {
      "periods": [
        {"name": Strings.oneTime},
        {"name": Strings.everyMonth},
        {"name": Strings.everyYear},
      ]
    };
    appData.value.periods = periods['periods']
        .map<Period>((period) => Period.fromJson(period))
        .toList();
  }

  Future<void> getUserData() async {
    personalData.value = await SharedStorage.getPersonalData() ??
        PersonalDataModel(user: User(), subscribedServices: []);
  }

  double getTotal() {
    return (personalData.value.subscribedServices ?? [])
        .fold(0, (sum, item) => sum.toDouble() + item.price);
  }

  void checkPermissions() async {}

  void checkUserDetailsIfExists() async {
    // firstName.value = await SharedStorage.getFirstName() ?? '';
    // lastName.value = await SharedStorage.getLastName() ?? '';
    // contactNumber.value = await SharedStorage.getPhoneNumber() ?? '';
    // if (firstName.value.isNotEmpty &&
    //     lastName.value.isNotEmpty &&
    //     contactNumber.value.isNotEmpty) {
    //   Get.to(const PermissionManagerPage());
    // } else {
    //   Get.to(const QuestionnairePage());
    // }
  }

  Future<void> saveUserDetails() async {
    // String _firstName = firstNameTextController.text;
    // String _lastName = lastNameTextController.text;
    // String _contactNumber = contactTextController.text;
    // if (_firstName.isNotEmpty &&
    //     _lastName.isNotEmpty &&
    //     _contactNumber.isNotEmpty) {
    //   if (_contactNumber.length == 11 &&
    //       (_contactNumber.split('')[0] == '0' &&
    //           _contactNumber.split('')[1] == '9')) {
    //     firstName.value = _firstName;
    //     lastName.value = _lastName;
    //     contactNumber.value = _contactNumber;
    //     await SharedStorage.saveFirstName(_firstName);
    //     await SharedStorage.saveLastName(_lastName);
    //     await SharedStorage.savePhoneNumber(_contactNumber);
    //     Get.to(const PermissionManagerPage());
    //   } else {
    //     CustomSnackbar().simple('Contact number is invalid.');
    //   }
    // } else {
    //   CustomSnackbar().simple('Please fill out all fields.');
    // }
  }

  void redirect(int seconds) {
    Future.delayed(Duration(seconds: seconds), () {
      Get.offAll(const HomePage());
    });
  }

  void goToHomePage() {
    Get.offAll(const HomePage());
  }

  void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}
