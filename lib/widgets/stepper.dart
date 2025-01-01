import 'package:Acorn/services/app_colors.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

class StepperWidget extends StatefulWidget {
  const StepperWidget({super.key, this.activeStep = 0});

  final int activeStep;

  @override
  State<StepperWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      showTitle: false,
      disableScroll: true,
      fitWidth: true,
      padding: EdgeInsets.zero,
      activeStep: widget.activeStep,
      lineStyle: LineStyle(
        lineLength: 70,
        lineSpace: 0,
        lineType: LineType.normal,
        defaultLineColor: Colors.grey.withOpacity(0.5),
        finishedLineColor: AppColors.primaryColor,
      ),
      activeStepTextColor: Colors.black87,
      finishedStepTextColor: Colors.black87,
      internalPadding: 0,
      showLoadingAnimation: false,
      stepRadius: 8,
      showStepBorder: false,
      steps: [
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 7,
              backgroundColor: widget.activeStep >= 0
                  ? AppColors.primaryColor
                  : Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
        EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 7,
              backgroundColor: widget.activeStep >= 1
                  ? AppColors.primaryColor
                  : Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
