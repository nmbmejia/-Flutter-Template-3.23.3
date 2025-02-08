import 'package:Acorn/models/user_model.dart';
import 'package:Acorn/services/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';

class UserFirestoreService {
  // User
  static Future<bool> addUser({
    required String id,
    required String email,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users.doc(email).set({
        'id': id,
        'email': email,
        'registered': Constants.dateToday,
        'last_login': Constants.dateToday,
      });
      return true;
    } catch (e) {
      debugPrint('user_firestore_service.dart::addUser():$e');
      return false;
    }
  }

  static Future<UserModel?> getUser(String email) async {
    debugPrint('--------------------------\n');
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(email).get();
      final data = snapshot.data() as Map<String, dynamic>;
      data.forEach((key, value) {
        if (key != 'device') {
          return (key == 'last_login' || key == 'registered')
              ? debugPrint(
                  '$key: ${DateFormat('MMMM, dd, yyyy').format(value.toDate())}\n')
              : debugPrint('$key: $value\n');
        }
      });
      data['device'].forEach((key, value) {
        if (key != 'utsname') {
          debugPrint('$key: $value\n');
        }
      });
      debugPrint('--------------------------');

      return UserModel(
        id: data['id'],
        email: data['email'],
        registered: data['registered'].toDate(),
      );
    } catch (e) {
      debugPrint('user_firestore_service.dart::getUser():$e');
      return null;
    }
  }

  static Future<bool> updateUserLastLogin({
    required String email,
    required DateTime lastLogin,
  }) async {
    try {
      if (email.isEmpty) {
        debugPrint(
            'user_firestore_service.dart::updateUser(): Email cannot be empty');
        return false;
      }

      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      final allInfo = deviceInfo.data;
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users
          .doc(email)
          .update({'last_login': lastLogin, 'device': allInfo});
      return true;
    } catch (e) {
      debugPrint('user_firestore_service.dart::updateUser():$e');
      return false;
    }
  }
}
