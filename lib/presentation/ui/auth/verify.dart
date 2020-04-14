import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/widgets/waiting_widget.dart';

import '../../../router.gr.dart';

class VerifyUserScreen extends StatelessWidget {
  BuildContext ctx;
  @override
  Widget build(BuildContext context) {
    ctx = context;
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Center(
          heightFactor: 2.0,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Txt(
                  'أدخل كود التفعيل',
                  style: TxtStyle()..fontSize(18),
                ),
                SizedBox(height: 20),
                pinCode(context),
                SizedBox(height: 20),
                sendCodeBtn(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String code;
  sendCode(String code) {
    print(code);
    final rm = Injector.getAsReactive<AuthStore>();
    rm.setState((state) {
      try {
        state.verify(code).then((s) {
          if (s == true) {
            Router.navigator.pushNamedAndRemoveUntil(
                Router.mainPage, (Route<dynamic> route) => false);
          }
        });
      } catch (e) {
        String error = e.toString();
        if (e.toString().contains('false')) error = 'رمز التفعيل غير صحيح';
        AlertDialogs.failed(context: ctx, content: '$error').then((_) {
          rm.resetToIdle();
        });
      }
    });
  }

  Widget pinCode(context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      child: PinCodeTextField(
          onChanged: (s) {
            code = s;
          },
          textInputType: TextInputType.number,
          backgroundColor: Colors.grey[300],
          activeColor: ColorsD.main,
          shape: PinCodeFieldShape.box,
          inactiveColor: Colors.amber[800],
          selectedColor: ColorsD.main,
          fieldWidth: 50,
          fieldHeight: 50,
          borderRadius: BorderRadius.circular(12),
          borderWidth: 2,
          length: 4,
          onCompleted: sendCode),
    );
  }

  Widget sendCodeBtn(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Widget onIdle = Txt(
      'إرسال',
      gesture: Gestures()..onTap(() => sendCode(code)),
      style: StylesD.tawasolBtnStyle
        ..height(size.height / 16)
        ..width(size.width * 0.5)
        ..alignment.center(),
    );
    final rm = Injector.getAsReactive<AuthStore>();
    return WhenRebuilder<AuthStore>(
        onIdle: () => onIdle,
        onWaiting: () => WaitingWidget(),
        onError: (e) {
          return onIdle;
        },
        onData: (data) {
          return onIdle;
        },
        models: [rm]);
  }

  PreferredSize buildAppBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return PreferredSize(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Txt(
                  'رجوع',
                  style: TxtStyle()
                    ..width(size.width / 12)
                    ..textColor(ColorsD.main),
                  gesture: Gestures()..onTap(Router.navigator.pop),
                ),
                Image.asset('assets/icons/logo.png'),
                Txt('', style: TxtStyle()..width(size.width / 12)),
              ],
            ),
            Txt(
              'المؤسسة العامة للتدريب التقنى والمهنى\nالكلية التقنية بأبها',
              style: TxtStyle()
                ..alignment.center()
                ..alignmentContent.center()
                ..textAlign.center(),
            )
          ],
        ),
      ),
      preferredSize: Size.fromHeight(size.height / 4),
    );
  }
}
