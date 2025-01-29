// To parse this JSON data, do
//
//     final appDataModel = appDataModelFromJson(jsonString);

import 'dart:convert';

AppDataModel appDataModelFromJson(String str) =>
    AppDataModel.fromJson(json.decode(str));

String appDataModelToJson(AppDataModel data) => json.encode(data.toJson());

class AppDataModel {
  List<Service>? services;
  List<Period>? reminderDurations;

  AppDataModel({this.services, this.reminderDurations});

  factory AppDataModel.fromJson(Map<String, dynamic> json) => AppDataModel(
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
        reminderDurations: json["reminder_durations"] == null
            ? []
            : List<Period>.from(
                json["reminder_durations"]!.map((x) => Period.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        "reminder_durations": reminderDurations == null
            ? []
            : List<dynamic>.from(reminderDurations!.map((x) => x.toJson())),
      };
}

class ReminderDuration {
  String? name;

  ReminderDuration({
    this.name,
  });

  factory ReminderDuration.fromJson(Map<String, dynamic> json) =>
      ReminderDuration(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Period {
  String? name;

  Period({
    this.name,
  });

  factory Period.fromJson(Map<String, dynamic> json) => Period(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Service {
  String? name;
  String? icon;

  Service({
    this.name,
    this.icon,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "icon": icon,
      };
}

class Plan {
  String? name;
  double? price;

  Plan({
    this.name,
    this.price,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
      };
}
