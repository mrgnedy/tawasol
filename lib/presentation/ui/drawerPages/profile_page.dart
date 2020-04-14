import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/api_utils.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/data/models/all_sections_model.dart';
import 'package:tawasool/data/models/credentials_model.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/store/occasions_store.dart';
import 'package:tawasool/presentation/widgets/error_widget.dart';
import 'package:tawasool/presentation/widgets/tet_field_with_title.dart';
import 'package:tawasool/presentation/widgets/waiting_widget.dart';
import 'package:tawasool/router.gr.dart';
import 'package:toast/toast.dart';

import '../../mainPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEdit = false;
  String sectionName;
  String sectionID;
  TextEditingController jobCodeCtrler;
  TextEditingController nameCtrler;
  TextEditingController sectionCtrler;
  TextEditingController phoneCtrler;
  TextEditingController passwordCtrler = TextEditingController();
  TextEditingController confirmPasswordCtrler = TextEditingController();
  final reactiveModel = Injector.getAsReactive<OccasionsStore>();
  final credentials =
      Injector.getAsReactive<AuthStore>().state.credentials.data;
  @override
  void initState() {
    // TODO: implement initState
    if (reactiveModel.state.allSectionsModel == null) {
      reactiveModel.state.getAllSections().then((_) {
        setState(() {
          sectionName = reactiveModel.state.allSectionsModel.data
              .firstWhere((section) => section.id.toString() == sectionID)
              .name;
        });
      });
    } else {
      print(sectionID = credentials.sectionId);
      sectionName = reactiveModel.state.allSectionsModel.data
          .firstWhere((section) => section.id.toString() == sectionID)
          .name;
    }
    jobCodeCtrler = TextEditingController(text: '${credentials.codeJob}');
    nameCtrler = TextEditingController(text: '${credentials.name}');
    sectionCtrler = TextEditingController(text: '$sectionName');
    phoneCtrler = TextEditingController(text: '${credentials.phone}');
    passwordCtrler = TextEditingController(text: '${credentials.password}');
    confirmPasswordCtrler = TextEditingController();
    super.initState();
  }

  File _image;
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mq = MediaQuery.of(context);
    print(credentials.password);
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                      child: Txt(
                        'الرجوع',
                        style: TxtStyle()..textColor(ColorsD.main),
                      ),
                      onTap: Router.navigator.pop),
                  Image.asset('assets/icons/logo.png'),
                  GestureDetector(
                      child: Txt(
                        'تعديل',
                        style: TxtStyle()..textColor(ColorsD.main),
                      ),
                      onTap: () => setState(() => isEdit = !isEdit)),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(100 - mq.viewInsets.bottom / 2.5),
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Container(
                    height: size.height / 8,
                    width: size.height / 8,
                    child: Stack(
                      children: <Widget>[
                        DottedBorder(
                          borderType: BorderType.Circle,
                          strokeCap: StrokeCap.butt,
                          strokeWidth: 3,
                          color: ColorsD.main,
                          child: CachedNetworkImage(
                            imageUrl:
                                '${APIs.imageBaseUrl}profile/${credentials.image}',
                            height: size.height / 8,
                            width: size.height / 8,
                            placeholder: (_, __) => WaitingWidget(),
                            imageBuilder: (context, imageBuilder) => Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: _image == null
                                          ? imageBuilder
                                          : FileImage(_image),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset(1.2, 1),
                          child: Visibility(
                              visible: isEdit,
                              child: InkWell(
                                onTap: () async {
                                  _image =
                                      await StylesD.getProfilePicture(context);
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.camera_enhance,
                                  size: 30,
                                  color: ColorsD.main,
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  TetFieldWithTitle(
                    title: 'الإسم',
                    isEditable: isEdit,
                    textEditingController: nameCtrler,
                  ),
                  TetFieldWithTitle(
                    title: 'الرقم الوظيفي',
                    isEditable: isEdit,
                    textEditingController: jobCodeCtrler,
                    validator: validitaor,
                  ),
                  buildSection(),
                  TetFieldWithTitle(
                    title: 'رقم التليفون',
                    isEditable: isEdit,
                    textEditingController: phoneCtrler,
                  ),
                  Visibility(
                    visible: isEdit,
                    child: TetFieldWithTitle(
                      title: 'كلمة المرور',
                      isEditable: isEdit,
                            isPassword: true,
                      textEditingController: passwordCtrler,
                      validator: passwordValiditaor,
                    ),
                  ),
                  Visibility(
                    visible: isEdit,
                    child: TetFieldWithTitle(
                      title: 'تأكيد كلمة المرور',
                      isEditable: isEdit,
                            isPassword: true,
                      textEditingController: confirmPasswordCtrler,
                      validator: confirmPasswordValiditaor,
                    ),
                  ),
                  Visibility(visible: isEdit, child: buildConfirmEditBtn())
                ]),
              ),
            )),
          )),
    );
  }

  Widget buildSection() {
    final size = MediaQuery.of(context).size;
    return isEdit
        ? CustomBorderedWidget(
            width: size.width * 0.7,
            dropDownBtn: sectionDropDownBtn(),
          )
        : TetFieldWithTitle(
            title: 'القسم',
            isEditable: isEdit,
            textEditingController: sectionCtrler,
          );
  }

  Widget sectionDropDownBtn() {
    final List<Section> sections = reactiveModel.state.allSectionsModel.data;
    return DropdownButton(
        isExpanded: true,
        underline: Container(),
        value: sectionName,
        hint: Txt(
          '--اختر القسم--',
          style: TxtStyle()
            ..fontFamily('Cairo')
            ..textAlign.right()
            ..alignment.centerRight(),
        ),
        items: List.generate(
            sections.length,
            (i) => DropdownMenuItem(
                value: sections[i].name,
                child: Txt(
                  '${sections[i].name}',
                  style: TxtStyle()
                    ..fontFamily('Cairo')
                    ..textAlign.right()
                    ..alignment.centerRight(),
                ))),
        onChanged: (val) => setState(() => {
              sectionName = val,
              sectionID = sections
                  .firstWhere((section) => section.name == sectionName)
                  .id
                  .toString()
            }));
  }

  final authReactiveModel = Injector.getAsReactive<AuthStore>();
  String confirmPasswordValiditaor(String _) {
    if (confirmPasswordCtrler.text != passwordCtrler.text)
      return 'كلمة المرور غير مطابقة';
  }

  String passwordValiditaor(String _) {
    if (passwordCtrler.text.length < 6) return 'كلمة المرور أقل من 6 أحرف';
  }

  String validitaor(String s) {
    if (s.isEmpty) return 'كلمة المرور أقل من 6 أحرف';
  }

  void confirmEdit() {
    if (!_formKey.currentState.validate()) return;

    authReactiveModel.setState((state) => state
        .editProfile(
            Credentials(
                codeJob: jobCodeCtrler.text,
                password: passwordCtrler.text,
                confirmPassword: passwordCtrler.text,
                name: nameCtrler.text,
                phone: '+966${phoneCtrler.text}',
                sectionId: sectionID,
                id: credentials.id),
            _image?.path ?? null)
        .then((_) => {
              if (authReactiveModel.hasError)
                Toast.show("تعذر التعديل", context, duration: Toast.LENGTH_LONG)
              else
                Router.navigator.pop(),
              Toast.show("تم التعديل", context, duration: Toast.LENGTH_LONG)
            }));
  }

  Widget buildConfirmEditBtn() {
    final size = MediaQuery.of(context).size;
    Widget onIdle = Txt(
      'تعديل',
      gesture: Gestures()..onTap(confirmEdit),
      style: StylesD.tawasolBtnStyle
        ..height(size.height / 18)
        ..width(size.width * 0.7),
    );
    return WhenRebuilder(
        onIdle: () => onIdle,
        onWaiting: () => WaitingWidget(),
        onError: (e) {
          Future.delayed(
              Duration(milliseconds: 10),
              () =>
                  AlertDialogs.failed(context: context, content: e.toString()));
          authReactiveModel.resetToIdle();
          return OnErrorWidget(e.toString(), confirmEdit);
        },
        onData: (data) => onIdle,
        models: [Injector.getAsReactive<AuthStore>()]);
  }
}
