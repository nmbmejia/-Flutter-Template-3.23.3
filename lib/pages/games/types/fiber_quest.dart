import 'package:Acorn/pages/games/controllers/game_controller.dart';
import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FiberQuestGame extends StatefulWidget {
  const FiberQuestGame({super.key});

  @override
  State<FiberQuestGame> createState() => _FiberQuestGameState();
}

class _FiberQuestGameState extends State<FiberQuestGame> {
  final AppFlowyBoardController controller = AppFlowyBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move item from $fromIndex to $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
    },
  );

  @override
  void initState() {
    final group1 = AppFlowyGroupData(id: "To Do", name: 'To Do', items: [
      TextItem("Card 1"),
      TextItem("Card 2"),
    ]);
    final group2 =
        AppFlowyGroupData(id: "In Progress", name: 'In Progress', items: [
      TextItem("Card 3"),
      TextItem("Card 4"),
    ]);

    final group3 = AppFlowyGroupData(id: "Done", name: 'Done', items: []);

    controller.addGroup(group1);
    controller.addGroup(group2);
    controller.addGroup(group3);
    Get.lazyPut<GameController>(() => GameController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(builder: (gameController) {
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
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black.withOpacity(0.5)),
                  child: AppFlowyBoard(
                    controller: controller,
                    cardBuilder: (context, group, groupItem) {
                      final textItem = groupItem as TextItem;
                      return AppFlowyGroupCard(
                        key: ObjectKey(textItem),
                        child: Text(textItem.s),
                      );
                    },
                    groupConstraints: const BoxConstraints.tightFor(width: 240),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class TextItem extends AppFlowyGroupItem {
  final String s;
  TextItem(this.s);

  @override
  String get id => s;
}
