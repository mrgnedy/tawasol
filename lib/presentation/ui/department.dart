import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/store/occasions_store.dart';
import 'package:tawasool/presentation/widgets/error_widget.dart';
import 'package:tawasool/presentation/widgets/event_card.dart';
import 'package:tawasool/presentation/widgets/idle_widget.dart';
import 'package:tawasool/presentation/widgets/waiting_widget.dart';
import 'package:vertical_tabs/vertical_tabs.dart';

class DepartmentsScreen extends StatefulWidget {
  @override
  _DepartmentsScreenState createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen>
    with AutomaticKeepAliveClientMixin {
  final reactiveModel = Injector.getAsReactive<OccasionsStore>();
  final creds = Injector.getAsReactive<AuthStore>().state.credentials?.data;
  @override
  void initState() {
    print('rebuilt');
    // TODO: implement initState
    getSections();
    super.initState();
  }

  @override
  void didUpdateWidget(DepartmentsScreen oldWidget) {
    // TODO: implement didUpdateWidget
    // reactiveModel.resetToHasData();

    getSections();
    super.didUpdateWidget(oldWidget);
  }

  void getSections() {
    if (reactiveModel.state.allSectionsModel == null) {
      reactiveModel.setState((state) => state.getAllSections());
    } else
      reactiveModel.resetToHasData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: <Widget>[
        Txt(
          'الأقسام',
          style: TxtStyle()
            ..alignment.centerRight()
            ..padding(right: 15)
            ..fontSize(18)
            ..textColor(ColorsD.main),
        ),
        Expanded(
          child: WhenRebuilder<OccasionsStore>(
            onIdle: () => IdleWidget(data: "لا توجد أقسام"),
            onWaiting: () => WaitingWidget(),
            onError: (e) => OnErrorWidget(e, getSections),
            onData: onDataWidget,
            models: [Injector.getAsReactive<OccasionsStore>()],
          ),
        ),
      ],
    );
  }

  Widget onDataWidget(OccasionsStore data) {
    final size = MediaQuery.of(context).size;
    return VerticalTabs(
      height: size.height / 12,
      tabBackgroundColor: Colors.white,
      indicatorWidth: 8,
      tabsBackgroundColor: Colors.grey[300],
      tabsShadowColor: Colors.black26,
      tabsElevation: 10,
      backgroundColor: Colors.grey[300],
      selectedTabBackgroundColor: Colors.grey[300],
      indicatorColor: Colors.cyan[900],
      disabledChangePageFromContentView: true,
      direction: TextDirection.rtl,
      tabsWidth: size.width / 3,
      contentScrollAxis: Axis.vertical,
      indicatorSide: IndicatorSide.start,
      tabs: List.generate(data.allSectionsModel.data.length, (index) {
        final section = data.allSectionsModel.data[index];
        return Tab(
          child: Txt(section.name,
              style: TxtStyle()
                ..textAlign.right()
                ..textDirection(TextDirection.rtl)
                ..alignment.centerRight()
                ..padding(right: 3)),
        );
      }),
      contents: List.generate(data.allSectionsModel.data.length, (index) {
        final section = data.allSectionsModel.data[index];
        final List occasions = data.allOccasionsModel.data
            .where((occasion) =>
                occasion.isPublic == 0 &&
                occasion.sectionId == section.id &&
                (occasion.isAccepted == 1 ||
                    (occasion.isAccepted == 2 && occasion.userId == creds?.id)))
            .toList();
        return occasions.length == 0
            ? IdleWidget(
                data: 'لا لتوجد مناسبات',
              )
            : ListView(
                shrinkWrap: true,
                children: List.generate(occasions.length, (index) {
                  return EventCard(occasion: occasions[index]);
                }));
      }),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
