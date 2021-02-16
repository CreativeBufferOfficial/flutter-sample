import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/modal/Student.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/StudentSearchRow.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class StudentSearchNameRoll extends StatefulWidget {
  String name;
  String roll;
  String url;

  StudentSearchNameRoll({this.name, this.roll, this.url});

  @override
  _StudentSearchNameRollState createState() =>
      _StudentSearchNameRollState(name: name, roll: roll, url: url);
}

class _StudentSearchNameRollState extends State<StudentSearchNameRoll> {
  String name;
  String roll;
  String url;
  Future<Student> student;

  _StudentSearchNameRollState({this.name, this.roll, this.url});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      student = getSearchStudent();
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
        appBar: AppBarWidget.header(context, 'Student List'),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: FutureBuilder<Student>(
          future: student,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return StudentRow(snapshot.data);
                },
              );
            } else {
              return Center(child: Text("loading..."));
            }
          },
        ),
      ),
    );
  }

  Future<Student> getSearchStudent() async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return Student.fromJson(jsonData['data']['students']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
