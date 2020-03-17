// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:tawasool/presentation/ui/on_board.dart';
import 'package:tawasool/presentation/mainPage.dart';
import 'package:tawasool/presentation/ui/auth/login.dart';
import 'package:tawasool/presentation/ui/new_event.dart';

class Router {
  static const onBoard = '/';
  static const mainPage = '/main-page';
  static const loginPage = '/login-page';
  static const addEvent = '/add-event';
  static final navigator = ExtendedNavigator();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.onBoard:
        return MaterialPageRoute<dynamic>(
          builder: (_) => OnBoard(),
          settings: settings,
        );
      case Router.mainPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => MainPage(),
          settings: settings,
        );
      case Router.loginPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => LoginPage(),
          settings: settings,
        );
      case Router.addEvent:
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddEvent(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
