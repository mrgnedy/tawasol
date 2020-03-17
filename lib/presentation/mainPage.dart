import 'dart:math';

import 'package:division/division.dart';
import 'package:flutter/material.dart';

import 'package:tawasool/core/utils.dart';
import 'package:tawasool/presentation/ui/all_occasions_page.dart';
import 'package:tawasool/presentation/ui/department.dart';
import 'package:tawasool/presentation/widgets/add_event_btn.dart';
import 'package:tawasool/presentation/widgets/event_card.dart';
import 'package:tawasool/router.gr.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

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

  @override
  void initState() {
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
  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsD.main,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: FractionalOffset(0.9, 0.08),
              child: Image.asset('assets/icons/logo.png'),
            ),
            Align(
              alignment: FractionalOffset(0.95, 0.4),
              child: Container(
                width: size.width / 2.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    drawerItem('تسجيل الدخول', 'arrow', null),
                    Divider(color: Colors.white),
                    drawerItem('الصحة الشخصية', 'user', null),
                    Divider(color: Colors.white),
                    drawerItem('مناسباتي', 'event', null),
                    Divider(color: Colors.white),
                    drawerItem('تواصل معنا', 'phone', null),
                    Divider(color: Colors.white),
                    drawerItem('الشروط والأحكام', 'Solid', null),
                    Divider(color: Colors.white),
                    drawerItem('من نحن', 'question', null),
                    Divider(color: Colors.white),
                    drawerItem('مشاركة التطبيق', 'Path 314', null),
                    Divider(color: Colors.white),
                    drawerItem('تسجيل الخروج', 'arrow', null),
                    Divider(color: Colors.white),
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
                          delegate: SliverHeader(
                              child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Icon(Icons.notifications),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
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
                          )),
                        )
                      ],
                      body: Directionality(
                        textDirection: TextDirection.rtl,
                        child: PageView(
                          controller: _pageController,
                          children: <Widget>[
                            AllOccasionsPage(),
                            Container(),
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

  Widget drawerItem(String title, String iconName, Function callback) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: callback,
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
    );
  }

  Widget bottomNavigationBar() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BottomNavigationBar(
        selectedItemColor: ColorsD.main,
        unselectedItemColor: Colors.white,
        onTap: (page) => _pageController.animateToPage(page,
            duration: Duration(milliseconds: 200),
            curve: Curves.fastLinearToSlowEaseIn),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/home-run.png'),
            title: Txt('الرئيسية', style: TxtStyle()..fontFamily('Cairo')),
          ),
          BottomNavigationBarItem(
            icon: Container(),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/menu1.png'),
            title: Txt('الاقسام', style: TxtStyle()..fontFamily('Cairo')),
          ),
        ],
      ),
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
