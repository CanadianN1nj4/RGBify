import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgbify/model/AuthenticationService.dart';
import 'package:rgbify/theme/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rgbify/views/welcome_screen.dart';
import 'package:rgbify/views/controllers_screen.dart';
import 'package:rgbify/views/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) => context.read<AuthenticationService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        title: 'Loading Screen',
        routes: AppRoutes.define(),
        home: AuthenticationWrapper(),
      ),

    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
       return Controllers();
    }
    return WelcomeView();

  }
}