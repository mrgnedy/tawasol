import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/api_utils.dart';

import 'package:tawasool/core/utils.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/ui/all_occasions_page.dart';
import 'package:tawasool/presentation/ui/department.dart';
import 'package:tawasool/presentation/ui/on_board.dart';
import 'package:tawasool/presentation/widgets/add_event_btn.dart';
import 'package:tawasool/presentation/widgets/event_card.dart';
import 'package:tawasool/router.gr.dart';
import 'package:toast/toast.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../FCM.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

BuildContext globalContext;

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  AnimationController anim;
  Animation<Offset> offsetAnim;
  Animation<double> transformAnim;
  PageController _pageController;
  Timer time;
  onMessage(String msg) {
    print('xffffffff');
    time = Timer(Duration(seconds: 1), () {
      if (time != null && !time.isActive) {
        AlertDialogs.success(context: context, content: 'لديك إشعار جديد!')
            .then((b) {
          if (b == true) Router.navigator.pushNamed(Router.notificationPage);
        });
        setState(() {
          notificationCount++;
        });
        Injector.getAsReactive<AuthStore>()
            .setState((state) => state.getNotification());
      }
    });
  }

  onLaunch(String msg) {
    Future.delayed(Duration(seconds: 1), () => print('in onLaunch'));
    time = Timer(Duration(seconds: 1), () {
      if (time != null && !time.isActive) {
        AlertDialogs.success(context: context, content: 'لديك إشعار جديد!')
            .then((b) {
          if (b == true) Router.navigator.pushNamed(Router.notificationPage);
        });
        setState(() {
          notificationCount++;
        });
        Injector.getAsReactive<AuthStore>()
            .setState((state) => state.getNotification());
      }
    });
    print(msg);
  }

  onResume(String msg) {
    print(msg);
    time = Timer(Duration(seconds: 1), () {
      if (time != null && !time.isActive) {
        AlertDialogs.success(context: context, content: 'لديك إشعار جديد!')
            .then((b) {
          if (b == true) Router.navigator.pushNamed(Router.notificationPage);
        });
        setState(() {
          notificationCount++;
        });
        Injector.getAsReactive<AuthStore>()
            .setState((state) => state.getNotification());
      }
    });
  }

  @override
  void initState() {
    fcmHandler = FirebaseNotifications.handler(onMessage, onLaunch, onResume);
    _pageController = PageController(initialPage: 0, keepPage: true);
    anim =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    offsetAnim = Tween<Offset>(begin: Offset.zero, end: Offset(-0.4, 0))
        .animate(CurvedAnimation(parent: anim, curve: Curves.fastOutSlowIn));
    transformAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: anim, curve: Curves.bounceInOut));
    // offsetAnimBack = Tween<Offset>(end: Offset.zero, begin: Offset(-0.4, 0))
    //     .animate(CurvedAnimation(parent: anim, curve: Curves.easeIn));
    // TODO: implement initState
    super.initState();
  }

  double zRotation = 0;
  Curve rotationCurve = Curves.easeIn;
  double borderRadius = 0;
  int notificationCount = 0;
  @override
  Widget build(BuildContext context) {
    // print(Injector.getAsReactive<AuthStore>().state.credentials.data.id);
    final size = MediaQuery.of(context).size;
    final creds = Injector.getAsReactive<AuthStore>().state.credentials?.data;
    // print(Injector.getAsReactive<AuthStore>().state.isAuth);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsD.main,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: FractionalOffset(0.87, 0.08),
              child: creds?.image == null
                  ? Image.asset('assets/icons/logo.png')
                  : CachedNetworkImage(
                      imageUrl: '${APIs.imageBaseUrl}profile/${creds.image}',
                      imageBuilder: (context, imageB) => Container(
                        height: size.height / 8,
                        width: size.height / 8,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageB, fit: BoxFit.cover)),
                      ),
                    ),
            ),
            Align(
              alignment: FractionalOffset(0.95, 0.5),
              child: Container(
                width: size.width / 2.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: Injector.getAsReactive<AuthStore>()
                              .state
                              .credentials ==
                          null,
                      child: drawerItem(
                          'تسجيل الدخول',
                          'arrow',
                          () => Router.navigator.pushNamedAndRemoveUntil(
                              Router.loginPage,
                              (Route<dynamic> route) => false)),
                    ),
                    drawerItem(
                        'الصفحة الشخصية',
                        'user',
                        () => Router.navigator.pushNamed(Router.profilePage),
                        true),
                    drawerItem(
                        'مناسباتي',
                        'event',
                        () => Router.navigator.pushNamed(Router.myOccasions),
                        true),
                    drawerItem('تواصل معنا', 'phone',
                        () => Router.navigator.pushNamed(Router.contactUsPage)),
                    drawerItem(
                        'الشروط والأحكام',
                        'Solid',
                        () => Router.navigator.pushNamed(Router.aboutPage,
                            arguments: AboutPageArguments(data: 'conditions'))),
                    drawerItem(
                        'من نحن',
                        'question',
                        () => Router.navigator.pushNamed(Router.aboutPage,
                            arguments: AboutPageArguments(data: 'who'))),
                    drawerItem('مشاركة التطبيق', 'share',
                        () => Share.share('https://play.google.com/store/apps/details?id=com.skinnyg.tawasool')),
                    Visibility(
                      visible: Injector.getAsReactive<AuthStore>()
                              .state
                              .credentials !=
                          null,
                      child: drawerItem('تسجيل الخروج', 'arrow', () {
                        Injector.getAsReactive<AuthStore>().state.credentials =
                            null;
                        SharedPreferences.getInstance().then((pref) {
                          pref.clear();
                          Router.navigator.pushNamedAndRemoveUntil(
                              Router.loginPage,
                              (Route<dynamic> route) => false);
                        });
                      }),
                    ),
                  ],
                ),
              ),
            ),
            SlideTransition(
              position: offsetAnim,
              child: AnimatedContainer(
                height: size.height,
                width: size.width,
                curve: rotationCurve,
                duration: Duration(milliseconds: 600),
                color: ColorsD.main,
                alignment: Alignment.centerRight,
                transform: Matrix4.rotationZ(zRotation),
                // fit: StackFit.expand,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Scaffold(
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {},
                      isExtended: true,
                      backgroundColor: Colors.transparent,
                      child: addEventBtn(),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    backgroundColor: Colors.grey[300],
                    bottomNavigationBar: bottomNavigationBar(),
                    body: NestedScrollView(
                      // physics: NeverScrollableScrollPhysics(),
                      headerSliverBuilder: (context, scroll) => [
                        SliverPersistentHeader(
                            floating: true,
                            pinned: true,
                            delegate: sliverHeaderWidget())
                      ],
                      body: Directionality(
                        textDirection: TextDirection.rtl,
                        child: PageView(
                          controller: _pageController,
                          children: <Widget>[
                            AllOccasionsPage(),
                            // Container(),
                            DepartmentsScreen()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isOpen = false;
  drawerBtn() {
    if (isOpen) {
      anim.animateBack(0,
          duration: Duration(milliseconds: 600), curve: Curves.fastOutSlowIn);
      rotationCurve = Curves.fastOutSlowIn;
      zRotation = 0.0;
      borderRadius = 0;
    } else {
      rotationCurve = Curves.fastOutSlowIn;
      anim.forward();
      borderRadius = 20;
      zRotation = 0.2;
    }
    isOpen = !isOpen;
    setState(() {});
  }

  Widget addEventBtn() {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Router.navigator.pushNamed(Router.addEvent),
      // bottom: 36,
      // left: size.width / 2 - 20,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          // height: 36 * 1.5,
          // width: 40 * 1.5,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CustomPaint(
                painter: DiamondAddPainter(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(
                  Icons.add_circle,
                  color: ColorsD.main,
                  size: 40,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerItem(String title, String iconName, Function callback,
      [bool authDependent]) {
    bool isAuth;
    if (authDependent == true)
      isAuth = Injector.getAsReactive<AuthStore>().state.credentials != null;
    else
      isAuth = true;
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: isAuth
              ? callback
              : () => Toast.show('من فضلك سجل الدخول', context),
          child: Container(
            width: size.width / 2.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Txt(
                  '$title',
                  style: TxtStyle()..textColor(Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(5),
                    child: Image.asset(
                      'assets/icons/$iconName.png',
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: Colors.white),
      ],
    );
  }

  double currentPage = 1;
  Widget bottomNavigationBar() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BottomNavigationBar(
        selectedItemColor: ColorsD.main,
        unselectedItemColor: Colors.white,
        onTap: (page) => {
          _pageController.animateToPage(page,
              duration: Duration(milliseconds: 200),
              curve: Curves.fastLinearToSlowEaseIn),
          currentPage = _pageController.page,
          setState(() {})
        },
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Image.asset(
                'assets/icons/home-run.png',
                color: currentPage == 1 ? ColorsD.main : Colors.black,
              ),
            ),
            title: Txt('الرئيسية',
                style: TxtStyle()
                  ..fontFamily('Cairo')
                  ..padding(left: 30)),
          ),
          // BottomNavigationBarItem(
          //   icon: Container(),
          //   title: Text(''),
          // ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Image.asset(
                'assets/icons/menu1.png',
                color: currentPage == 0 ? ColorsD.main : Colors.black,
              ),
            ),
            title: Txt('الاقسام',
                style: TxtStyle()
                  ..fontFamily('Cairo')
                  ..padding(right: 30)),
          ),
        ],
      ),
    );
  }

  SliverPersistentHeaderDelegate sliverHeaderWidget() {
    final size = MediaQuery.of(context).size;
    return SliverHeader(
      maHeight: size.height / 4.1,
      minHeight: size.height / 7,
      child: LayoutBuilder(
        builder: (context, constraints) {
          print(constraints.biggest.height);
          return Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      child: notificationWidget(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset('assets/icons/logo.png'),
                    ),
                    InkWell(
                      radius: 50,
                      onTap: drawerBtn,
                      child: AnimatedIcon(
                        icon: AnimatedIcons.menu_arrow,
                        progress: transformAnim,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: constraints.biggest.height == size.height / 4.1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Txt(
                        'المؤسسة العامة للتدريب التقنى والمهنى\nالكلية التقنية بأبها',
                        style: TxtStyle()
                          ..alignment.center()
                          ..alignmentContent.center()
                          ..textAlign.center(),
                      ),
                      Txt(
                        'تواصل',
                        style: TxtStyle()
                          ..fontWeight(FontWeight.bold)
                          ..fontFamily('Kufi')
                          ..fontSize(24)
                          ..textColor(ColorsD.main)
                          ..alignment.center()
                          ..alignmentContent.center()
                          ..textAlign.center(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget notificationWidget() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        InkWell(
            onTap: () => Router.navigator.pushNamed(Router.notificationPage),
            child: Icon(Icons.notifications)),
        Visibility(
          visible: notificationCount > 0,
          child: Txt('$notificationCount',
              style: TxtStyle()
                ..textColor(Colors.white)
                ..circle()
                ..alignmentContent.center()
                ..alignment.coordinate(0.6, -0.5)
                ..background.color(Colors.red)
                ..height(18)
                ..width(18)),
        )
      ],
    );
  }
}

class SliverHeader extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maHeight;
  final double minHeight;

  SliverHeader({this.maHeight = 100, this.minHeight = 80, this.child});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return child;
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => maHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}
