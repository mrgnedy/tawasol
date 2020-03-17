import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/presentation/store/occasions_store.dart';
import 'package:tawasool/presentation/widgets/event_card.dart';

class AllOccasionsPage extends StatelessWidget {
  final reactiveModel = Injector.getAsReactive<OccasionsStore>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // physics: NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        children: <Widget>[
          Txt(
            'المؤسسة العامة للتدريب التقنى والمهنى\nالكلية التقنية بأبها',
            style: TxtStyle()
              ..alignment.center()
              ..alignmentContent.center()
              ..textAlign.center(),
          ),
          ...List.generate(reactiveModel.state.allOccasionsModel.data.length, (index) {
            return EventCard(occasion: reactiveModel.state.allOccasionsModel.data[index],);
          })
        ],
      ),
    );
  }
}
