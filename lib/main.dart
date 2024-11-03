import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:Acorn/pages/initial/initial.dart';
import 'package:google_fonts/google_fonts.dart';

//  fvm flutter pub global run rename setAppName --value "projectname"  --rename package
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StyledToast(
      locale: const Locale('fil', ''),
      child: GetMaterialApp(
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
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context)
                .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
          ),
        ),
        home: const InitialPage(),
      ),
    );
  }
}
