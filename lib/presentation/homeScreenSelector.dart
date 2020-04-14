import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/presentation/mainPage.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/ui/on_board.dart';
import 'package:tawasool/presentation/widgets/waiting_widget.dart';

import '../router.gr.dart';

class HomeScreenSelector extends StatefulWidget {
  @override
  _HomeScreenSelectorState createState() => _HomeScreenSelectorState();
}

class _HomeScreenSelectorState extends State<HomeScreenSelector> {
  bool isAuth;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((p) {
      // p.clear();
      isAuth = p.getString('credentials') != null;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading ? WaitingWidget() : isAuth ? MainPage() : OnBoard(),
      ),
    );
  }
}
