import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final initialController = Get.put(InitialController());

  @override
  void initState() {
    initialController.redirect(kDebugMode ? 1 : 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.5), // Darken the background
          ),
          // Foreground content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery.of(context).size.width *
                      0.8, // Adjust logo size as needed
                ),
                const LoaderWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
