import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/custom_input.dart';
import 'package:Acorn/widgets/standard_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnbPage2 extends StatefulWidget {
  const OnbPage2({super.key});

  @override
  State<OnbPage2> createState() => _OnbPage2State();
}

class _OnbPage2State extends State<OnbPage2> {
  late InitialController initialController;

  @override
  void initState() {
    super.initState();
    initialController = Get.find<InitialController>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Custom.header3('Your login details', color: Colors.black87),
        VertSpace.thirty(),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.10),
          child: Row(
            children: [
              Custom.header3('Email', color: Colors.black87),
            ],
          ),
        ),
        CustomInput(
          hintText: '',
          prefixIcon: Icon(
            CupertinoIcons.profile_circled,
            color: AppColors.darkGrayColor.withOpacity(0.2),
            size: 30,
          ),
          onTextChanged: (text) {
            initialController.email.value = text;
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.10),
          child: Row(
            children: [
              Custom.header3('Password', color: Colors.black87),
            ],
          ),
        ),
        CustomInput(
          hintText: '',
          obscureText: true,
          prefixIcon: Icon(
            CupertinoIcons.lock_circle,
            color: AppColors.darkGrayColor.withOpacity(0.2),
            size: 30,
          ),
          onTextChanged: (text) {
            initialController.password.value = text;
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.10),
          child: Row(
            children: [
              Custom.header3('Confirm Password', color: Colors.black87),
            ],
          ),
        ),
        CustomInput(
          hintText: '',
          obscureText: true,
          prefixIcon: Icon(
            CupertinoIcons.lock_circle,
            color: AppColors.darkGrayColor.withOpacity(0.2),
            size: 30,
          ),
          onTextChanged: (text) {
            initialController.confirmPassword.value = text;
          },
        ),
        VertSpace.thirty(),
        customButton(
          'Continue',
          boldText: true,
          onPressed: () {
            initialController.nextOnboardingStep();
          },
        ),
      ],
    );
  }
}
