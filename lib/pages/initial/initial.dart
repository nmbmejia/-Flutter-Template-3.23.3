import 'package:Acorn/pages/calendar/controllers/calendar_controller.dart';
import 'package:Acorn/pages/home/controllers/homepage_controller.dart';
import 'package:Acorn/pages/initial/auth/login.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/loader.dart';
import 'package:Acorn/services/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final initialController = Get.put(InitialController());
  final loginController = Get.put(LoginController());
  final homePageController = Get.put(HomePageController());
  final calendarController = Get.put(CalendarController());

  @override
  void initState() {
    initialController.redirect(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: AppColors.primaryColor,
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Custom.header1(Strings.appName),
          const LoaderWidget(
            withMargins: true,
          ),
        ],
      )),
    ));
  }
}
