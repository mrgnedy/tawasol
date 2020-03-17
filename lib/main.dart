import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/presentation/mainPage.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/store/occasions_store.dart';
import 'package:tawasool/presentation/ui/auth/login.dart';
import 'package:tawasool/presentation/ui/department.dart';
import 'package:tawasool/presentation/ui/on_board.dart';
import 'package:tawasool/router.gr.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Injector(
        inject: [
          Inject<AuthStore>(() => AuthStore()),
          Inject<OccasionsStore>(() => OccasionsStore())
        ],
        builder: (context) {
          return MaterialApp(
            navigatorKey: Router.navigator.key,
            onGenerateRoute: Router.onGenerateRoute,
            title: 'Flutter Demo',
            theme: ThemeData(
                scaffoldBackgroundColor: ColorsD.backGroundColor,
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
                textTheme: TextTheme(
                    body1: TextStyle(height: 1.7, fontFamily: 'Cairo'))),
            home: OnBoard(),
          );
        });
  }
}
