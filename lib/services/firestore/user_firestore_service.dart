import 'package:Acorn/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserFirestoreService {
  // User
  static Future<bool> addUser({
    required String id,
    required String email,
    required String name,
    required DateTime birthDate,
    required String skillLevel,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users.doc(email).set({
        'id': id,
        'email': email,
        'name': name,
        'birth_date': Timestamp.fromDate(birthDate),
        'skill_level': skillLevel,
        'is_admin': false
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
        return (key == 'birth_date')
            ? debugPrint('$key: ${value.toDate()}\n')
            : debugPrint('$key: $value\n');
      });
      debugPrint('--------------------------');

      return UserModel(
          id: data['id'],
          email: data['email'],
          name: data['name'],
          birthDate: data['birth_date'].toDate(),
          skillLevel: data['skill_level'],
          isAdmin: data['is_admin'] ?? false);
    } catch (e) {
      debugPrint('user_firestore_service.dart::getUser():$e');
      return null;
    }
  }
}
