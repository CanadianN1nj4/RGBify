import 'package:flutter/material.dart';
import 'package:rgbify/views/commands_screen.dart';
import 'package:rgbify/views/controllers_screen.dart';
import 'package:rgbify/views/login_screen.dart';
import 'package:rgbify/views/register_screen.dart';
import 'package:rgbify/views/add_controller_screen.dart';
import 'package:rgbify/views/ChatPage.dart';

class AppRoutes {
  AppRoutes._();

  static const String authLogin = '/auth-login';
  static const String authRegister = '/auth-register';
  static const String controllers = '/controllers';
  static const String commands = '/commands';
  static const String addController = '/add-controller';
  static const String chatPage = '/ChatPage';

  static Map<String, WidgetBuilder> define() {
    return {
      authLogin: (context) => Login(),
      authRegister: (context) => Register(),
      controllers: (context) => Controllers(),
      commands: (context) => Commands(),
      addController: (context) => AddController(),
      chatPage: (context) => ChatPage(),
    };
  }
}
