import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/pages/initial/onboarding/page1.dart';
import 'package:Acorn/pages/initial/onboarding/page2.dart';
import 'package:Acorn/widgets/stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late InitialController initialController;
  @override
  void initState() {
    initialController = Get.find<InitialController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 239, 239),
        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              CupertinoIcons.back,
              color: Colors.black87,
              size: 42,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => StepperWidget(
                activeStep: initialController.activeStep.value,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Center(
        child: PageView(
          controller: initialController.pageController,
          children: const [
            OnbPage1(),
            OnbPage2(),
          ],
          onPageChanged: (index) {
            initialController.activeStep.value = index;
          },
        ),
      )),
    );
  }
}
