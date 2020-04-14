import 'dart:io';

import 'package:division/division.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/FCM.dart';
import 'package:tawasool/core/api_utils.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/data/models/all_sections_model.dart';
import 'package:tawasool/data/models/credentials_model.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/store/occasions_store.dart';
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
  // GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  // GoogleSignInAccount _googleSignInAccount;

  FirebaseNotifications fcmToken;
  String deviceToken;

  getTokenCallback(String token) {
    deviceToken = token;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final reactiveModel = Injector.getAsReactive<AuthStore>();
    if (reactiveModel.hasError) reactiveModel.resetToIdle();
    super.didChangeDependencies();
  }

  // googleLogin() async {
  //   _googleSignInAccount = await _googleSignIn.signIn();
  // }

  // googleLogOut() async {
  //   _googleSignInAccount = await _googleSignIn.signOut();
  // }

  // printAnything() async {
  //   print((await _googleSignInAccount.authentication).idToken);
  // }

  final reactiveModel = Injector.getAsReactive<OccasionsStore>();
  @override
  void initState() {
    // TODO: implement initState
    fcmToken = FirebaseNotifications.getToken(getTokenCallback);
    if (reactiveModel.state.allSectionsModel == null) {
      reactiveModel.setState((state) => state.getAllSections());
    }
    super.initState();
  }

  ScrollController _scrollController = ScrollController();
  double yOffset = 0.4;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mq = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: appBarWidget(mq),
          preferredSize: Size.fromHeight(size.height / 4),
        ),
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: FractionalOffset(0, yOffset),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Visibility(
                              visible: isCreate,
                              child: Container(
                                height: size.height / 8,
                                width: size.height / 8,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    DottedBorder(
                                      strokeCap: StrokeCap.butt,
                                      strokeWidth: 3,
                                      color: ColorsD.main,
                                      child: Container(
                                        height: size.height / 8,
                                        width: size.height / 8,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: _image != null
                                              ? FileImage(_image)
                                              : AssetImage(
                                                  'assets/icons/male.png'),
                                        ),
                                      ),
                                      borderType: BorderType.Circle,
                                    ),
                                    Align(
                                        alignment: FractionalOffset(1.5, 1.2),
                                        child: InkWell(
                                            child: IconButton(
                                          onPressed: getProfilePicture,
                                          icon: Icon(Icons.camera_enhance),
                                          color: ColorsD.main,
                                          iconSize: 30,
                                          padding: EdgeInsets.zero,
                                        ))),
                                  ],
                                ),
                              )),
                          Visibility(
                            visible: isCreate,
                            child: TetFieldWithTitle(
                              title: 'الإسم بالكامل',
                              inputType: TextInputType.text,
                              textEditingController: nameCtrler,
                              validator: nameValidator,
                            ),
                          ),
                          Visibility(
                            visible: isCreate,
                            child: TetFieldWithTitle(
                              
                              title: 'رقم التليفون',
                              icon: Container(
                                  width: size.width / 7,
                                  child: Txt('+966',
                                      style: TxtStyle()
                                        ..textDirection(TextDirection.ltr)
                                        ..alignment.centerRight()
                                        ..width(size.width / 9))),
                              inputType: TextInputType.text,
                              textEditingController: phoneCtrler,
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
                            isPassword: true,
                            textEditingController: passwordCtrler,
                            validator: passwordValidator,
                          ),
                          Visibility(
                            visible: isCreate,
                            child: TetFieldWithTitle(
                              title: 'تأكيد كلمة المرور',
                              isPassword: true,
                              inputType: TextInputType.text,
                              textEditingController: confirmCtrler,
                              validator: confirmPasswordValidator,
                            ),
                          ),
                          Visibility(
                            visible: isCreate,
                            child: Container(
                              height: 100,
                              child: CustomBorderedWidget(
                                dropDownBtn: sectionDropDown(),
                                width: size.width * 0.7,
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          loginBtn(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController ssidCtrler = TextEditingController(text: '');
  TextEditingController phoneCtrler = TextEditingController(text: '');
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

  Widget appBarWidget(MediaQueryData mq) {
    // final mq = MediaQuery.of(context);
    return Visibility(
      visible: mq.viewInsets == EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                        yOffset = 1.8 - yOffset;
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
          ],
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
      '${isCreate ? "انشاء حساب" : "تسجيل دخول"}',
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
        Future.delayed(
            Duration(milliseconds: 1),
            () => AlertDialogs.failed(
                context: context, content: e.toString())).then((_) {});
        return OnErrorWidget(e);
      },
      onData: (data) {
        return onIdle;
      },
    );
  }

  Widget loginWithGoogle() {
    final size = MediaQuery.of(context).size;
    return Txt(
      'Sign in with Google',
      // gesture: Gestures()..onTap(googleLogin),
      style: defaultStyle.clone()
        ..width(size.width * 0.7)
        ..height(size.height / 20)
        ..background.color(Colors.red),
    );
  }

  File _image;
  getProfilePicture() async {
    print('kjhgcfvhjklv');
    _image = await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        context: context,
        builder: (context) => ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Txt('اختر مصدر الصورة',
                      style: TxtStyle()
                        ..textColor(Colors.white)
                        ..background.color(ColorsD.main)
                        ..height(40)
                        ..alignment.center()
                        ..alignmentContent.center()
                        ..fontSize(16)),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(
                          context,
                          await ImagePicker.pickImage(
                              source: ImageSource.camera));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Txt('الكاميرا'),
                          SizedBox(
                            width: 12,
                          ),
                          Icon(
                            Icons.camera_enhance,
                            color: ColorsD.main,
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(
                          context,
                          await ImagePicker.pickImage(
                              source: ImageSource.gallery));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Txt('الاستوديو'),
                          SizedBox(
                            width: 12,
                          ),
                          Icon(
                            Icons.photo_library,
                            color: ColorsD.main,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
    setState(() {});
  }

  Future loginOnTap() async {
    final authReactiveModel = Injector.getAsReactive<AuthStore>();
    if (isCreate)
      {
        if(_image == null )
        {
          AlertDialogs.failed(content: 'من فضلك أدخل صورة شخصية',context: context);
          return null;
        }
        return authReactiveModel.setState((state) => state
              .register(
                  Credentials(
                      codeJob: '${ssidCtrler.text}',
                      password: '${passwordCtrler.text}',
                      confirmPassword: '${confirmCtrler.text}',
                      deviceToken: '$deviceToken',
                      name: '${nameCtrler.text}',
                      phone: '+966${phoneCtrler.text}',
                      sectionId:
                          '${reactiveModel.state.allSectionsModel.data.firstWhere((section) => section.name == selectedSection).id}'),
                  _image.path)
              .then((d) {
            if (d != null) {
              isCreate
                  ? Router.navigator.pushNamed(Router.verifyUserScreen)
                  : Router.navigator.pushReplacementNamed(Router.mainPage);
            }
          }));}
    else
      return authReactiveModel.setState((state) => state
              .login(
            Credentials(
                codeJob: '${ssidCtrler.text}',
                password: '${passwordCtrler.text}',
                deviceToken: deviceToken),
          )
              .then((d) {
            if (d != null) {
              isCreate
                  ? Router.navigator.pushNamed(Router.verifyUserScreen)
                  : Router.navigator.pushReplacementNamed(Router.mainPage);
            }
          }));
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
    if (text.length < 6) return 'Too Short Of a Text';
  }

  String confirmPasswordValidator(String text) {
    if (text.length < 6) return 'Too Short Of a Text';
  }

  String ssidValidator(String text) {
    if (text.length < 6) return 'Too Short Of a Text';
  }

  String nameValidator(String text) {
    if (text.length < 6) return 'Too Short Of a Text';
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

  Widget sectionDropDown() {
    if (Injector.getAsReactive<OccasionsStore>().state.allSectionsModel ==
        null) {
      Injector.getAsReactive<OccasionsStore>()
          .setState((state) => state.getAllSections());
    } else
      Injector.getAsReactive<OccasionsStore>().resetToHasData();
    return WhenRebuilder<OccasionsStore>(
      models: [reactiveModel],
      onIdle: () => Container(),
      onError: (e) => OnErrorWidget(
          e, () => reactiveModel.setState((state) => state.getAllSections())),
      onWaiting: () => WaitingWidget(),
      onData: (data) => dropDownBtn(data.allSectionsModel.data),
    );
  }

  String selectedSection;
  Widget dropDownBtn(List<Section> allSections) {
    return DropdownButton(
      underline: Container(),
      hint: Txt(
        '--اختر قسم--',
        style: TxtStyle()
          ..textAlign.right()
          ..fontFamily('Cairo'),
      ),
      value: selectedSection,
      style: TextStyle(),
      isExpanded: true,
      onChanged: (val) {
        setState(() {
          selectedSection = val;
        });
      },
      items: List.generate(
        allSections.length,
        (i) {
          return DropdownMenuItem(
            value: allSections[i].name,
            child: Txt(
              '${allSections[i].name}',
              style: TxtStyle()
                ..textAlign.right()
                ..alignment.centerRight()
                ..fontFamily('Cairo'),
            ),
          );
        },
      ),
    );
  }
}
