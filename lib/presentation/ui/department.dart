import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
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
  @override
  void initState() {
    print('rebuilt');
    // TODO: implement initState
    getSections();
    super.initState();
  }

  void getSections() {
    if (reactiveModel.state.allSectionsModel == null) {
      reactiveModel.setState((state) => state.getAllSections());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return WhenRebuilder<OccasionsStore>(
      onIdle: () => IdleWidget(data: "لا توجد أقسام"),
      onWaiting: () => WaitingWidget(),
      onError: (e) => OnErrorWidget(e, getSections),
      onData: onDataWidget,
      models: [Injector.getAsReactive<OccasionsStore>()],
    );
  }

  Widget onDataWidget(OccasionsStore data) {
    final size = MediaQuery.of(context).size;
    return VerticalTabs(
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
          child: Txt(section.name),
        );
      }),
      contents: List.generate(data.allSectionsModel.data.length, (index) {
        final section = data.allSectionsModel.data[index];
        final List occasions = data.allOccasionsModel.data
            .where((occasion) =>
                occasion.isPublic == 0 && occasion.sectionId == section.id)
            .toList();
        return ListView(
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
