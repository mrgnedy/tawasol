import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:tawasool/data/models/all_occasions_model.dart';

class EventCard extends StatelessWidget {
  final Occasion occasion;

  const EventCard({Key key, this.occasion}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        child: Parent(
          style: ParentStyle()
            ..borderRadius(all: 20)
            ..elevation(10, color: Colors.grey)
            ..height(100)
            ..background.color(Colors.white)
            ..margin(all: 12),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Parent(
                  child: Icon(Icons.arrow_back),
                  style: ParentStyle()
                    ..alignment.centerLeft()
                    ..margin(all: 12),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Txt(
                    '${occasion.nameOccasion}',
                    style: TxtStyle()
                      ..textDirection(TextDirection.rtl)
                      ..margin(right: 8),
                  )),
              Expanded(
                  flex: 3,
                  child: Parent(
                    child: FlutterLogo(
                      size: 500,
                    ),
                    style: ParentStyle()
                      ..background.color(Colors.grey[300])
                      ..borderRadius(topRight: 20, bottomRight: 20),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
