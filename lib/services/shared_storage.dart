import 'dart:convert';

import 'package:Acorn/models/personal_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedStorage {
  static const _firstAppRun = 'firstAppRun';
  static const _personalData = 'personalData';

  // static savePersonalData(PersonalDataModel personalData) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.setString(_personalData, personalDataModelToJson(personalData));
  // }

  // static Future<PersonalDataModel?> getPersonalData() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String? jsonString = pref.getString(_personalData);
  //   PersonalDataModel? personalData =
  //       jsonString == null ? null : personalDataModelFromJson(jsonString);
  //   return personalData;
  // }

  static setfirstAppRun() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(_firstAppRun, true);
  }

  static Future<bool> isFirstAppRun() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool firstAppRun = pref.getBool(_firstAppRun) ?? false;
    return firstAppRun;
  }

  // static deleteLastJoinedRoom() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.remove(_lastJoinedRoom);
  // }

  // static saveLastJoinedRoom(String lastJoinedRoom) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.setString(_lastJoinedRoom, lastJoinedRoom);
  // }

  // static savePhoneNumber(String phoneNumber) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.setString(_phoneNumber, phoneNumber);
  // }

  // static Future<String?> getPhoneNumber() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String? phoneNumber = pref.getString(_phoneNumber);
  //   return phoneNumber;
  // }

  // static saveLastName(String lastName) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.setString(_lastName, lastName);
  // }

  // static Future<String?> getLastName() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String? lastName = pref.getString(_lastName);
  //   return lastName;
  // }
}
