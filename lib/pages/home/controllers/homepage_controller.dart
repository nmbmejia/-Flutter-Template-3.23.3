import 'package:Acorn/models/reminder_model.dart';
import 'package:Acorn/pages/initial/controllers/intial_controller.dart';
import 'package:Acorn/services/constants.dart';
import 'package:Acorn/services/custom_functions.dart';
import 'package:get/get.dart';

enum AppStates { initial, inRoom }

// ignore: must_be_immutable
class HomePageController extends GetxController {
  InitialController initialController = Get.find<InitialController>();
  RxBool anyDialogOpen = false.obs;
  RxInt selectedHeader = 0.obs;

  RxList<Reminder> allReminders = <Reminder>[].obs;
  RxList<Reminder> monthReminders = <Reminder>[].obs;

  getMonthReminders() async {
    monthReminders.value =
        CustomFunctions.getRemindersForMonth(allReminders, Constants.dateToday);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
