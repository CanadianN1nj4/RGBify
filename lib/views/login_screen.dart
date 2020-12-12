import 'package:flutter/material.dart';
import 'package:rgbify/model/AuthenticationService.dart';
import 'package:rgbify/theme/routes.dart';
import 'package:provider/provider.dart';


class Login extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final logo = Image.asset(
      "assets/rgbifylogo.png",
      fit: BoxFit.contain,
    );

    final emailField = TextFormField(
      //enabled: isSubmitting,
      controller: _emailController,
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

    final passwordField = Column(
      children: [
        TextFormField(
          //enabled: isSubmitting,
          controller: _passwordController,
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
        ),
        Padding(
          padding: EdgeInsets.all(2.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MaterialButton(
              child: Text(
                "Forgot Password?",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.white),
              ),
              onPressed: () {
                //TODO: Create forgot password popup
              },
            ),
          ],
        ),
      ],
    );

    final fields = Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [emailField, passwordField],
      ),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25),
      color: Colors.white,
      child: MaterialButton(
        //Button will always appear the same regardless of device
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text("Login",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),

        onPressed: () {
          context.read<AuthenticationService>().signInWithEmail(
            context: context,
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        },
      ),
    );

    final bottom = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        loginButton,
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Don't have an account?",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.white),
            ),
            MaterialButton(
              child: Text(
                "Sign Up",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.authRegister);
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
                  padding: EdgeInsets.only(bottom: 120),
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
