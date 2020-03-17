import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/presentation/store/occasions_store.dart';
import 'package:tawasool/presentation/ui/department.dart';
import 'package:tawasool/presentation/mainPage.dart';
import '../../router.gr.dart';
import 'auth/login.dart';

class OnBoard extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    final reactiveModel = Injector.getAsReactive<OccasionsStore>();
    reactiveModel.setState((state) => state.getAllOccasions());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    globalContext = context;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: FractionalOffset(0.5, 0.3),
            child: Image.asset('assets/icons/logo.png'),
          ),
          Align(
            alignment: FractionalOffset(0.5, 0.41),
            child: Txt(
              'المؤسسة العامة للتدريب التقنى والمهنى\nالكلية التقنية بأبها',
              style: TxtStyle()
                ..width(size.width * .7)
                ..textAlign.center(),
            ),
          ),
          nextBtn(),
          previousBtn(),
          Align(
            alignment: FractionalOffset(0.5, 0.72),
            child: Container(
              width: 120,
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.zero,
                indicatorWeight: 0,
                labelPadding: EdgeInsets.zero,
                onTap: (s) {
                  print(s);
                  currentIndex = 0;
                },
                indicator: BoxDecoration(
                    color: ColorsD.main,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorsD.main)),
                tabs: List.generate(
                  3,
                  (_) => Container(
                    height: 20,
                    width: 15,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorsD.main)),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset(0.5, 0.6),
            child: Container(
              height: 100,
              child: Align(
                // height: 100,

                child: TabBarView(controller: _tabController, children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Txt(
                        'هذا النص قد يكون مثالا لنص',
                        style: TxtStyle()
                          ..fontWeight(FontWeight.bold)
                          ..alignment.center()
                          ..alignmentContent.center(),
                      ),
                      Txt(
                        'هذا النص وصف للتطبيق 1',
                        style: TxtStyle()
                          ..margin(horizontal: 10)
                          ..alignment.center()
                          ..textAlign.center()
                          ..alignmentContent.center(),
                      ),
                    ],
                  ),
                  Txt(
                    'هذا النص وصف للتطبيق 2',
                    style: TxtStyle()
                      ..alignment.center()
                      ..alignmentContent.center(),
                  ),
                  Txt(
                    'هذا النص وصف للتطبيق 3',
                    style: TxtStyle()
                      ..alignment.center()
                      ..alignmentContent.center(),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nextBtn() {
    return Align(
      alignment: FractionalOffset(0.08, 0.98),
      child: Txt(
        'التالي',
        gesture: Gestures()
          ..onTap(() {
            // currentIndex = 0;
            currentIndex++;
            currentIndex <= 2
                ? _tabController.animateTo(2 - currentIndex)
                : Router.navigator.pushReplacementNamed(Router.loginPage);
            setState(() {});
          }),
        style: TxtStyle()..textColor(ColorsD.main),
      ),
    );
  }

  Widget previousBtn() {
    return Visibility(
      visible: currentIndex != 0,
      child: Align(
        alignment: FractionalOffset(0.92, 0.98),
        child: Txt(
          'السابق',
          style: TxtStyle()..textColor(Colors.red),
          gesture: Gestures()
            ..onTap(() {
              // currentIndex = 0;
              currentIndex--;
              currentIndex >= 0
                  ? _tabController.animateTo(2 - currentIndex)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DepartmentsScreen()));
              setState(() {});
            }),
        ),
      ),
    );
  }
}
