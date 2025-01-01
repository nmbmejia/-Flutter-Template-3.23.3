import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/custom_input.dart';
import 'package:Acorn/widgets/standard_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late InitialController initialController;

  @override
  void initState() {
    super.initState();
    initialController = Get.find<InitialController>();
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
        centerTitle: true,
      ),
      body: SafeArea(
          child: Center(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          VertSpace.thirty(),
          customButton(
            'Sign In',
            boldText: true,
            onPressed: () {
              initialController.login();
            },
          ),
        ],
      ))),
    );
  }
}
