// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Acorn/models/app_data_model.dart';
import 'package:Acorn/models/personal_data_model.dart';
import 'package:Acorn/pages/home/homepage.dart';
import 'package:Acorn/pages/initial/notification_gate.dart';
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
      Rx<AppDataModel>(AppDataModel(services: [], reminderDurations: []));

  @override
  void onInit() {
    checkPermissions();
    getUserData();
    fetchReminderDurations();
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

  void fetchReminderDurations() async {
    Map<String, dynamic> reminderDurations = {
      "reminder_durations": [
        {"name": Strings.remindMeOnTheDay},
        {"name": Strings.remindMe1D},
        {"name": Strings.remindMe2D},
        {"name": Strings.remindMe3D},
      ]
    };
    appData.value.reminderDurations = reminderDurations['reminder_durations']
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

  void redirect(int seconds) {
    Future.delayed(Duration(seconds: seconds), () {
      Get.offAll(const NotificationPermissionPage());
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
