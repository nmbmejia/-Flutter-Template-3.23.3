import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:get/get.dart';

enum AppStates { initial, inRoom }

// ignore: must_be_immutable
class HomePageController extends GetxController {
  InitialController initialController = Get.find<InitialController>();
  RxBool anyDialogOpen = false.obs;
  RxInt selectedHeader = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
