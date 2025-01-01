import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/pages/initial/login.dart';
import 'package:Acorn/pages/initial/onboarding/onboarding.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/go.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/standard_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartupWidget extends StatefulWidget {
  const StartupWidget({super.key});

  @override
  State<StartupWidget> createState() => _StartupWidgetState();
}

class _StartupWidgetState extends State<StartupWidget> {
  late InitialController initialController;

  @override
  void initState() {
    super.initState();
    initialController = Get.find<InitialController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo-alt.png',
                      width: MediaQuery.of(context).size.width *
                          0.8, // Adjust logo size as needed
                    ),
                    Custom.body1('Stitching Knowledge. One Game at a time.',
                        color: Colors.grey)
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  customButton(
                    'Get Started',
                    boldText: true,
                    onPressed: () {
                      initialController.reinitializeOnboarding();
                      Go.to(const OnboardingPage());
                    },
                  ),
                  customButton(
                    'I already have an account',
                    boldText: false,
                    addSpaceOnTop: true,
                    backgroundColor: Color.fromARGB(255, 239, 239, 239),
                    textColor: AppColors.primaryColor,
                    onPressed: () {
                      initialController.reinitializeLogin();
                      Go.to(const LoginPage());
                    },
                  ),
                  VertSpace.thirty(),
                  VertSpace.thirty(),
                  VertSpace.thirty()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
