import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/widgets/error_widget.dart';
import 'package:tawasool/presentation/widgets/idle_widget.dart';
import 'package:tawasool/presentation/widgets/waiting_widget.dart';

import '../../../router.gr.dart';

class AboutPage extends StatelessWidget {
  final String data;

  const AboutPage({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Map aboutData = Injector.getAsReactive<AuthStore>()
        .state
        .settingModel
        .data
        .first
        .toJson();
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
        body: Align(
          alignment: FractionalOffset(0.5, 0.3),
          child: SingleChildScrollView(child: showDataWidget()),
        ),
      ),
    );
  }

  getData() => Injector.getAsReactive<AuthStore>()
      .setState((state) => state.getSettings());
  showDataWidget() {
    if (Injector.getAsReactive<AuthStore>().state.settingModel == null)
      getData();
    Injector.getAsReactive<AuthStore>().resetToHasData();
    return WhenRebuilder<AuthStore>(
        onIdle: () => IdleWidget(),
        onWaiting: () => WaitingWidget(),
        onError: (e) => OnErrorWidget(e, getData),
        onData: (data) => Txt(
            '${data.settingModel.data.first.toJson()[this.data]}',
            style: TxtStyle()..alignment.center()..alignmentContent.center()..textAlign.center()),
        models: [Injector.getAsReactive<AuthStore>()]);
  }
}
