import 'package:bithack_tripsync/Mode.dart';
import 'package:bithack_tripsync/Sign%20in/Signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while checking the authentication state.
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            // If a user is authenticated, navigate to the Mode widget.
            return SignIn();
          } else {
            // If no user is authenticated, display the SignIn widget.
            return SignIn();
          }
        },
      ),
    );
  }
}
