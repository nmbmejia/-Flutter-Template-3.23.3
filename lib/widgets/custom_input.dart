import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  const CustomInput(
      {super.key,
      this.text = '',
      this.hintText = '',
      this.onTextChanged,
      this.enabled = true});

  final String text;
  final String hintText;
  final bool enabled;
  //* Returns <T> if searchable, returns String if textfield
  final Function(dynamic data)? onTextChanged;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late TextEditingController textEditingController;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    runWidgetConfigurations();

    super.initState();
  }

  void runWidgetConfigurations() {
    textEditingController = TextEditingController();
    focusNode.requestFocus();
    textEditingController.selection = TextSelection(
        baseOffset: 0, extentOffset: textEditingController.value.text.length);
  }

  void onTextChanged(dynamic data) {
    if (widget.onTextChanged != null) {
      widget.onTextChanged!(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.enabled ? 1 : 0.25,
      child: TextFormField(
        enabled: widget.enabled,
        onTap: () {
          textEditingController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: textEditingController.value.text.length);
          focusNode.requestFocus();
        },
        onChanged: (value) => onTextChanged(value),
        controller: textEditingController,
        focusNode: focusNode,
        cursorColor: AppColors.whiteColor,
        cursorHeight: 24,
        cursorRadius: const Radius.elliptical(30, 30),
        style: Custom.header4('', isBold: true).style,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: Custom.header4('', isBold: true).style,

          prefixIcon: TextButton(
              onPressed: () {},
              child: Text(Constants.currency,
                  style: Custom.header4(
                    '',
                    isBold: true,
                    color: AppColors.greenColor,
                  ).style)),
          // prefixIcon: Padding(
          //   padding: const EdgeInsets.only(left: 15.0, right: 10),
          //   child: Custom.header4(Constants.currency,
          //       isBold: true, color: AppColors.greenColor),
          // ),
          enabled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide:
                BorderSide(color: Colors.transparent), // No border color
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide:
                BorderSide(color: Colors.transparent), // No border color
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide:
                BorderSide(color: Colors.transparent), // No border color
          ),
          filled: true,
          fillColor: AppColors.darkGrayColor,
        ),
      ),
    );
  }
}
