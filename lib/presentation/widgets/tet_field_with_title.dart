import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:tawasool/core/utils.dart';

class TetFieldWithTitle extends StatelessWidget {
  final String title;
  final Function validator;
  final TextInputType inputType;
  final TextEditingController textEditingController;

  const TetFieldWithTitle(
      {Key key,
      this.title = 'title',
      this.validator,
      this.inputType,
      this.textEditingController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Txt(
          '$title',
          style: TxtStyle()..fontWeight(FontWeight.bold),
        ),
        textFieldWidget(context),
      ],
    );
  }

  Widget textFieldWidget(context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: size.width * 0.7,
          height: size.height / 12,
          child: TextFormField(
            key: key,
            controller: textEditingController,
            validator: validator,
            keyboardType: inputType,
            textAlign: TextAlign.right,
            cursorColor: ColorsD.main,
            style: TextStyle(
              fontFamily: 'Cairo',
              height: 1,
              fontSize: 14,
            ),
            decoration: InputDecoration(
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
            ),
          ),
        ),
      ),
    );
  }
}
