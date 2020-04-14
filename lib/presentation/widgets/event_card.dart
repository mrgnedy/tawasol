import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:tawasool/core/api_utils.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/data/models/all_occasions_model.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:tawasool/presentation/widgets/waiting_widget.dart';
import 'package:tawasool/router.gr.dart';

class EventCard extends StatelessWidget {
  final Occasion occasion;

  const EventCard({Key key, this.occasion}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final stateColorsList = [
      Colors.red,
      Colors.green,
      Colors.amber,
    ];
    Color color = occasion.isAccepted == 1 &&
            DateTime.parse(occasion.date).isBefore(DateTime.now())
        ? Colors.grey
        : stateColorsList[occasion.isAccepted];
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => Router.navigator.pushNamed(Router.occasionDetails,
          arguments: OccasionDetailsArguments(occasion: occasion)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          child: Parent(
            style: ParentStyle()
              ..borderRadius(all: 20)
              ..elevation(10, color: Colors.grey)
              ..height(size.height / 7.5)
              // ..width(size.width*0.5)
              ..background.color(Colors.white)
              ..margin(all: 12),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Parent(
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                              colors: [
                                // stateColorsList[occasion.isAccepted],
                                // Colors.white70,
                                color.withAlpha(128),
                                color
                              ],
                              tileMode: TileMode.clamp,
                              stops: [0.3, 0.9]),
                          color: stateColorsList[occasion.isAccepted]),
                    ),
                    style: ParentStyle()
                      ..alignment.topLeft()
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
                      child: SizedBox(
                        height: size.height / 7.5,
                        width: size.width * 0.7,
                        child: CachedNetworkImage(
                          imageBuilder: (c, image) => Container(
                            width: size.width * 7.5,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                image: DecorationImage(
                                  image: image,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          imageUrl:
                              '${APIs.imageBaseUrl}occasions/${occasion.image}',
                          filterQuality: FilterQuality.low,
                          height: size.height / 7.5,
                          width: size.width * 7.5,
                          // cacheManager:,
                          fit: BoxFit.fill,
                          placeholder: (_, __) => WaitingWidget(),

                          // cacheManager: cachemana,
                          // size: 500,
                        ),
                      ),
                      style: ParentStyle()
                        ..background.color(ColorsD.main)
                        // ..width(300)
                        ..borderRadius(topRight: 20, bottomRight: 20),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
