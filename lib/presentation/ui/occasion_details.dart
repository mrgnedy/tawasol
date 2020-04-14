import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/api_utils.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/data/models/all_comments_model.dart';
import 'package:tawasool/data/models/all_occasions_model.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/store/occasions_store.dart';
import 'package:tawasool/presentation/widgets/error_widget.dart';
import 'package:tawasool/presentation/widgets/waiting_widget.dart';
import 'package:toast/toast.dart';

import '../../router.gr.dart';
// import '';

class OccasionDetails extends StatefulWidget {
  final int id;
  Occasion occasion;
  OccasionDetails({this.occasion, this.id});
  @override
  _OccasionDetailsState createState() => _OccasionDetailsState();
}

class _OccasionDetailsState extends State<OccasionDetails> {
  String address = 'جاري التحميل ...';
  String sectionName;
  bool isMngr;
  List<String> time;
  @override
  void initState() {
    final reactiveMode = Injector.getAsReactive<OccasionsStore>();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Injector.getAsReactive<OccasionsStore>().resetToHasData();
    super.didChangeDependencies();
  }

  final creds = Injector.getAsReactive<AuthStore>().state.credentials?.data;

  @override
  Widget build(BuildContext context) {
   
    final size = MediaQuery.of(context).size;
    final mq = MediaQuery.of(context);
    // print(widget.occasion.userId);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey[300],
            body: buildOccasionDetailsBody()));
  }

  getOccasionData() {
    // print(widget.occasion.id);
    final rm = Injector.getAsReactive<OccasionsStore>();
    if (widget.occasion == null)
      rm.setState((state) async {
        widget.occasion = (await state.getOccationByID(widget.id)).data;
        // print('occcasionsss ${widget.occasion.toJson()}');
        rm.setState((state) async {
          return comments = await state.getComments(widget.occasion.id);
        });
        getAdditionalInfo();
        return widget.occasion;
      });
    else {
      getAdditionalInfo();
      rm.setState((state) async {
        return comments = await state.getComments(widget.occasion.id);
      });
    }
  }

  getAdditionalInfo() {
    final rm = Injector.getAsReactive<OccasionsStore>();
    time = widget.occasion.time.split(':');
    if (rm.state.allSectionsModel == null) {
      rm.setState((state) async => {
            await state.getAllSections(),
            sectionName = state.allSectionsModel.data
                .firstWhere(
                    (section) => section.id == widget.occasion.sectionId)
                .name,
          });
    } else
      sectionName = rm.state.allSectionsModel.data
          .firstWhere((section) => section.id == widget.occasion.sectionId)
          .name;

    print(widget.occasion.sectionId);
    isMngr = creds?.type == 2 &&
        widget.occasion.sectionId.toString() == creds.sectionId &&
        widget.occasion.isAccepted == 2;
  }

  GlobalKey _addressWidgetKey = GlobalKey();
  Widget onDataOccasionWidget() {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: size.width * 0.9,
              child: Column(
                children: <Widget>[
                  buildImage(),
                  buildOwnerName(),
                  buildDetail('${widget.occasion.date}', Icons.date_range),
                  buildDetail(
                      '${toArabic(TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1])).format(context))}',
                      Icons.access_time),
                  StatefulBuilder(
                      key: _addressWidgetKey,
                      builder: (context, stateSetter) {
                        return buildDetail(
                            '${widget.occasion.address}', Icons.location_on);
                      }),
                  buildDetail('$sectionName', Icons.grid_on),
                  actionBtn(),
                  ...buildComments()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AllCommentsModel comments;
  Widget buildOccasionDetailsBody() {
    getOccasionData();
    return WhenRebuilder<OccasionsStore>(
        onIdle: onDataOccasionWidget,
        onWaiting: () =>
            widget.occasion == null ? WaitingWidget() : onDataOccasionWidget(),
        onError: (e) => widget.occasion == null
            ? OnErrorWidget(e.toString())
            : onDataOccasionWidget(),
        onData: (_) => onDataOccasionWidget(),
        models: [Injector.getAsReactive<OccasionsStore>()]);
  }

  Widget buildDetail(String text, IconData iconData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Txt(text,
              style: TxtStyle()
                ..textAlign.right()
                ..textDirection(TextDirection.rtl)),
        )),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Icon(
            iconData,
            color: ColorsD.main,
          ),
        )
      ],
    );
  }

  Widget sendCommentBtn() {
    final size = MediaQuery.of(context).size;
    return Txt(
      'إرسال رسالة',
      gesture: Gestures()..onTap(() => sendCommentDialog(context)),
      style: StylesD.tawasolBtnStyle
        ..height(size.height / 18)
        ..width(size.width * 0.7),
    );
  }

  void headDecision(int decision) {
    final reactiveModel = Injector.getAsReactive<OccasionsStore>();
    reactiveModel
        .setState(
      (state) => state.mngrDecision(widget.occasion.isPublic,
          widget.occasion.id, widget.occasion.userId, decision),
    )
        .then(
      (_) => {
        reactiveModel.hasError
            ? {
                Toast.show('تعذر تغيير حالة المناسبة', context,
                    duration: Toast.LENGTH_LONG)
              }
            : {
                Toast.show(
                    '${decision == 0 ? 'تم رفض المناسبة' : 'تم قبول المناسبة'}',
                    context,
                    duration: Toast.LENGTH_LONG),
                reactiveModel
                    .setState((state) => state.getAllOccasions())
                    .then(Router.navigator.pop)
              }
      },
      onError: (e) {
        AlertDialogs.failed(
            content: 'تعذر تغيير حالة المناسبة\n$e', context: context);
      },
    );
  }

  Widget headDecisionBtn() {
    final size = MediaQuery.of(context).size;
    Widget onDataWidget = Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Txt("رفض",
                  style: StylesD.tawasolBtnStyle.clone()
                    ..textColor(ColorsD.main)
                    ..height(size.height / 18)
                    ..background.color(Colors.white),
                  gesture: Gestures()..onTap(() => headDecision(0))),
            ),
            Expanded(
              child: Txt(
                'قبول',
                style: StylesD.tawasolBtnStyle.clone()
                  ..height(size.height / 18),
                gesture: Gestures()..onTap(() => headDecision(1)),
              ),
            ),
          ],
        ));
    final reactiveModel = Injector.getAsReactive<OccasionsStore>();
    return WhenRebuilder(
        onIdle: () => onDataWidget,
        onWaiting: () => WaitingWidget(),
        onError: (e) {
          print('Error from head decision: $e');
          return onDataWidget;
        },
        onData: (data) => onDataWidget,
        models: [reactiveModel]);
  }

  Widget actionBtn() {
    print('ssss ${creds?.id}');
    if (creds?.id == widget.occasion.userId ||
        (creds?.type == 2 &&
            widget.occasion.isAccepted != 2 &&
            widget.occasion.sectionId.toString() == creds?.sectionId))
      return deleteOccasionBtn(context);
    else
      return isMngr ? headDecisionBtn() : sendCommentBtn();
  }

  deleteOccasin(BuildContext context) async {
    final size = MediaQuery.of(context).size;
    bool isDelete = await showDialog(
        context: context,
        builder: (contect) => AlertDialog(
              titlePadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: ColorsD.main)),
              title: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(
                    color: ColorsD.main,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        Txt(
                          'مسح مناسبة',
                          style: TxtStyle()
                            ..background.color(ColorsD.main)
                            ..textColor(Colors.white)
                            ..textAlign.right()
                            ..fontFamily('Cairo'),
                        ),
                      ],
                    ),
                  )),
              content: Txt(
                'هل تريد مسح المناسبة؟',
                style: TxtStyle()
                  ..textAlign.center()
                  ..fontFamily('Cairo'),
              ),
              actions: <Widget>[
                Container(
                  width: size.width * 0.7,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: Txt('رجوع',
                            style: StylesD.tawasolBtnStyle.clone()
                              ..height(size.height / 18),
                            gesture: Gestures()
                              ..onTap(() => Router.navigator.pop(false))),
                      ),
                      Expanded(
                        child: Txt('تأكيد',
                            style: StylesD.tawasolBtnStyle.clone()
                              ..height(size.height / 18),
                            gesture: Gestures()
                              ..onTap(() => Router.navigator.pop(true))),
                      ),
                    ],
                  ),
                )
              ],
            ));
    if (isDelete == true) {
      // Router.navigator.pop();
      final reactiveModel = Injector.getAsReactive<OccasionsStore>();
      reactiveModel.setState(
        (state) => state.deleteOccasion(widget.occasion.id).then((s) {
          if (reactiveModel.hasError)
            Toast.show('تعذر مسح المناسبة', context,
                duration: Toast.LENGTH_LONG);
          else
            reactiveModel.setState(
              (state) => state.getAllOccasions().then(
                (_) {
                  Router.navigator.pop();
                  Toast.show('تم مسح المناسبة', context,
                      duration: Toast.LENGTH_LONG);
                },
              ),
            );
        }, onError: (e) {
          AlertDialogs.failed(content: 'تعذر مسح المناسبة', context: context);
        }),
      );
    }
  }

  Widget deleteOccasionBtn(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Widget onIdle = Txt(
      'مسح المناسبة',
      style: StylesD.tawasolBtnStyle.clone()
        ..height(size.height / 18)
        ..width(size.width * 0.7)
        ..background.color(Colors.red),
      gesture: Gestures()..onTap(() => deleteOccasin(context)),
    );
    return WhenRebuilder(
        onIdle: () => onIdle,
        onWaiting: () => WaitingWidget(),
        onError: (e) {
          print('Error from delete occaion $e');

          return onIdle;
        },
        onData: (data) => onIdle,
        models: [Injector.getAsReactive<OccasionsStore>()]);
  }

  String content;
  TextEditingController _commentCtrler = TextEditingController();
  void sendCommentDialog(BuildContext context) {
    final reactiveModel = Injector.getAsReactive<OccasionsStore>();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: ColorsD.main)),
            titlePadding: EdgeInsets.zero,
            actions: <Widget>[sendCommentDialogBtn()],
            title: Txt(
              "ارسال رسالة الي ${widget.occasion.nameOwner}",
              style: TxtStyle()
                ..textAlign.right()
                ..textColor(Colors.white)
                ..borderRadius(topLeft: 20, topRight: 20)
                ..padding(right: 16)
                ..background.color(ColorsD.main)
                ..fontFamily('Cairo'),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 00.6,
              child: TextField(
                textAlign: TextAlign.right,
                maxLines: null,
                controller: _commentCtrler,
                style: TextStyle(
                    fontFamily: 'Cairo',
                    height: 1.4,
                    decorationStyle: TextDecorationStyle.solid),
                decoration: StylesD.inputDecoration2
                  ..contentPadding.add(EdgeInsets.only(left: 12)),
              ),
            )));
  }

  Widget sendCommentDialogBtn() {
    final size = MediaQuery.of(context).size;
    final reactiveModel = Injector.getAsReactive<OccasionsStore>();

    Widget onIdle = Txt('ارسال',
        style: StylesD.tawasolBtnStyle,
        gesture: Gestures()..onTap(() => sendComment()));
    Widget onData = Txt('الارسال',
        style: StylesD.tawasolBtnStyle,
        gesture: Gestures()
          ..onTap(() => sendComment()
            ..then((s) => [
                  if (Injector.getAsReactive<OccasionsStore>().hasError)
                    Toast.show('تعذر الإرسال', context,
                        duration: Toast.LENGTH_LONG)
                  else
                    {
                      Toast.show('تم إرسال الرسالة بنجاح', context,
                          duration: Toast.LENGTH_LONG),
                      Router.navigator.pop(),
                    },
                  _commentCtrler.clear()
                ])));
    Widget onError = Txt('تعذر الارسال',
        style: StylesD.tawasolBtnStyle,
        gesture: Gestures()..onTap(sendComment));
    return Container(
      width: size.width * 0.7,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: WhenRebuilder(
              onIdle: () => onIdle,
              onWaiting: () => WaitingWidget(),
              onData: (data) => onData,
              onError: (e) {
                print('Error from sendung comment: $e');
                return onError;
              },
              models: [reactiveModel],
            ),
          ),
        ],
      ),
    );
  }

  Future sendComment() =>
      Injector.getAsReactive<OccasionsStore>().setState((state) =>
          state.sendComment(_commentCtrler.text, widget.occasion.id, creds.id));

  Widget buildOwnerName() {
    return Txt(
      '${widget.occasion.nameOwner}',
      style: TxtStyle()
        ..textColor(ColorsD.main)
        ..padding(right: 12, top: 24)
        ..fontWeight(FontWeight.bold)
        ..fontSize(18)
        ..alignment.centerRight(),
    );
  }

  Widget buildImage() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 4,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageBuilder: (context, imageB) => Container(
            decoration: BoxDecoration(
              color: ColorsD.main,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(image: imageB, fit: BoxFit.contain),
            ),
          ),
          imageUrl: '${APIs.imageBaseUrl}occasions/${widget.occasion.image}',
        ),
      ),
    );
  }

  PreferredSize buildAppBar() {
    final size = MediaQuery.of(context).size;
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return PreferredSize(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
                child: Txt(
                  'الرجوع',
                  style: TxtStyle()..textColor(ColorsD.main),
                ),
                onTap: Router.navigator.pop),
            Txt(
              '${widget.occasion.nameOccasion}',
              style: TxtStyle()
                ..textColor(ColorsD.main)
                ..fontWeight(FontWeight.bold)
                ..fontSize(18)
                ..fontFamily('Cairo'),
            ),
            GestureDetector(
              child: Txt(
                '          ',
                style: TxtStyle()..textColor(ColorsD.main),
              ),
              // onTap: () => setState(() => isEdit = !isEdit),
            ),
          ],
        ),
      ),
      preferredSize: Size.fromHeight(100 - bottomInsets / 2.5),
    );
  }

  Widget buildSingleComment(Comment comment) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 8),
      height: size.height / 6,
      width: size.width * 0.85,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Txt('${comment.username}',
                    style: TxtStyle()
                      ..bold()
                      ..textColor(ColorsD.main)),
                SizedBox(width: 10),
                CachedNetworkImage(
                  imageUrl: '${APIs.imageBaseUrl}profile/${comment.userimage}',
                  imageBuilder: (context, imageB) => Container(
                    width: size.height / 16,
                    height: size.height / 16,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageB,
                          fit: BoxFit.cover,
                        )),
                  ),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Txt('${comment.content}',
                style: TxtStyle()
                  ..alignmentContent.coordinate(1, 0)
                  ..padding(right: 20)
                  ..textAlign.right()
                  ..textDirection(TextDirection.ltr)),
          )
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(blurRadius: 3, color: ColorsD.elevationColor)]),
    );
  }

  List<Widget> buildComments() {
    return comments == null
        ? [Container()]
        : List.generate(comments.data.length,
            (index) => buildSingleComment(comments.data[index]));
  }

  toArabic(String s) {
    return s
        .replaceAll('1', '١')
        .replaceAll('2', '٢')
        .replaceAll('3', '٣')
        .replaceAll('4', '٤')
        .replaceAll('5', '٥')
        .replaceAll('6', '٦')
        .replaceAll('7', '٧')
        .replaceAll('8', '٨')
        .replaceAll('9', '٩')
        .replaceAll('0', '٠')
        .replaceAll('-', '/')
        .replaceAll('PM', 'مساءََ')
        .replaceAll('AM', 'صباحاً');
  }
}
