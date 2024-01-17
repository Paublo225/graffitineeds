import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:graffitineeds/auth/loginPage.dart';

import 'package:graffitineeds/helpers/styles.dart';

import 'package:graffitineeds/user/userpage.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, streamSnapshot) {
        // If Stream Snapshot has error
        if (streamSnapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${streamSnapshot.error}"),
            ),
          );
        }

        // Connection state active - Do the user login check inside the
        // if statement
        if (streamSnapshot.connectionState == ConnectionState.active) {
          // Get the user
          User? _user = streamSnapshot.data as User?;

          // If the user is null, we're not logged in
          if (_user == null || !_user.emailVerified) {
            // user not logged in, head to login
            return LoginPage();
          } else {
            // The user is logged in, head to homepage
            return UserPage();
          }
        }

        // Checking the auth state - Loading
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
            ),
          ),
        );
      },
    );
  }
}
