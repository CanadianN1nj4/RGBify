import 'package:flutter/material.dart';
import 'package:rgbify/theme/routes.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();

  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final logo = Image.asset(
      "assets/rgbifylogo.png",
      fit: BoxFit.contain,
    );

    final nameField = TextFormField(
      //enabled: isSubmitting,
      controller: _nameController,
      keyboardType: TextInputType.name,
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: "John Doe",
        labelText: "Name",
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        labelStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );

    final emailField = TextFormField(
      //enabled: isSubmitting,
      controller: _emailController,
      cursorColor: Colors.white,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: "yourEmail@example.com",
        labelText: "Email",
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        labelStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );

    final passwordField = TextFormField(
      //enabled: isSubmitting,
      controller: _passwordController,
      cursorColor: Colors.white,
      //keyboardType: TextInputType.visiblePassword,
      style: TextStyle(
        color: Colors.white,
      ),
      obscureText: true,
      decoration: InputDecoration(
        hintText: "........",
        labelText: "Password",
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        labelStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );

    final repasswordField = TextFormField(
      //enabled: isSubmitting,
      controller: _repasswordController,
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
      ),
      obscureText: true,
      decoration: InputDecoration(
        hintText: "........",
        labelText: "Retype Password",
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        labelStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );

    final fields = Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          nameField,
          emailField,
          passwordField,
          repasswordField,
        ],
      ),
    );

    final signupButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25),
      color: Colors.white,
      child: MaterialButton(
        //Button will always appear the same regardless of device
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text("Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        onPressed: () async {
          //TODO: handle repasword missmatch
          try {
            UserCredential userCredential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );
            Navigator.of(context).pushNamed(AppRoutes.controllers);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              print('The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
              print('The account already exists for that email.');
            } else {
              //No errors. Navigate to controllers screen
              print('Other Error');
            }
          } catch (e) {
            print(e);
          }
        },
      ),
    );

    final bottom = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        signupButton,
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Already have an account?",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.white),
            ),
            MaterialButton(
              child: Text(
                "Login",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.authLogin);
              },
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.orange,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(36),
          child: Container(
            height: mq.size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                logo,
                fields,
                Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
