import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:division/division.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/data/models/sav_occasion_model.dart';
import 'package:tawasool/data/models/search_users_model.dart';
import 'package:tawasool/presentation/mainPage.dart';
import 'package:tawasool/presentation/store/auth_store.dart';
import 'package:tawasool/presentation/store/occasions_store.dart';
import 'package:tawasool/presentation/widgets/add_event_btn.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tawasool/presentation/widgets/error_widget.dart';
import 'package:tawasool/presentation/widgets/idle_widget.dart';
import 'package:tawasool/presentation/widgets/tet_field_with_title.dart';
import 'package:tawasool/presentation/widgets/waiting_widget.dart';
import 'package:tawasool/router.gr.dart';
import 'package:toast/toast.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  List<String> eventDepartment = [
    'مناسبة خاصة بقسم',
    'مناسبة عامة',
    'مناسبة لأشخاص معينة'
  ];
  String selectedDepType;
  @override
  void didChangeDependencies() {
    final reactiveModel = Injector.getAsReactive<OccasionsStore>();
    reactiveModel.resetToIdle();
    // TODO: implement didChangeDependencies
    // FocusScope.of(context).requestFocus(FocusNode());
    super.didChangeDependencies();
  }

  TextEditingController ownerNameCtrler = TextEditingController();
  TextEditingController occasionNameCtrler = TextEditingController();
  TextEditingController dateCtrler = TextEditingController();
  TextEditingController timeCtrler = TextEditingController();
  TextEditingController locationCtrler = TextEditingController();
  @override
  void dispose() {
    final reactiveModel = Injector.getAsReactive<OccasionsStore>();
    reactiveModel.resetToIdle();
    ownerNameCtrler.dispose();
    occasionNameCtrler.dispose();
    dateCtrler.dispose();
    timeCtrler.dispose();
    locationCtrler.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(locationCtrler.text);
    return Scaffold(
      backgroundColor: ColorsD.backGroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: NestedScrollView(
            headerSliverBuilder: (contet, isScrolled) => [
              SliverPersistentHeader(
                floating: true,
                pinned: true,
                delegate: SliverHeader(
                    maHeight: size.height / 5.2,
                    minHeight: size.height / 8.2,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Container(
                        decoration: BoxDecoration(
                          color: ColorsD.backGroundColor,
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Txt(
                                  'رجوع',
                                  style: TxtStyle()
                                    ..width(size.width / 12)
                                    ..textColor(ColorsD.main),
                                  gesture: Gestures()
                                    ..onTap(Router.navigator.pop),
                                ),
                                Image.asset('assets/icons/logo.png'),
                                Txt('',
                                    style: TxtStyle()..width(size.width / 12)),
                              ],
                            ),
                            constraints.biggest.height < size.height / 5.2
                                ? Container()
                                : Txt(
                                    'المؤسسة العامة للتدريب التقنى والمهنى\nالكلية التقنية بأبها',
                                    style: TxtStyle()
                                      ..alignment.center()
                                      ..alignmentContent.center()
                                      ..textAlign.center(),
                                  )
                          ],
                        ),
                      );
                    })),
              )
            ],
            body: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    imageWidget(),
                    TetFieldWithTitle(
                      title: 'إسم صاحب المناسبة',
                      textEditingController: ownerNameCtrler,
                    ),
                    TetFieldWithTitle(
                      title: 'إسم المناسبة',
                      textEditingController: occasionNameCtrler,
                    ),
                    TetFieldWithTitle(
                        title: "تاريخ المناسبة",
                        textEditingController: dateCtrler,
                        icon: InkWell(
                          onTap: selectDate,
                          child: Icon(Icons.date_range, color: ColorsD.main),
                        )),
                    TetFieldWithTitle(
                      title: 'وقت المناسبة',
                      textEditingController: timeCtrler,
                      icon: InkWell(
                        onTap: selectTime,
                        child: Icon(Icons.timer, color: ColorsD.main),
                      ),
                    ),
                    TetFieldWithTitle(
                      title: 'مكان المناسبة',
                      textEditingController: locationCtrler,
                      icon: InkWell(
                          onTap: setLocation,
                          child: Icon(
                            Icons.location_on,
                            color: ColorsD.main,
                          )),
                    ),
                    typeDropDown(departmentDropDownBtn()),
                    depart(),
                    actionBtn(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  selectTime() async {
    final TimeOfDay tempTime =
        (await showTimePicker(context: context, initialTime: TimeOfDay.now()));
    timeCtrler.text =
        '${tempTime.hour.toString().padLeft(2, '0')}:${tempTime.minute.toString().padLeft(2, '0')}' ??
            '';
  }

  selectDate() async {
    final tempDate = (await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 360)),
        lastDate: DateTime(2100)));
    dateCtrler.text =
        tempDate == null ? '' : tempDate.toString().split(' ').first;
  }

  Position position;
  setLocation() async {
    final permission =
        await PermissionHandler().checkServiceStatus(PermissionGroup.location);
    if (permission == ServiceStatus.disabled) {
      if (await AlertDialogs.failed(
              content: 'من فضلك قم بفتح الـ GPS', context: context) ==
          true) {
        AppSettings.openLocationSettings();
      }
    }
    position = (await Router.navigator.pushNamed(Router.map) as Position);
    print(position);
    Address address = (await Geocoder.local.findAddressesFromCoordinates(
            Coordinates(position?.latitude, position?.longitude)))
        ?.first;
    locationCtrler.text = address?.addressLine ?? 'f';
  }

  Future saveOccasion() async {
    final List<int> selectedPeopleIDs =
        List.generate(selectedPeople.length, (i) => selectedPeople[i].id);
    final reactiveModel = Injector.getAsReactive<OccasionsStore>();
    // print(reactiveModel.state.allSectionsModel.data
    //     .firstWhere((section) => section.name == selectedSection)
    //     .id
    //     .toString());
    return await reactiveModel.setState(
      (state) async => state.saveOccasion({
        // 'image':  image.path,
        'address': locationCtrler.text,
        'user_id': Injector.getAsReactive<AuthStore>()
            .state
            .credentials
            .data
            .id
            .toString(),
        'date': dateCtrler.text,
        'time': timeCtrler.text,
        'lat':
            position?.latitude == null ? '0.0' : position?.latitude.toString(),
        'lng': position?.longitude == null
            ? '0.0'
            : position?.longitude.toString(),
        'is_public': selectedDep.toString(),
        'is_accepted':
            Injector.getAsReactive<AuthStore>().state.credentials.data.type == 0
                ? '2'
                : '1',
        'name_occasion': occasionNameCtrler.text,
        'name_owner': ownerNameCtrler.text,
        'check_manger':
            Injector.getAsReactive<AuthStore>().state.credentials.data.type == 0
                ? '0'
                : '1',
        'section_id': selectedDep == 0
            ? reactiveModel.state.allSectionsModel.data
                .firstWhere((section) => section.name == selectedSection)
                .id
                .toString()
            : '1'
      }, image.path, selectedPeopleIDs),
    );
  }

  saveAndUpateOccasions() {
    if (image == null) {
      AlertDialogs.failed(content: 'من فضلك أدخل صورة شخصية', context: context);
      return null;
    }
    saveOccasion().then(
      (_) {
        if (Injector.getAsReactive<OccasionsStore>().hasError)
          Toast.show(
              'تعذر إضافة مناسبة من فضلك تأكد من صحة البيانات وأعد المحاولة',
              context,
              duration: Toast.LENGTH_LONG);
        else
          Injector.getAsReactive<OccasionsStore>().setState((state) => {
                state.getAllOccasions().then((_) => Router.navigator.pop()),
                Toast.show('تم إضافة المناسبة بنجاح', context,
                    duration: Toast.LENGTH_LONG)
              });
      },
    );
  }

  Widget actionBtn() {
    final size = MediaQuery.of(context).size;
    final rm = Injector.getAsReactive<AuthStore>();
    if (rm.state.isAuth)
      return saveOccasionBtn();
    else
      return Txt(
        'من فضلك قم بتسجيل الدخول',
        gesture: Gestures()
          ..onTap(() => Router.navigator.pushNamed(Router.loginPage)),
        style: StylesD.txtOnCardStyle.clone()
          ..textColor(Colors.red)
          ..height(size.height / 18)
          ..margin(all: 16),
      );
  }

  Widget saveOccasionBtn() {
    final size = MediaQuery.of(context).size;
    Widget onIdleWidget = Txt(
      'اضافة مناسبة',
      gesture: Gestures()..onTap(saveAndUpateOccasions),
      style: StylesD.txtOnCardStyle.clone()
        ..height(size.height / 18)
        ..margin(all: 16),
    );
    Widget onErrorWidget = Txt(
      'اضافة مناسبة',
      gesture: Gestures()..onTap(saveAndUpateOccasions),
      style: StylesD.txtOnCardStyle.clone()
        ..textColor(Colors.red)
        ..height(size.height / 18)
        ..margin(all: 16),
    );
    Widget onDataWidget = Txt(
      'اضافة مناسبة',
      gesture: Gestures()..onTap(saveAndUpateOccasions),
      style: StylesD.txtOnCardStyle.clone()
        // ..textColor(Colors.red)
        ..height(size.height / 18)
        ..width(size.width * 0.7)
        ..margin(vertical: 16),
    );
    final reactiveModel = Injector.getAsReactive<OccasionsStore>();
    return WhenRebuilder(
      models: [reactiveModel],
      onIdle: () => onIdleWidget,
      onWaiting: () => WaitingWidget(),
      onData: (data) => onDataWidget,
      onError: (e) {
        print(e);
        Future.delayed(Duration(milliseconds: 10),
            () => AlertDialogs.failed(content: '$e', context: context));
        return onErrorWidget;
      },
    );
  }

  File image;
  selectImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Widget imageWidget() {
    bool hasImage = image != null;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: selectImage,
      child: Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: hasImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: ColorsD.main,
                    child: Image.file(
                      image,
                      height: size.height / 4,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ))
              : DottedBorder(
                  strokeCap: StrokeCap.butt,
                  radius: Radius.circular(12),
                  borderType: BorderType.RRect,
                  strokeWidth: 3,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.image,
                          size: 45,
                        ),
                        Txt('إختر صورة')
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget selectSection(Widget dropDownBtn) {
    return typeDropDown(dropDownBtn);
  }

  List<User> selectedPeople = [];

  Widget selectPeople() {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.72,
      child: Wrap(
        alignment: WrapAlignment.start,
        textDirection: TextDirection.rtl,
        // crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        children: <Widget>[
          ...List.generate(
            selectedPeople.length,
            (index) {
              return personChip(index);
            },
          ),
          searchPeople(),
        ],
      ),
    );
  }

  Widget personChip(int index) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.padded,
        deleteIconColor: ColorsD.main,
        avatar: Icon(Icons.person_outline),
        deleteIcon: Icon(Icons.close),
        onDeleted: () => [selectedPeople.removeAt(index), setState(() {})],
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        label: Txt(
          selectedPeople[index].name,
          gesture: Gestures()
            ..onLongPress(
                () => [selectedPeople.removeAt(index), setState(() {})]),
        ),
      ),
    );
  }

  Widget searchPeople() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 16),
      child: Container(
        width: size.width * 0.8,
        child: TypeAheadField<User>(
          textFieldConfiguration: TextFieldConfiguration(
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Cairo'),
              decoration: StylesD.inputDecoration2),
          autoFlipDirection: true,
          hideOnLoading: false,
          suggestionsCallback: (name) async {
            final reactiveModel = Injector.getAsReactive<OccasionsStore>();
            return reactiveModel.state.searchUsers(name);
          },
          loadingBuilder: (_) => WaitingWidget(),
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
            borderRadius: BorderRadius.circular(12),
            hasScrollbar: true,
          ),
          itemBuilder: (context, user) => Align(
            alignment: FractionalOffset(0.9, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Txt('${user.name}', style: TxtStyle()),
                Txt('${user.phone}', style: TxtStyle()..textColor(Colors.grey)),
              ],
            ),
          ),
          onSuggestionSelected: (name) {
            selectedPeople.add(name);
            final tempSet = Set.of(selectedPeople);
            selectedPeople = tempSet.toList();
            setState(() {});
          },
        ),
      ),
    );
  }

  int selectedDep;
  Widget depart() {
    selectedDep = eventDepartment.indexOf(selectedDepType);
    if (selectedDep == 0) return selectSection(sectionsDropDownBtn());
    if (selectedDep == 1) return Container();
    if (selectedDep == 2) return selectPeople();
    return Container();
  }

  ScrollController scrollController;
  Widget typeDropDown(Widget dropDownBtn) {
    // scrollController.jumpTo(scrollController.position.)
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, top: 8),
      child: Container(
        width: size.width * 0.7,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: ColorsD.main),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: dropDownBtn,
        ),
      ),
    );
  }

  String selectedSection;
  Widget sectionsDropDownBtn() {
    final reactiveModel = Injector.getAsReactive<OccasionsStore>();
    if (reactiveModel.state.allSectionsModel == null) {
      reactiveModel.resetToIdle();
      reactiveModel.setState((state) => state.getAllSections());
    } else
      reactiveModel.resetToHasData();
    return WhenRebuilder<OccasionsStore>(
      models: [reactiveModel],
      onWaiting: () => WaitingWidget(),
      onIdle: () => IdleWidget(
        data: 'لا توجد أقسام',
      ),
      onError: (e) => OnErrorWidget('حدث خطأ في الإتصال',
          () => reactiveModel.setState((state) => state.getAllSections())),
      onData: (sectionData) {
        final sections = sectionData.allSectionsModel.data;
        final List<String> sectionNames = List.generate(
            sectionData.allSectionsModel.data.length,
            (index) => sections[index].name);

        return DropdownButton(
          isExpanded: true,
          hint: Txt(
            '-اختر القسم-',
            style: TxtStyle()..fontFamily('Cairo'),
          ),
          // value: 's',
          underline: Container(),
          value: selectedSection,
          items: List.generate(
            sectionData.allSectionsModel.data.length,
            (index) {
              final currentSection = sectionData.allSectionsModel.data[index];
              return DropdownMenuItem(
                child: Txt(
                  sectionNames[index],
                  style: TxtStyle()
                    ..textAlign.right()
                    ..textDirection(TextDirection.rtl)
                    ..alignment.centerRight()
                    ..fontFamily('Cairo'),
                ),
                value: sectionNames[index],
              );
            },
          ),
          onChanged: (s) {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() => selectedSection = s);
          },
        );
      },
    );
  }

  Widget departmentDropDownBtn() {
    return DropdownButton(
      isExpanded: true,
      hint: Txt(
        '--اختر القسم--',
        style: TxtStyle()..fontFamily('Cairo'),
      ),
      // value: 's',9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999**********************
      underline: Container(),
      value: selectedDepType,
      items: List.generate(
          eventDepartment.length,
          (index) => DropdownMenuItem(
                child: Txt(
                  eventDepartment[index],
                  style: TxtStyle()
                    ..textAlign.right()
                    ..textDirection(TextDirection.rtl)
                    ..alignment.centerRight()
                    ..fontFamily('Cairo'),
                ),
                value: eventDepartment[index],
              )),
      onChanged: (s) {
        setState(
          () {
            selectedDepType = s;
          },
        );
      },
    );
  }
}
