import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/custom_datepicker.dart';
import 'package:Acorn/widgets/custom_input.dart';
import 'package:Acorn/widgets/standard_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnbPage1 extends StatefulWidget {
  const OnbPage1({super.key});

  @override
  State<OnbPage1> createState() => _OnbPage1State();
}

class _OnbPage1State extends State<OnbPage1> {
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
        Custom.header3('What is your name?', color: Colors.black87),
        CustomInput(
          hintText: 'Name',
          onTextChanged: (text) {
            initialController.name.value = text;
          },
        ),
        Custom.header3('When is your birthdate?', color: Colors.black87),
        VertSpace.ten(),
        CustomDatepicker(
          onChanged: (value) {
            initialController.birthDate.value = value;
          },
        ),
        VertSpace.ten(),
        Custom.header3('What is your skill level?', color: Colors.black87),
        VertSpace.ten(),
        ToggleButtons(
          direction: Axis.horizontal,
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < initialController.selectedSkill.length; i++) {
                initialController.selectedSkill[i] = i == index;
              }
            });
          },
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          selectedBorderColor: AppColors.primaryColor,
          selectedColor: Colors.white,
          fillColor: AppColors.primaryColor,
          color: Colors.black87,
          constraints: const BoxConstraints(
            minHeight: 50.0,
            minWidth: 100.0,
          ),
          isSelected: initialController.selectedSkill,
          children: const [
            Text('Beginner'),
            Text('Intermediate'),
            Text('Advanced')
          ],
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
