import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameTemplate extends StatefulWidget {
  const GameTemplate({super.key});

  @override
  State<GameTemplate> createState() => _GameTemplateState();
}

class _GameTemplateState extends State<GameTemplate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/game_cover1.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
        ),
        body: Container(),
      ),
    );
  }
}
