import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Creativebuffer/utils/modal/Student.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/StudentSearchRow.dart';

// ignore: must_be_immutable
class StudentListScreen extends StatefulWidget {
  int classCode;
  int sectionCode;
  String name;
  String roll;
  String url;
  String status;

  StudentListScreen(
      {this.classCode, this.sectionCode, this.name, this.roll, this.url,this.status});

  @override
  _StudentListScreenState createState() => _StudentListScreenState(
      classCode: classCode,
      sectionCode: sectionCode,
      name: name,
      roll: roll,
      url: url,
      status: status
  );
}

class _StudentListScreenState extends State<StudentListScreen> {
  int classCode;
  int sectionCode;
  String name;
  String roll;
  String url;
  Future<StudentList> students;
  String status;

  _StudentListScreenState(
      {this.classCode, this.sectionCode, this.name, this.roll, this.url,this.status});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      students = getAllStudent();
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
        body: FutureBuilder<StudentList>(
          future: students,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.students.length,
                itemBuilder: (context, index) {
                  return StudentRow(snapshot.data.students[index],status: status,);
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

  Future<StudentList> getAllStudent() async {
    final response = await http.get(url);

    print(url);
    print(response.body);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return StudentList.fromJson(jsonData['data']['students']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
