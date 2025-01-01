import 'package:Acorn/pages/home/controllers/homepage_controller.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Get.lazyPut<HomePageController>(() => HomePageController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(builder: (homepageController) {
      return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              children: [],
            ),
          ),
        ),
      );
    });
  }
}
