import 'dart:ui';

import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tawasool/presentation/mainPage.dart';

class ColorsD {
  static Color main = Colors.cyan[900];
  static Color eventDetailsColor = Colors.lightBlue;
  static Color backGroundColor = Colors.grey[300];
  static Color elevationColor = Colors.grey;
}

class StylesD {
  static Size size;
  static TxtStyle tawasolBtnStyle = TxtStyle()
    ..margin(all: 12)
    ..textColor(Colors.white)
    ..borderRadius(all: 20)
    ..background.color(ColorsD.main)
    ..alignment.center()
    ..elevation(5)
    ..alignmentContent.center();
  static getProfilePicture(BuildContext context) async {
    print('kjhgcfvhjklv');
    return await showModalBottomSheet(
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
    // setState(() {});
  }
  static InputDecoration inputDecoration = InputDecoration(
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsD.main, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsD.main, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );
  static TxtStyle txtOnCardStyle = TxtStyle()
    ..fontFamily('Cairo')
    ..textColor(Colors.white)
    ..alignment.center()
    ..alignmentContent.center()
    ..borderRadius(all: 8)
    // ..height(size.height / 18)
    ..background.color(ColorsD.main)
    ..elevation(10, color: ColorsD.elevationColor)
    ..margin(horizontal: 20, bottom: 10);
  static ParentStyle btnOnCardStyle = ParentStyle()
    ..alignment.center()
    ..alignmentContent.center()
    ..borderRadius(all: 8)
    ..height(size.height / 18)
    ..background.color(ColorsD.main)
    ..elevation(10, color: ColorsD.elevationColor)
    ..margin(horizontal: 20, vertical: 20);
  static ParentStyle cartStyle = ParentStyle()
    ..borderRadius(all: 30)
    ..elevation(8, color: Colors.grey)
    ..alignment.center()
    ..alignmentContent.center()
    ..padding(all: 20.0)
    ..background.color(Colors.white)
    ..margin(all: 20);

  static TxtStyle txtStyle = TxtStyle()..fontFamily('Cairo');
  static InputDecoration inputDecoration2 = InputDecoration(
    // labelText: hint,
    // labelStyle:
    //     TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
    // alignLabelWithHint: true,
    
    contentPadding: EdgeInsets.only(
      right: 10,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsD.main),
      borderRadius: BorderRadius.circular(20),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(20),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(20),
    ),

    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

class Assets {
  static String productBackground =
      'assets/icons/shttefan-viNPa2F7fnw-unsplash.png';
  static String logo =
      'assets/icons/84273958_467844620576269_2633456491713003520_n.png';
  static String logoKharoof =
      'assets/icons/logotipo-de-ovelhas_26820-149@3x.png';
}

class Urls {
  static String phoneNumber = '+966548252956';
}

class AlertDialogs {
  static Future failed({BuildContext context, String content}) async {
    // context = globalContext;
    return await defaultDialog(context, 'فشلت العملية', Icons.warning,
        content: content);
  }

  static Future success({BuildContext context, String content}) async {
    // context = globalContext;
    return await defaultDialog(context, 'تمت العملية', Icons.check,
        content: content);
  }

  static Future defaultDialog(BuildContext context, String title, IconData icon,
      {String content}) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: ColorsD.main)),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  icon,
                  color: ColorsD.main,
                  size: 30,
                ),
                Txt(
                  title,
                  style: StylesD.txtStyle,
                ),
              ],
            ),
            Divider(
              color: ColorsD.main,
              height: 10,
            )
          ],
        ),
        content: Container(
          // color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 8,
          child: Align(
            child: Txt(
              content,
              style: StylesD.txtStyle.clone()..textDirection(TextDirection.rtl),
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // ClippedButton(
              //   width: MediaQuery.of(context).size.width / 4,
              //   child: TextD(title: 'لا',textColor: ColorsD.redDefault, fontSize: 18,),
              //   color: Colors.grey[100],
              //   onTapCallback: (){},
              // ),
              Padding(
                padding: const EdgeInsets.only(right: 37.0),
                child: ClippedButton(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Txt(
                    'موافق',
                    style: TxtStyle()..textColor(Colors.white),
                  ),
                  color: ColorsD.main,
                  onTapCallback: () => Navigator.of(context).pop(true),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CustomBorderedWidget extends StatelessWidget {
  final double width;
  final Widget dropDownBtn;

  const CustomBorderedWidget({Key key, this.width, this.dropDownBtn})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return dropDownWithStyle(dropDownBtn);
  }

  Widget dropDownWithStyle(Widget dropDownBtn) {
    // scrollController.jumpTo(scrollController.position.)
    // final size = MediaQuery.of(context).size;
    return Container(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Txt('القسم',
              style: TxtStyle()
                ..fontWeight(FontWeight.bold)
                ..alignment.centerRight()),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: ColorsD.main),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: dropDownBtn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClippedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  final Function onTapCallback;

  ClippedButton({
    this.child,
    this.color = Colors.grey,
    this.onTapCallback,
    this.width,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        margin: EdgeInsets.only(right: 16, left: 16, top: 6, bottom: 6),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: width ?? MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 18, left: 18),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
