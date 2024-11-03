// To parse this JSON data, do
//
//     final appDataModel = appDataModelFromJson(jsonString);

import 'dart:convert';

AppDataModel appDataModelFromJson(String str) =>
    AppDataModel.fromJson(json.decode(str));

String appDataModelToJson(AppDataModel data) => json.encode(data.toJson());

class AppDataModel {
  List<Service>? services;
  List<Period>? periods;

  AppDataModel({
    this.services,
    this.periods,
  });

  factory AppDataModel.fromJson(Map<String, dynamic> json) => AppDataModel(
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
        periods: json["periods"] == null
            ? []
            : List<Period>.from(
                json["periods"]!.map((x) => Period.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        "periods": periods == null
            ? []
            : List<dynamic>.from(periods!.map((x) => x.toJson())),
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
  List<Plan>? plans;

  Service({
    this.name,
    this.icon,
    this.plans,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        name: json["name"],
        icon: json["icon"],
        plans: json["plans"] == null
            ? []
            : List<Plan>.from(json["plans"]!.map((x) => Plan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "icon": icon,
        "plans": plans == null
            ? []
            : List<dynamic>.from(plans!.map((x) => x.toJson())),
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
