import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nimbus/pages/auth_phone_page.dart';
import 'package:nimbus/pages/dashboard_page.dart';

void main() => runApp(MyApp());

final FirebaseAuth _auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nimbus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<FirebaseUser>(
        stream: _auth.onAuthStateChanged,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return snapshot.hasData? DashboardPage() : AuthPhonePage();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      )
    );
  }
}
