import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/api_utils.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/data/models/credentials_model.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/widgets/error_widget.dart';
import 'package:tawasool/presentation/widgets/tet_field_with_title.dart';
import 'package:tawasool/presentation/widgets/waiting_widget.dart';
import 'package:http/http.dart' as http;

import '../../../router.gr.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final reactiveModel = Injector.getAsReactive<AuthStore>();
    reactiveModel.resetToIdle();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Align(
              alignment: FractionalOffset(0, 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[],
              ),
            ),
            Align(
                alignment: FractionalOffset(0.5, 0.05),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Txt('تخطي       ',
                                style: TxtStyle()..textColor(Colors.red),
                                gesture: Gestures()
                                  ..onTap(() => Router.navigator
                                      .pushReplacementNamed(Router.mainPage))),
                            Image.asset('assets/icons/logo.png'),
                            Txt('${isCreate ? "تسجيل دخول" : "تسجيل جديد"}',
                                gesture: Gestures()
                                  ..onTap(() {
                                    isCreate = !isCreate;
                                    setState(() {});
                                  }),
                                style: TxtStyle()..textColor(ColorsD.main)),
                          ],
                        ),
                        Txt(
                          'المؤسسة العامة للتدريب التقنى والمهنى\nالكلية التقنية بأبها',
                          style: TxtStyle()
                            ..alignmentContent.topCenter()
                            ..textAlign.center(),
                        ),
                        Txt(
                          'تواصل',
                          style: TxtStyle()..textColor(ColorsD.main),
                        ),
                        Visibility(
                          visible: isCreate,
                          child: TetFieldWithTitle(
                            title: 'الإسم بالكامل',
                            inputType: TextInputType.text,
                            textEditingController: nameCtrler,
                            validator: nameValidator,
                          ),
                        ),
                        TetFieldWithTitle(
                          title: 'الرقم الوظيفي',
                          inputType: TextInputType.number,
                          textEditingController: ssidCtrler,
                          validator: ssidValidator,
                        ),
                        TetFieldWithTitle(
                          title: 'كلمة المرور',
                          inputType: TextInputType.text,
                          textEditingController: passwordCtrler,
                          validator: passwordValidator,
                        ),
                        Visibility(
                          visible: isCreate,
                          child: TetFieldWithTitle(
                            title: 'تأكيد كلمة المرور',
                            inputType: TextInputType.text,
                            textEditingController: confirmCtrler,
                            validator: confirmPasswordValidator,
                          ),
                        ),
                        loginBtn(),
                        SizedBox(height: 10),
                        orBar(),
                        loginWithGoogle(),
                        // noAccount()
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  TextEditingController ssidCtrler = TextEditingController(text: '');
  TextEditingController passwordCtrler = TextEditingController(text: '');
  TextEditingController nameCtrler = TextEditingController(text: '');
  TextEditingController confirmCtrler = TextEditingController(text: '');
  bool isCreate = false;
  Widget textFieldWidget(
      String hint, TextEditingController txtCtrler, TextInputType inputType) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: size.width * 0.7,
          height: size.height / 18,
          child: TextField(
            controller: txtCtrler,
            keyboardType: inputType,
            textAlign: TextAlign.right,
            cursorColor: ColorsD.main,
            style: TextStyle(
              fontFamily: 'Cairo',
              height: 0.8,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              labelText: hint,
              labelStyle:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
              // alignLabelWithHint: true,

              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorsD.main),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TxtStyle defaultStyle = TxtStyle()
    ..margin(all: 12)
    ..textColor(Colors.white)
    ..borderRadius(all: 20)
    ..background.color(ColorsD.main)
    ..alignment.center()
    ..elevation(5)
    ..alignmentContent.center();
  Widget loginBtn() {
    final size = MediaQuery.of(context).size;
    Widget onIdle = Txt(
      '${isCreate ? "انشاء حساب" : "تسجيل جديد"}',
      gesture: Gestures()..onTap(loginOnTap),
      style: defaultStyle.clone()
        ..width(size.width * 0.7)
        ..height(size.height / 18),
    );
    return WhenRebuilder(
      models: [Injector.getAsReactive<AuthStore>()],
      onIdle: () => onIdle,
      onWaiting: () => WaitingWidget(),
      onError: (e) {
        Future.delayed(Duration(milliseconds: 1), ()=>AlertDialogs.failed(context: context, content: e)).then((_){});
       return OnErrorWidget(e);
      },
      onData: (data) {
        Router.navigator.pushReplacementNamed(Router.mainPage);
        return Container();
      },
    );
  }

  Widget loginWithGoogle() {
    final size = MediaQuery.of(context).size;
    return Txt(
      'Sign in with Google',
      style: defaultStyle.clone()
        ..width(size.width * 0.7)
        ..height(size.height / 20)
        ..background.color(Colors.red),
    );
  }

  void loginOnTap() async {
    final reactiveModel = Injector.getAsReactive<AuthStore>();
    if (isCreate)
      reactiveModel.setState((state) => state.register(
            Credentials(
              codeJob: '${ssidCtrler.text}',
              password: '${passwordCtrler.text}',
              confirmPassword: '${confirmCtrler.text}',
              deviceToken: 'sss',
              name: '${nameCtrler.text}',
              phone: '${010}',
            ),
          ));
    else
      reactiveModel.setState((state) => state.login(
            Credentials(
              codeJob: '${ssidCtrler.text}',
              password: '${passwordCtrler.text}',
            ),
          ));
  }

  Widget orBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: Divider(
            thickness: 1,
          )),
          Txt('أو'),
          Expanded(
              child: Divider(
            thickness: 1,
          )),
        ],
      ),
    );
  }

  String passwordValidator(String text) {
    // if (text.length < 6) return 'Too Short Of a Text';
  }

  String confirmPasswordValidator(String text) {
    // if (text.length < 6) return 'Too Short Of a Text';
  }

  String ssidValidator(String text) {
    // if (text.length < 6) return 'Too Short Of a Text';
  }

  String nameValidator(String text) {
    // if (text.length < 6) return 'Too Short Of a Text';
  }

  Widget noAccount() {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: 'ليس لديك حساب؟  ',
          style: TextStyle(color: Colors.black, fontFamily: 'Cairo')),
      TextSpan(
          text: 'انشاء حساب',
          style: TextStyle(color: ColorsD.main, fontFamily: 'Cairo')),
    ]));
  }
}
