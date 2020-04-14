import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/store/occasions_store.dart';
import 'package:tawasool/presentation/widgets/tet_field_with_title.dart';
import 'package:tawasool/presentation/widgets/waiting_widget.dart';
import 'package:tawasool/router.gr.dart';
import 'package:toast/toast.dart';

class ContactUsPage extends StatelessWidget {
  final TextEditingController nameCtrler = TextEditingController(
      text: Injector.getAsReactive<AuthStore>().state.credentials?.data?.name);
  final TextEditingController msgCtrler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mq = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    width: 30,
                    child: Txt(
                      'رجوع',
                      style: TxtStyle()..textColor(ColorsD.main),
                      gesture: Gestures()..onTap(() => Router.navigator.pop()),
                    ),
                  ),
                  Image.asset('assets/icons/logo.png'),
                  SizedBox(width: 30)
                ],
              ),
            ),
            preferredSize:
                Size.fromHeight(size.height / 8 - mq.viewInsets.bottom / 24)),
        body: Align(
          alignment: FractionalOffset(0, 0.3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TetFieldWithTitle(
                title: "الاسم",
                textEditingController: nameCtrler,
              ),
              SizedBox(height: 12),
              TetFieldWithTitle(
                title: 'اترك رسالتك',
                textEditingController: msgCtrler,
                minLines: 5,
                height: 1.5,
              ),
              SizedBox(height: 12),
              Divider(),
              contactUsBtn(context),
            ],
          ),
        ),
      ),
    );
  }

  contactUs(BuildContext context) async {
    final rm = Injector.getAsReactive<AuthStore>();
    rm.setState((state) => state.contactUs(nameCtrler.text, msgCtrler.text).then((_)=>{
      if(rm.hasError)
      Toast.show('تعذر إللاتصال', context),
      {Router.navigator.pop(),
      
      Toast.show('نشكركم على تواصلكم معنا', context,duration: Toast.LENGTH_LONG)}
    }));
  }

  Widget contactUsBtn(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Widget onIdleWidget = Txt(
      'إرسال',
      style: StylesD.tawasolBtnStyle
        ..height(size.height / 18)
        ..width(size.width * 0.7),
      gesture: Gestures()..onTap(()=>contactUs(context)),
    );
    return WhenRebuilder(
        onIdle: () => onIdleWidget,
        onWaiting: () => WaitingWidget(),
        onData: (data) => onIdleWidget,
        onError: (e) {
          print('Error from contact us page');
          return onIdleWidget;
        },
        models: [Injector.getAsReactive<AuthStore>()]);
  }
}
