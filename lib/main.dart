import 'package:Acorn/firebase_options.dart';
import 'package:Acorn/pages/initial/initial.dart';
import 'package:Acorn/services/controllers/theme_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:Acorn/services/theme_service.dart';

//  fvm flutter pub global run rename setAppName --value "projectname"  --rename package
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String name = 'Hoypay';
  static const Color mainColor = Colors.deepPurple;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Get.put(ThemeController());

    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);

    // // Only after at least the action method is set, the notification events are delivered
    // AwesomeNotifications().setListeners(
    //     onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    //     onNotificationCreatedMethod:
    //         NotificationController.onNotificationCreatedMethod,
    //     onNotificationDisplayedMethod:
    //         NotificationController.onNotificationDisplayedMethod,
    //     onDismissActionReceivedMethod:
    //         NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StyledToast(
      locale: const Locale('fil', ''),
      child: GetMaterialApp(
        navigatorKey: MyApp.navigatorKey,
        theme: ThemeService.lightTheme,
        darkTheme: ThemeService.darkTheme,
        // themeMode: Get.find<ThemeController>().isDarkMode
        //     ? ThemeMode.dark
        //     : ThemeMode.light,
        themeMode: ThemeMode.dark,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown
          },
        ),
        supportedLocales: const [
          Locale('fil', ''),
          Locale('en', 'PH'),
          Locale('en', 'US'),
          Locale('fr', 'FR'),
          Locale('es', 'ES'),
        ],
        title: 'Acorn',
        home: const InitialPage(),
      ),
    );
  }
}
