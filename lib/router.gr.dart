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
import 'package:tawasool/presentation/map.dart';
import 'package:tawasool/presentation/ui/drawerPages/profile_page.dart';
import 'package:tawasool/presentation/ui/drawerPages/contact_us.dart';
import 'package:tawasool/presentation/ui/occasion_details.dart';
import 'package:tawasool/data/models/all_occasions_model.dart';
import 'package:tawasool/presentation/ui/drawerPages/my_occasions.dart';
import 'package:tawasool/presentation/ui/auth/notification.dart';
import 'package:tawasool/presentation/ui/drawerPages/about_page.dart';
import 'package:tawasool/presentation/ui/auth/verify.dart';

class Router {
  static const onBoard = '/';
  static const mainPage = '/main-page';
  static const loginPage = '/login-page';
  static const addEvent = '/add-event';
  static const map = '/map';
  static const profilePage = '/profile-page';
  static const contactUsPage = '/contact-us-page';
  static const occasionDetails = '/occasion-details';
  static const myOccasions = '/my-occasions';
  static const notificationPage = '/notification-page';
  static const aboutPage = '/about-page';
  static const verifyUserScreen = '/verify-user-screen';
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
        return CupertinoPageRoute<dynamic>(
          builder: (_) => MainPage(),
          settings: settings,
          maintainState: true,
        );
      case Router.loginPage:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => LoginPage(),
          settings: settings,
          maintainState: true,
        );
      case Router.addEvent:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => AddEvent(),
          settings: settings,
          maintainState: true,
        );
      case Router.map:
        if (hasInvalidArgs<Function>(args)) {
          return misTypedArgsRoute<Function>(args);
        }
        final typedArgs = args as Function;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => Map(typedArgs),
          settings: settings,
          maintainState: true,
        );
      case Router.profilePage:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => ProfilePage(),
          settings: settings,
          maintainState: true,
        );
      case Router.contactUsPage:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => ContactUsPage(),
          settings: settings,
          maintainState: true,
        );
      case Router.occasionDetails:
        if (hasInvalidArgs<OccasionDetailsArguments>(args)) {
          return misTypedArgsRoute<OccasionDetailsArguments>(args);
        }
        final typedArgs =
            args as OccasionDetailsArguments ?? OccasionDetailsArguments();
        return CupertinoPageRoute<dynamic>(
          builder: (_) =>
              OccasionDetails(occasion: typedArgs.occasion, id: typedArgs.id),
          settings: settings,
          maintainState: true,
        );
      case Router.myOccasions:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => MyOccasions(),
          settings: settings,
          maintainState: true,
        );
      case Router.notificationPage:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => NotificationPage(),
          settings: settings,
          maintainState: true,
        );
      case Router.aboutPage:
        if (hasInvalidArgs<AboutPageArguments>(args)) {
          return misTypedArgsRoute<AboutPageArguments>(args);
        }
        final typedArgs = args as AboutPageArguments ?? AboutPageArguments();
        return CupertinoPageRoute<dynamic>(
          builder: (_) => AboutPage(key: typedArgs.key, data: typedArgs.data),
          settings: settings,
          maintainState: true,
        );
      case Router.verifyUserScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => VerifyUserScreen(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//OccasionDetails arguments holder class
class OccasionDetailsArguments {
  final Occasion occasion;
  final int id;
  OccasionDetailsArguments({this.occasion, this.id});
}

//AboutPage arguments holder class
class AboutPageArguments {
  final Key key;
  final String data;
  AboutPageArguments({this.key, this.data});
}
