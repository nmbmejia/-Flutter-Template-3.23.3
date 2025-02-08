import 'package:Acorn/pages/initial/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//* AuthGate checks for auth state changes, if auth is gone go to startup, otherwise go to homepage.

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginPage();
        } else {
          debugPrint('AuthGate: ${snapshot.data?.email}');
          Get.find<LoginController>()
              .goToHomePage(savedEmail: snapshot.data?.email ?? '');
        }
        return const SizedBox();
      },
    );
  }
}
