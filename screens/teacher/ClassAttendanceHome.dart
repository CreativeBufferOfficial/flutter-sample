import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Classes.dart';
import 'package:Creativebuffer/utils/modal/Section.dart';
import 'dart:convert';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/ScaleRoute.dart';
import 'AttendanceStudentList.dart';

class StudentAttendanceHome extends StatefulWidget {
  @override
  _StudentAttendanceHomeState createState() => _StudentAttendanceHomeState();
}

class _StudentAttendanceHomeState extends State<StudentAttendanceHome> {
  String _id;
  int classId;
  int sectionId;
  String _selectedClass;
  String _selectedSection;
  Future<ClassList> classes;
  Future<SectionList> sections;
  DateTime date;
  String day, year, month;
  String url;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    date = DateTime.now();
    Utils.getStringValue('id').then((value) {
      setState(() {
        _id = value;
        year = '${date.year}';
        month = getAbsoluteDate(date.month);
        day = getAbsoluteDate(date.day);
        classes = getAllClass(int.parse(_id));
        classes.then((value) {
          _selectedClass = value.classes[0].name;
          classId = value.classes[0].id;
          sections = getAllSection(int.parse(_id), classId);
          sections.then((sectionValue) {
            _selectedSection = sectionValue.sections[0].name;
            sectionId = sectionValue.sections[0].id;
            url = InfixApi.getStudentByClassAndSection(
                classId, sectionId);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
    ));

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Scaffold(
        appBar: AppBarWidget.header(context, 'Attendance'),
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<ClassList>(
              future: classes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: <Widget>[
                      getClassDropdown(snapshot.data.classes),
                      FutureBuilder<SectionList>(
                        future: sections,
                        builder: (context, secSnap) {
                          if (secSnap.hasData) {
                            return getSectionDropdown(secSnap.data.sections);
                          } else {
                            return Center(child: Text("loading..."));
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: Text(
                                  '$year - $month - $day',
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(fontSize: 15.0),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.black12,
                              size: 20.0,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).size.height * 0.45),
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.purple,
                            ),
                            child: Text(
                              "Search",
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(
                                      color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              ScaleRoute(
                                  page: StudentListAttendance(classCode: classId,sectionCode: sectionId,url: url,date: '$year-$month-$day',)));
                        },
                      )
                    ],
                  );
                } else {
                  return Center(child: Text("loading..."));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget getClassDropdown(List<Classes> classes) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: classes.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(item.name),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.display1.copyWith(fontSize: 15.0),
        onChanged: (value) {
          setState(() {
            _selectedClass = value;

            classId = getCode(classes, value);

            debugPrint('User select $classId');
          });
        },
        value: _selectedClass,
      ),
    );
  }

  Widget getSectionDropdown(List<Section> sectionlist) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: sectionlist.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(item.name),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.display1.copyWith(fontSize: 15.0),
        onChanged: (value) {
          setState(() {
            _selectedSection = value;

            sectionId = getCode(sectionlist, value);

            debugPrint('User select $sectionId');
          });
        },
        value: _selectedSection,
      ),
    );
  }

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  int getCode<T>(T t, String title) {
    int code;
    for (var cls in t) {
      if (cls.name == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  Future<ClassList> getAllClass(int id) async {
    final response = await http.get(InfixApi.getClassById(id));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return ClassList.fromJson(jsonData['data']['teacher_classes']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<SectionList> getAllSection(int id, int classId) async {
    final response = await http.get(InfixApi.getSectionById(id, classId));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return SectionList.fromJson(jsonData['data']['teacher_sections']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
