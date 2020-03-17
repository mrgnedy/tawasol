import 'package:division/division.dart';
import 'package:flutter/material.dart';

class IdleWidget extends StatelessWidget {
  final String data;

  const IdleWidget({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(child: Txt('$data'),);
  }
}