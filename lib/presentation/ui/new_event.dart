import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/presentation/mainPage.dart';
import 'package:tawasool/presentation/widgets/tet_field_with_title.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  List<String> eventDepartment = [
    'مناسبة عامة',
    'مناسبة خاصة بقسم',
    'مناسبة لأشخاص معينة'
  ];
  String selectedDepType;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // FocusScope.of(context).requestFocus(FocusNode());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                            Image.asset('assets/icons/logo.png'),
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
              child: Column(
                children: <Widget>[
                  TetFieldWithTitle(
                    title: 'إسم صاحب المناسبة',
                  ),
                  TetFieldWithTitle(
                    title: 'إسم المناسبة',
                  ),
                  TetFieldWithTitle(
                    title: "تاريخ المناسبة",
                  ),
                  TetFieldWithTitle(
                    title: 'وقت المناسبة',
                  ),
                  TetFieldWithTitle(
                    title: 'مكان المناسبة',
                  ),
                  typeDropDown(departmentDropDownBtn())
                ]..add(depart()),
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

  List selectedPeople = [];
  Widget selectPeople() {
    return Column(
      children: <Widget>[
        ...List.generate(selectedPeople.length, (index) {
          return Txt(
            selectedPeople[index],
            gesture: Gestures()
              ..onLongPress(
                  () => [selectedPeople.removeAt(index), setState(() {})]),
          );
        }),
        TypeAheadField(
          // direction: AxisDirection.up,
          autoFlipDirection: true,
          hideOnLoading: false,
          suggestionsCallback: (name) async {
            return await Future.sync(() => eventDepartment.where((item) =>
                item.toLowerCase().contains(name.toLowerCase()) &&
                name.isNotEmpty));
          },
          itemBuilder: (context, name) => Txt('$name'),
          onSuggestionSelected: (name) => [
            selectedPeople.add('$name'),
            setState(() {}),
          ],
        ),
      ],
    );
  }

  Widget depart() {
    int selectedDep = eventDepartment.indexOf(selectedDepType);
    if (selectedDep == 0) return Container();
    if (selectedDep == 1) return selectSection(sectionsDropDownBtn());
    if (selectedDep == 2) return selectPeople();
    return Container();
  }

  Widget typeDropDown(Widget dropDownBtn) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
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

  Widget sectionsDropDownBtn() {
    return DropdownButton(
      isExpanded: true,
      hint: Txt('-اختر القسم-'),
      // value: 's',
      underline: Container(),
      value: selectedDepType,
      items: List.generate(
          eventDepartment.length,
          (index) => DropdownMenuItem(
                child: Txt(
                  eventDepartment[index],
                  style: TxtStyle()
                    ..alignment.centerRight()
                    ..fontFamily('Cairo'),
                ),
                value: eventDepartment[index],
              )),
      onChanged: (s) {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(
          () {
            selectedDepType = s;
          },
        );
      },
    );
  }

  Widget departmentDropDownBtn() {
    return DropdownButton(
      isExpanded: true,
      hint: Txt('-اختر القسم-'),
      // value: 's',
      underline: Container(),
      value: selectedDepType,
      items: List.generate(
          eventDepartment.length,
          (index) => DropdownMenuItem(
                child: Txt(
                  eventDepartment[index],
                  style: TxtStyle()
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
