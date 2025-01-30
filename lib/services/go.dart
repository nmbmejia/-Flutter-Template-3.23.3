import 'package:Acorn/services/constants.dart';
import 'package:get/get.dart';

class Go {
  static Transition defaultTransition = Transition.cupertino;

  /// Similar to **Navigation.push()**
  static Future<T?> to<T>(dynamic page,
      {dynamic arguments, Transition? transition, bool? opaque}) async {
    return await Get.to<T>(page,
        arguments: arguments,
        transition: transition ?? defaultTransition,
        duration: Duration(milliseconds: Constants.appAnimations),
        opaque: opaque);
  }

  /// Similar to **Navigation.pushReplacement**
  static Future<dynamic> off(dynamic page,
      {dynamic arguments, Transition? transition}) async {
    Get.off(
      page,
      arguments: arguments,
      transition: transition ?? defaultTransition,
      duration: Duration(milliseconds: Constants.appAnimations),
    );
  }

  /// Similar to **Navigation.pushReplacement**
  static Future<dynamic> offAll(dynamic page,
      {dynamic arguments, Transition? transition}) async {
    Get.offAll(
      page,
      arguments: arguments,
      transition: transition ?? defaultTransition,
      duration: Duration(milliseconds: Constants.appAnimations),
    );
  }

  /// Similar to **Navigation.pushAndRemoveUntil()**
  static Future<dynamic> offUntil(dynamic page,
      {Transition? transition}) async {
    Get.offUntil(
        GetPageRoute(
          page: page,
          transition: transition ?? defaultTransition,
          transitionDuration: Duration(milliseconds: Constants.appAnimations),
        ),
        (route) => false);
  }
}
