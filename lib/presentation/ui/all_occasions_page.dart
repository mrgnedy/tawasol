import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/data/models/all_occasions_model.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/store/occasions_store.dart';
import 'package:tawasool/presentation/widgets/error_widget.dart';
import 'package:tawasool/presentation/widgets/event_card.dart';
import 'package:tawasool/presentation/widgets/idle_widget.dart';
import 'package:tawasool/presentation/widgets/waiting_widget.dart';

class AllOccasionsPage extends StatefulWidget {
  @override
  _AllOccasionsPageState createState() => _AllOccasionsPageState();
}

class _AllOccasionsPageState extends State<AllOccasionsPage> {
  final reactiveModel = Injector.getAsReactive<OccasionsStore>();
  final creds = Injector.getAsReactive<AuthStore>().state.credentials?.data;

  @override
  void didUpdateWidget(_) {
    // TODO: implement didChangeDependencies
      reactiveModel.resetToHasData();
    Future.delayed(Duration(milliseconds: 200), () {
      if (!mounted) return;
      setState(() {
        print('Back to All Occasions Screen');
      });
    });
    super.didUpdateWidget(_);
  }

  @override
  void initState() {
    // TODO: implement initState
    if (reactiveModel.state.allOccasionsModel == null) {
      reactiveModel.setState((state) => state.getAllOccasions());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(occasions.length);
    return RefreshIndicator(
      onRefresh: () async {
        return await reactiveModel.setState(
            (state) => state.getAllOccasions().then((_) => setState(() {})));
      },
      child: Column(
        children: <Widget>[
          Txt(
            'الرئيسية',
            style: TxtStyle()
              ..alignment.centerRight()
              ..padding(right: 15)
              ..fontSize(18)
              ..textColor(ColorsD.main),
          ),
          Expanded(
            child: allOcasionsRebuilder(),
          ),
        ],
      ),
    );
  }

  Widget onData(List<Occasion> occasions) {
    return ListView.builder(
      itemCount: occasions.length,
      cacheExtent: 100,
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      itemBuilder: (context, i) => EventCard(
        occasion: occasions[i],
      ),
    );
  }

  Widget allOcasionsRebuilder() {
    return WhenRebuilder<OccasionsStore>(
        onIdle: () => buildOnData(IdleWidget(data: "لا توجد مناسبات")),
        onWaiting: () => buildOnData(WaitingWidget()),
        onError: (e) => OnErrorWidget(e,
            () => reactiveModel.setState((state) => state.getAllOccasions())),
        onData: (_) => buildOnData(IdleWidget(data: 'لا توجد مناسبات')),
        models: [reactiveModel]);
  }

  Widget buildOnData(Widget widget) {
    if (reactiveModel.state.allOccasionsModel == null) return widget;
    final occasions = reactiveModel.state.allOccasionsModel.data
        .where((occasion) =>
            (occasion.isAccepted == 1 ||
                (occasion.sectionId.toString() == creds?.sectionId &&
                    creds.type == 2) ||
                occasion.userId == creds?.id) &&
            occasion.isAccepted != 0)
        .toList();
    return occasions.isEmpty ? widget : onData(occasions);
  }
}
