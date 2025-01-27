import 'package:Acorn/pages/games/types/fiber_quest.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/go.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:Acorn/widgets/standard_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameIntroduction extends StatefulWidget {
  const GameIntroduction({super.key, required this.module});
  final dynamic module;

  @override
  State<GameIntroduction> createState() => GameIntroductionState();
}

class GameIntroductionState extends State<GameIntroduction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 239, 239, 239),
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.4),
          child: AppBar(
            toolbarHeight: 100,
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
            flexibleSpace: const Image(
              image: AssetImage('assets/images/gc_fiber.png'),
              fit: BoxFit.cover,
            ),
            centerTitle: true,
          ),
        ),
        body: SafeArea(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VertSpace.ten(),
                Custom.header1(widget.module['title'], color: Colors.black87),
                VertSpace.fifteen(),
                Custom.subheader1('Objective', color: Colors.black87),
                VertSpace.eight(),
                Custom.body1(widget.module['objective'],
                    color: Colors.black54, textAlign: TextAlign.center),
                VertSpace.thirty(),
                Custom.body1('Best personal score: 10pts',
                    color: Colors.black87),
                VertSpace.thirty(),
                customButton(
                  'Play Game',
                  boldText: true,
                  onPressed: () {
                    Go.to(const FiberQuestGame());
                  },
                ),
              ],
            ),
          ),
        )));
  }
}
