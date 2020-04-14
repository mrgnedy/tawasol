import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/presentation/homeScreenSelector.dart';
import 'package:tawasool/presentation/mainPage.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/store/occasions_store.dart';
import 'package:tawasool/presentation/ui/auth/login.dart';
import 'package:tawasool/presentation/ui/auth/verify.dart';
import 'package:tawasool/presentation/ui/department.dart';
import 'package:tawasool/presentation/ui/on_board.dart';
import 'package:tawasool/presentation/widgets/waiting_widget.dart';
import 'package:tawasool/router.gr.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuth;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((p) {
      isAuth = p.getString('credentials') != null;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Injector(
        inject: [
          Inject<AuthStore>(() => AuthStore(), isLazy: false),
          Inject<OccasionsStore>(() => OccasionsStore())
        ],
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
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

                accentColor: ColorsD.main,
                primarySwatch: MaterialColor(ColorsD.main.value, {
                  50: Color.fromRGBO(8, 8, 8, 50),
                  100: Color.fromRGBO(8, 8, 8, 100),
                  200: Color.fromRGBO(8, 8, 8, 200),
                  300: Color.fromRGBO(8, 8, 8, 300),
                  400: Color.fromRGBO(8, 8, 8, 400),
                  500: Color.fromRGBO(8, 8, 8, 500),
                  600: Color.fromRGBO(8, 8, 8, 600),
                  700: Color.fromRGBO(8, 8, 8, 700),
                  800: Color.fromRGBO(8, 8, 8, 800),
                  900: Color.fromRGBO(8, 8, 8, 900),
                }),
                // primarySwatch: Colors.blue,
                textTheme: TextTheme(
                    body1: TextStyle(height: 1.7, fontFamily: 'Cairo'))),
            home: HomeScreenSelector(),
          );
        });
  }
}
