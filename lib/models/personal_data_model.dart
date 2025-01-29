// To parse this JSON data, do
//
//     final personalDataModel = personalDataModelFromJson(jsonString);

import 'dart:convert';
import 'package:Acorn/models/app_data_model.dart';

PersonalDataModel personalDataModelFromJson(String str) =>
    PersonalDataModel.fromJson(json.decode(str));

String personalDataModelToJson(PersonalDataModel data) =>
    json.encode(data.toJson());

class PersonalDataModel {
  final User? user;
  final List<SubscribedService>? subscribedServices;

  PersonalDataModel({
    this.user,
    this.subscribedServices,
  });

  factory PersonalDataModel.fromJson(Map<String, dynamic> json) =>
      PersonalDataModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        subscribedServices: json["subscribed_services"] == null
            ? []
            : List<SubscribedService>.from(json["subscribed_services"]!
                .map((x) => SubscribedService.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "subscribed_services": subscribedServices == null
            ? []
            : List<dynamic>.from(subscribedServices!.map((x) => x.toJson())),
      };
}

enum RemindMe {
  noRemind,
  onTheDay,
  oneDay,
  twoDay,
  threeDay,
}

class SubscribedService {
  final String? id;
  final Service? subscription;
  final DateTime? date;
  String? name;
  double price;
  bool isFixedPricing;
  List<Payment> payments;
  RemindMe remindMe;

  SubscribedService({
    this.id,
    this.subscription,
    this.date,
    this.name,
    this.price = 0,
    this.isFixedPricing = false,
    this.payments = const [],
    this.remindMe = RemindMe.onTheDay,
  });

  factory SubscribedService.fromJson(Map<String, dynamic> json) =>
      SubscribedService(
        id: json["id"],
        subscription: json["subscription"] == null
            ? null
            : Service.fromJson(json["subscription"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        name: json["name"],
        price: json["price"] ?? 0,
        isFixedPricing: json["is_fixed_pricing"] ?? false,
        payments: json["payments"] == null
            ? const []
            : List<Payment>.from(
                json["payments"]!.map((x) => Payment.fromJson(x))),
        remindMe: json["remind_me"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subscription": subscription,
        "date": date?.toIso8601String(),
        "name": name,
        "price": price,
        "is_fixed_pricing": isFixedPricing,
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
        "remind_me": remindMe,
      };
}

class Payment {
  DateTime? date;
  double? price;

  Payment({
    this.date,
    this.price,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "price": price,
      };
}

class User {
  final String? uuid;
  final String? deviceModel;
  final DateTime? lastAccess;
  final DateTime? exportedOn;

  User({
    this.uuid,
    this.deviceModel,
    this.lastAccess,
    this.exportedOn,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        uuid: json["uuid"],
        deviceModel: json["device_model"],
        lastAccess: json["last_access"] == null
            ? null
            : DateTime.parse(json["last_access"]),
        exportedOn: json["exported_on"] == null
            ? null
            : DateTime.parse(json["exported_on"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "device_model": deviceModel,
        "last_access": lastAccess?.toIso8601String(),
        "exported_on": exportedOn?.toIso8601String(),
      };
}
