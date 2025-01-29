// import 'package:awesome_notifications/awesome_notifications.dart';

// class CustomNotification {
//   static simple(
//       {String title = 'Payment reminder',
//       String body = 'Showing notification in 10 seconds...',
//       DateTime? scheduledDateTime}) async {
//     DateTime schedDateTime =
//         scheduledDateTime ?? DateTime.now().add(const Duration(seconds: 10));

//     AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: 10,
//           channelKey: 'basic_channel',
//           actionType: ActionType.Default,
//           category: NotificationCategory.Reminder,
//           notificationLayout: NotificationLayout.BigPicture,
//           autoDismissible: false,
//           wakeUpScreen: true,
//           title: title,
//           body: body,
//         ),
//         schedule: NotificationCalendar.fromDate(date: schedDateTime));
//   }
// }
