// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:desktop_webview_auth/desktop_webview_auth_web.dart';
import 'package:device_info_plus/src/device_info_plus_web.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:holdable_button/holdable_button_web.dart';
import 'package:permission_handler_html/permission_handler_html.dart';
import 'package:platform_device_id_web/platform_device_id_web.dart';
import 'package:sensors_plus/src/sensors_plus_web.dart';
import 'package:share_plus/src/share_plus_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  FirebaseFirestoreWeb.registerWith(registrar);
  DesktopWebviewAuthWeb.registerWith(registrar);
  DeviceInfoPlusWebPlugin.registerWith(registrar);
  FirebaseAuthWeb.registerWith(registrar);
  FirebaseCoreWeb.registerWith(registrar);
  FluttertoastWebPlugin.registerWith(registrar);
  HoldableButtonWeb.registerWith(registrar);
  WebPermissionHandler.registerWith(registrar);
  PlatformDeviceIdWebPlugin.registerWith(registrar);
  WebSensorsPlugin.registerWith(registrar);
  SharePlusWebPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
