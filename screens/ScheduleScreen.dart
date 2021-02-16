import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/ClassExamList.dart';
import 'package:Creativebuffer/utils/modal/ClassExamSchedule.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/ExamRow.dart';
// ignore: must_be_immutable
class ScheduleScreen extends StatefulWidget {

  var id;


  ScheduleScreen({this.id});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState(id: id);
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  var _selected;

  Future<ClassExamList> exams;
  Future<classExamScheduleList> examlist;
  var id;
  int code;


  _ScheduleScreenState({this.id});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        id = id != null ? id : value;
        exams = getAllClassExam(id);
        examlist = getAllClassExamSchedule(id, code);
        exams.then((val) {
          _selected = val.exams[0].examName;
          code = val.exams[0].examId;
          examlist = getAllClassExamSchedule(id, code);
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
        appBar: AppBarWidget.header(context, 'Schedule'),
        backgroundColor: Colors.white,
        body: FutureBuilder<ClassExamList>(
          future: exams,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  getDropdown(snapshot.data.exams),
                  SizedBox(
                    height: 15.0,
                  ),
                  Expanded(child: getExamList())
                ],
              );
            } else {
              return Center(child: Text("loading..."));
            }
          },
        ),
      ),
    );
  }

  Widget getDropdown(List<ClassExamName> exams) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: exams.map((item) {
          return DropdownMenuItem<String>(
            value: item.examName,
            child: Text(item.examName),
          );
        }).toList(),
        style: Theme.of(context).textTheme.display1.copyWith(fontSize: 15.0),
        onChanged: (value) {
          setState(() {
            _selected = value;

            code = getExamCode(exams, value);

            debugPrint('User select $value');

            examlist = getAllClassExamSchedule(id, code);

            getExamList();
          });
        },
        value: _selected,
      ),
    );
  }

  Widget getExamList() {
    return FutureBuilder<classExamScheduleList>(
      future: examlist,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.exams.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return StudentExamRow(snapshot.data.exams[index]);
            },
          );
        } else {
          return Center(child: Text("loading..."));
        }
      },
    );
  }

  int getExamCode(List<ClassExamName> exams, String title) {
    int code;

    for (ClassExamName exam in exams) {
      if (exam.examName == title) {
        code = exam.examId;
        break;
      }
    }
    return code;
  }

  Future<ClassExamList> getAllClassExam(var id) async {
    final response = await http.get(InfixApi.getStudentClassExamName(id));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return ClassExamList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<classExamScheduleList> getAllClassExamSchedule(
      var id, int code) async {
    final response =
        await http.get(InfixApi.getStudentClsExamShedule(id, code));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return classExamScheduleList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
