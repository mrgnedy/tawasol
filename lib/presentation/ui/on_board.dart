import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/FCM.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/data/models/setting_model.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/store/occasions_store.dart';
import 'package:tawasool/presentation/ui/department.dart';
import 'package:tawasool/presentation/mainPage.dart';
import 'package:tawasool/presentation/widgets/error_widget.dart';
import 'package:tawasool/presentation/widgets/idle_widget.dart';
import 'package:tawasool/presentation/widgets/waiting_widget.dart';
import '../../router.gr.dart';
import 'auth/login.dart';

class OnBoard extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

FirebaseNotifications fcmHandler;

class _OnBoardState extends State<OnBoard> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  TabController _tabController;

  @override
  void initState() {
    getSettings();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    final reactiveModel = Injector.getAsReactive<OccasionsStore>();
    // reactiveModel.setState((state) => state.getAllOccasions());
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
            alignment: FractionalOffset(0.5, 0.42),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Txt(
                  'المؤسسة العامة للتدريب التقنى والمهنى\nالكلية التقنية بأبها',
                  style: TxtStyle()
                    ..width(size.width * .7)
                    ..textAlign.center(),
                ),
                Txt(
                        'تواصل',
                        style: TxtStyle()
                          ..fontWeight(FontWeight.bold)
                          ..fontFamily('Kufi')
                          ..fontSize(26)
                          ..textColor(ColorsD.main)
                          ..alignment.center()
                          ..alignmentContent.center()
                          ..textAlign.center(),
                      ),
              ],
            ),
          ),
          nextBtn(),
          previousBtn(),
          skipBtn(),
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
                  setState(() {
                    currentIndex = _tabController.length - s - 1;
                    currentIndex == 2
                        ? nextTitle = 'إبدأ الآن'
                        : nextTitle = 'التالي';
                  });
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
                  child: buildAboutAppWidgets()),
            ),
          ),
        ],
      ),
    );
  }

  getSettings() => Injector.getAsReactive<AuthStore>()
      .setState((state) => state.getSettings());
  Widget aboutAppWidgets(SettingInfo data) {
    return TabBarView(
        controller: _tabController,
        children: List.generate(
            3,
            (index) => Txt(
                  '${data.toJson()['splash–${index + 1}']}',
                  style: TxtStyle()
                    ..alignment.center()
                    ..textAlign.center()
                    ..alignmentContent.center(),
                )));
  }

  Widget buildAboutAppWidgets() {
    final rm = Injector.getAsReactive<AuthStore>();
    return WhenRebuilder<AuthStore>(
        onIdle: () => IdleWidget(),
        onWaiting: () => WaitingWidget(),
        onError: (e) => OnErrorWidget(e, getSettings),
        onData: (data) => aboutAppWidgets(data.settingModel.data.first),
        models: [rm]);
  }

  String nextTitle = 'التالي';
  Widget nextBtn() {
    final isAuth = Injector.getAsReactive<AuthStore>().state.isAuth;
    return Align(
      alignment: FractionalOffset(0.08, 0.98),
      child: Txt(
        nextTitle,
        gesture: Gestures()
          ..onTap(() {
            // currentIndex = 0;
            currentIndex++;
            currentIndex == 2 ? nextTitle = 'إبدأ الآن' : nextTitle = 'التالي';
            currentIndex <= 2
                ? _tabController.animateTo(2 - currentIndex)
                : Router.navigator.pushReplacementNamed(
                    isAuth ? Router.mainPage : Router.loginPage);
            setState(() {});
          }),
        style: TxtStyle()..textColor(ColorsD.main),
      ),
    );
  }

  Widget skipBtn() {
    final isAuth = Injector.getAsReactive<AuthStore>().state.isAuth;
    return Align(
      alignment: FractionalOffset(0.08, 0.05),
      child: Txt(
        'تخطي',
        style: TxtStyle()
          ..textColor(ColorsD.main)
          ..textDirection(TextDirection.rtl),
        gesture: Gestures()
          ..onTap(() => Router.navigator.pushReplacementNamed(
              isAuth ? Router.mainPage : Router.loginPage)),
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
              currentIndex == 2
                  ? nextTitle = 'إبدأ الآن'
                  : nextTitle = 'التالي';

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
