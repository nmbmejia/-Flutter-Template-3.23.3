import 'package:get/get.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';

enum AppStates { initial, inRoom }

// ignore: must_be_immutable
class HomePageController extends GetxController {
  InitialController initialController = Get.find<InitialController>();
  final RxList<bool> selectedAccount = [true, false].obs;
  final RxBool isAdmin = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
