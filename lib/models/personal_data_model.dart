// // To parse this JSON data, do
// //
// //     final personalDataModel = personalDataModelFromJson(jsonString);

// import 'dart:convert';
// import 'package:Acorn/models/app_data_model.dart';

// PersonalDataModel personalDataModelFromJson(String str) =>
//     PersonalDataModel.fromJson(json.decode(str));

// String personalDataModelToJson(PersonalDataModel data) =>
//     json.encode(data.toJson());

// class PersonalDataModel {
//   final User? user;
//   final List<SubscribedService>? subscribedServices;

//   PersonalDataModel({
//     this.user,
//     this.subscribedServices,
//   });

//   factory PersonalDataModel.fromJson(Map<String, dynamic> json) =>
//       PersonalDataModel(
//         user: json["user"] == null ? null : User.fromJson(json["user"]),
//         subscribedServices: json["subscribed_services"] == null
//             ? []
//             : List<SubscribedService>.from(json["subscribed_services"]!
//                 .map((x) => SubscribedService.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "user": user?.toJson(),
//         "subscribed_services": subscribedServices == null
//             ? []
//             : List<dynamic>.from(subscribedServices!.map((x) => x.toJson())),
//       };
// }

// enum RemindMe {
//   noRemind,
//   onTheDay,
//   oneDay,
//   twoDay,
//   threeDay,
// }
