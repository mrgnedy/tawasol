import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/data/models/all_occasions_model.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/store/occasions_store.dart';
import 'package:tawasool/presentation/widgets/event_card.dart';
import 'package:tawasool/presentation/widgets/idle_widget.dart';

import '../../../router.gr.dart';

class MyOccasions extends StatefulWidget {
  @override
  _MyOccasionsState createState() => _MyOccasionsState();
}

class _MyOccasionsState extends State<MyOccasions>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Occasion> occasions;
  List<Occasion> pendingOccasions;
  List<Occasion> declinedOccasions;
  List<Occasion> endedOccasions;
  List<Occasion> acceptedOccasions;
  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(initialIndex: 3, length: 4, vsync: this);
    occasions = Injector.getAsReactive<OccasionsStore>()
        .state
        .allOccasionsModel
        .data
        .where((occasion) =>
            occasion.userId ==
            Injector.getAsReactive<AuthStore>().state.credentials.data.id)
        .toList();
    pendingOccasions =
        occasions.where((occasion) => occasion.isAccepted == 2).toList();
    declinedOccasions =
        occasions.where((occasion) => occasion.isAccepted == 0).toList();
    endedOccasions = occasions
        .where((occasion) =>
            occasion.isAccepted == 1 &&
            DateTime.parse(occasion.date).isBefore(
              DateTime.now(),
            ))
        .toList();
    acceptedOccasions = occasions
        .where((occasion) =>
            occasion.isAccepted == 1 &&
            DateTime.parse(occasion.date).isAfter(
              DateTime.now(),
            ))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<List<Occasion>> listOfOccasionLists = [
      pendingOccasions,
      declinedOccasions,
      endedOccasions,
      acceptedOccasions,
    ];
    print(Injector.getAsReactive<AuthStore>().state.credentials.data.id);
    final size = MediaQuery.of(context).size;
    final mq = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Txt(
                      'رجوع',
                      style: TxtStyle()
                        ..textColor(ColorsD.main)
                        ..width(size.width / 10),
                      gesture: Gestures()..onTap(() => Router.navigator.pop()),
                    ),
                    Image.asset('assets/icons/logo.png'),
                    Txt('', style: TxtStyle()..width(size.width / 10)),
                  ],
                ),
                Txt(
                  'المؤسسة العامة للتدريب التقنى والمهنى\nالكلية التقنية بأبها',
                  style: TxtStyle()
                    ..alignment.center()
                    ..alignmentContent.center()
                    ..textAlign.center(),
                ),
                Txt(
                  'تواصل',
                  style: TxtStyle()
                    ..textColor(ColorsD.main)
                    ..fontSize(22)
                    ..fontFamily('Kufi')
                    ..alignment.center()
                    ..alignmentContent.center()
                    ..textAlign.center(),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(size.height / 4),
        ),
        body: Column(
          // shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBar(
                  indicator: BoxDecoration(
                      color: ColorsD.main,
                      borderRadius: BorderRadius.circular(12)),
                  indicatorColor: ColorsD.main,
                  indicatorPadding: EdgeInsets.zero,
                  unselectedLabelColor: ColorsD.main,
                  labelColor: Colors.white,
                  labelStyle: TextStyle(fontFamily: 'Cairo'),
                  controller: tabController,
                  tabs: [
                    Tab(child: FittedBox(child: Txt('قيد الانتظار'))),
                    Tab(child: Txt('المرفوضة')),
                    Tab(child: Txt('المنتهية')),
                    Tab(text: 'الحالية'),
                  ]),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: List.generate(listOfOccasionLists.length, (index) {
                  final currentList = listOfOccasionLists[index];
                  return currentList.isEmpty
                      ? IdleWidget(data: 'لا توجد مناسبات')
                      : ListView.builder(
                          itemCount: currentList.length,
                          itemBuilder: (builder, index) =>
                              EventCard(occasion: currentList[index]));
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
