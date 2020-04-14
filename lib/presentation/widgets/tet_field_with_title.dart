import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:tawasool/core/utils.dart';

class TetFieldWithTitle extends StatefulWidget {
  final String title;
  final Function validator;
  final TextInputType inputType;
  final Widget icon;
  final bool isEditable;
  final int minLines;
  final double height;
  final bool isPassword;
  // final Function iconCallback;
  final TextEditingController textEditingController;

  TetFieldWithTitle(
      {Key key,
      this.title = 'title',
      this.validator,
      this.inputType,
      this.icon,
      this.isEditable = true,
      // this.iconCallback,
      this.isPassword = false,
      this.textEditingController,
      this.minLines,
      this.height = 1.2})
      : super(key: key);

  @override
  _TetFieldWithTitleState createState() => _TetFieldWithTitleState();
}

class _TetFieldWithTitleState extends State<TetFieldWithTitle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Txt(
          '${widget.title}',
          style: TxtStyle()
            ..fontWeight(FontWeight.bold)
            ..textAlign.right(),
        ),
        textFieldWidget(context),
      ],
    );
  }

  bool obSecure = true;

  Widget textFieldWidget(context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: size.width * 0.7,
          // height: size.height / 12,
          child: TextFormField(
            enabled: widget.isEditable,
            minLines: widget.minLines,
            // key: key,
          
            obscureText: widget.isPassword ? obSecure : false,
            maxLines: widget.isPassword ? 1 : null,
            controller: widget.textEditingController,
            validator: widget.validator,
            keyboardType: widget.inputType,
            textAlign: TextAlign.right,
            cursorColor: ColorsD.main,
            // showCursor: false,
            style: TextStyle(
              fontFamily: widget.isPassword || widget.inputType == TextInputType.number?'': 'Cairo',
              height: widget.height,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              suffixIcon: widget.isPassword
                  ? InkWell(
                      onTap: () {
                        obSecure = !obSecure;
                        setState(() {});
                      },
                      child: Icon(Icons.remove_red_eye))
                  : widget.icon,
              // enabled: false,
              // labelText: hint,
              // labelStyle:
              //     TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
              // alignLabelWithHint: true,
              contentPadding: EdgeInsets.only(right: 10, top: 16, left: 10),
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
