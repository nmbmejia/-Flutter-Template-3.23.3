// To parse this JSON data, do
//
//     final personalDataModel = personalDataModelFromJson(jsonString);

import 'dart:convert';

import 'package:Acorn/models/app_data_model.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';

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

class SubscribedService {
  final Service? subscription;
  final DateTime? date;
  final DateTime? updatedDate;
  final String? name;
  final String? plan;
  final String? period;
  final double price;
  final bool isFixedPricing;
  final String? paymentMethod;
  final String? remindMe;

  SubscribedService({
    this.subscription,
    this.date,
    this.updatedDate,
    this.name,
    this.plan,
    this.period,
    this.price = 0,
    this.isFixedPricing = false,
    this.paymentMethod,
    this.remindMe,
  });

  factory SubscribedService.fromJson(Map<String, dynamic> json) =>
      SubscribedService(
        subscription: json["subscription"] == null
            ? null
            : Service.fromJson(json["subscription"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        updatedDate: json["updated_date"] == null
            ? null
            : DateTime.parse(json["updated_date"]),
        name: json["name"],
        plan: json["plan"],
        period: json["period"],
        price: json["price"] ?? 0,
        isFixedPricing: json["is_fixed_pricing"] ?? false,
        paymentMethod: json["payment_method"],
        remindMe: json["remind_me"],
      );

  Map<String, dynamic> toJson() => {
        "subscription": subscription,
        "date": date?.toIso8601String(),
        "updated_date": updatedDate?.toIso8601String(),
        "name": name,
        "plan": plan,
        "period": period,
        "price": price,
        "is_fixed_pricing": isFixedPricing,
        "payment_method": paymentMethod,
        "remind_me": remindMe,
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
