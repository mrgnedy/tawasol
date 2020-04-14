import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/data/models/notifications_model.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/widgets/error_widget.dart';
import 'package:tawasool/presentation/widgets/idle_widget.dart';
import 'package:tawasool/presentation/widgets/waiting_widget.dart';
import 'package:tawasool/router.gr.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final reactiveModel = Injector.getAsReactive<AuthStore>();
  int loadAt = -1;
  Widget onDataWidget(UserNotificationModel userNotificationModel) {
    final size = MediaQuery.of(context).size;
    return ListView(
      shrinkWrap: true,
      children: List.generate(
          reactiveModel.state.notifications.data.notification.length, (index) {
        final notification =
            reactiveModel.state.notifications.data.notification[index];
        return loadAt == index
            ? WaitingWidget()
            : Dismissible(
                confirmDismiss: (d) async {
                  return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            titlePadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: ColorsD.main)),
                            title: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                                child: Container(
                                  color: ColorsD.main,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      ),
                                      Txt(
                                        'مسح الإشعار',
                                        style: TxtStyle()
                                          ..background.color(ColorsD.main)
                                          ..textColor(Colors.white)
                                          ..textAlign.right()
                                          ..fontFamily('Cairo'),
                                      ),
                                    ],
                                  ),
                                )),
                            actions: <Widget>[
                              Container(
                                width: size.width * 0.7,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Expanded(
                                        child: Txt('مسح',
                                            gesture: Gestures()
                                              ..onTap(() =>
                                                  Router.navigator.pop(true)),
                                            style: StylesD.tawasolBtnStyle)),
                                    Expanded(
                                        child: Txt('رجوع',
                                            gesture: Gestures()
                                              ..onTap(() =>
                                                  Router.navigator.pop(false)),
                                            style: StylesD.tawasolBtnStyle)),
                                  ],
                                ),
                              )
                            ],
                          ));
                },
                key: UniqueKey(),
                // resizeDuration: Duration(seconds: 0),
                movementDuration: Duration(seconds: 2),
                onResize: () {},
                onDismissed: (s) {
                  setState(() {
                    loadAt = index;
                  });
                  print(reactiveModel.state.credentials.data.apiToken);
                  reactiveModel
                      .setState(
                          (state) => state.deleteNotification(notification.id))
                      .then((_) => reactiveModel.setState((state) =>
                          state.getNotification().then((_) => setState(() {
                                loadAt = -1;
                              }))));
                },
                child: notificationCard(notification));
      }),
    );
  }

  Widget notificationCard(notification) {
    final size = MediaQuery.of(context).size;
    return Parent(
      gesture: Gestures()
        ..onTap(() => Router.navigator.pushNamed(Router.occasionDetails,
            arguments: OccasionDetailsArguments(id: notification.occasionId))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Txt('${notification.content}',
              style: TxtStyle()
                ..alignment.centerRight()
                ..textAlign.right()
                ..textDirection(TextDirection.rtl)
                ..textColor(ColorsD.main)),
          Txt(
            '${notification.createdAt}',
            style: TxtStyle()..alignment.centerLeft(),
          )
        ],
      ),
      style: ParentStyle()
        ..alignmentContent.centerRight()
        ..elevation(10, color: ColorsD.elevationColor)
        ..width(size.width * 0.7)
        // ..height(size.height / 18)
        ..minHeight(size.height / 12)
        ..margin(all: 12)
        ..borderRadius(all: 12)
        ..padding(horizontal: 12, top: 12)
        ..background.color(Colors.white),
    );
  }

  @override
  void initState() {
    Injector.getAsReactive<AuthStore>()
        .setState((state) => state.getNotification());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Injector.getAsReactive<AuthStore>().resetToHasData();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reactiveModel = Injector.getAsReactive<AuthStore>();
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Txt(
                      'رجوع',
                      style: TxtStyle()
                        ..textColor(ColorsD.main)
                        ..width(size.width / 10),
                      gesture: Gestures()..onTap(() => Router.navigator.pop()),
                    ),
                    Image.asset('assets/icons/logo.png'),
                    Txt('', style: TxtStyle()..width(size.width / 10)),
                  ],
                ),
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
                    ..textColor(ColorsD.main)
                    ..alignment.center()
                    ..alignmentContent.center()
                    ..textAlign.center(),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(size.height / 4),
        ),
        backgroundColor: ColorsD.backGroundColor,
        body: Align(
          alignment: FractionalOffset(0.5, 0.05),
          child: !reactiveModel.state.isAuth
              ? Txt('من فضلك قم بتسجيل الدخول')
              : WhenRebuilder<AuthStore>(
                  models: <ReactiveModel>[reactiveModel],
                  onData: (data) {
                    return reactiveModel.state.notifications != null &&
                            reactiveModel
                                .state.notifications.data.notification.isEmpty
                        ? IdleWidget(data: 'لا توجد إشعارات')
                        : onDataWidget(data.notifications);
                  },
                  onError: (error) {
                    return reactiveModel
                            .state.notifications.data.notification.isEmpty
                        ? OnErrorWidget(
                            'لا توجد إشعارات',
                            () => reactiveModel
                                .setState((state) => state.getNotification()))
                        : onDataWidget(reactiveModel.state.notifications);
                  },
                  onIdle: () {
                    return reactiveModel
                                    .state.notifications.data.notification ==
                                null &&
                            reactiveModel
                                .state.notifications.data.notification.isEmpty
                        ? IdleWidget(data: 'لا توجد إشعارات')
                        : onDataWidget(reactiveModel.state.notifications);
                  },
                  onWaiting: () {
                    return reactiveModel.state.notifications == null
                        ? WaitingWidget()
                        : onDataWidget(reactiveModel.state.notifications);
                  },
                ),
        ),
      ),
    );
  }
}
