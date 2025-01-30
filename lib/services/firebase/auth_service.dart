import 'package:Acorn/services/firestore/user_firestore_service.dart';
import 'package:Acorn/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Error during sign-in: ${e.code}');
      switch (e.code) {
        case 'user-not-found':
          CustomSnackbar().simple(
              'No account found with the provided email. Please check and try again.');
          break;
        case 'wrong-password':
          CustomSnackbar().simple('Incorrect password. Please try again.');
          break;
        case 'invalid-email':
          CustomSnackbar().simple(
              'The email address is invalid. Please enter a valid email.');
          break;
        case 'invalid-credential':
          CustomSnackbar()
              .simple('Invalid credentials provided. Please try again.');
          break;
        default:
          CustomSnackbar().simple(
              'Unable to sign in. Please contact support for assistance.');
          break;
      }
      return null;
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await UserFirestoreService.addUser(
        id: userCredential.user?.uid ?? '',
        email: email,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Error during registration: ${e.code}');
      switch (e.code) {
        case 'weak-password':
          CustomSnackbar().simple(
              'The password is too weak. Please choose a stronger one with at least 6 characters.');
          break;
        case 'email-already-in-use':
          CustomSnackbar().simple(
              'An account already exists with this email. Please use a different email or log in.');
          break;
        default:
          CustomSnackbar().simple(
              'Registration failed. Please contact support for assistance.');
          break;
      }
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Check if user is authenticated
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
