import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key});

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
        body: Container());
  }
}
