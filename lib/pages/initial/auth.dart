import 'package:Acorn/pages/home/homepage.dart';
import 'package:Acorn/pages/initial/startup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//* AuthGate checks for auth state changes, if auth is gone go to startup, otherwise go to homepage.

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const StartupWidget();
        }

        return const HomePage();
      },
    );
  }
}
