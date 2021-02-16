import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/GlobalClass.dart';
import 'package:Creativebuffer/utils/modal/Student.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/StudentAttendanceRow.dart';

// ignore: must_be_immutable
class StudentListAttendance extends StatefulWidget {
  int classCode;
  int sectionCode;
  String url;
  String date;

  StudentListAttendance(
      {this.classCode, this.sectionCode,this.url,this.date});

  @override
  _StudentListAttendanceState createState() => _StudentListAttendanceState(
      classCode: classCode,
      sectionCode: sectionCode,
      date: date,
      url: url);
}

class _StudentListAttendanceState extends State<StudentListAttendance> {
  int classCode;
  int sectionCode;
  String url;
  Future<StudentList> students;
  String date;
  List<String> absent = List<String>();
  int totalStudent = 0;
  var function = GlobalDatae();
  GlobalKey _key = GlobalKey();


  _StudentListAttendanceState(
      {this.classCode, this.sectionCode,this.url,this.date});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('${widget.date}');
    setState(() {
      function.setZero();
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
        key: _key,
        appBar: AppBarWidget.header(context, 'Student Attendance'),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<StudentList>(
                future: students,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    totalStudent = snapshot.data.students.length;
                    return ListView.builder(
                      itemCount: snapshot.data.students.length,
                      itemBuilder: (context, index) {
                        return StudentAttendanceRow(snapshot.data.students[index],'$classCode','$sectionCode',date);
                      },
                    );
                  } else {
                    return Center(child: Text("loading..."));
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15.0,left: 10.0,right: 10.0,top: 5.0),
              child: GestureDetector(
                child:Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.purple,
                    ),
                    child: Text(
                      "Save",
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .copyWith(
                          color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                onTap: () {
                  showAlertDialog(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void sentNotificationToSection() async{
    final response = await http.get(InfixApi.sentNotificationToSection('Attendance', 'Attendance sunmitted','$classCode','$sectionCode'));
    if(response.statusCode == 200){
    }
  }

  Future<StudentList> getAllStudent() async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return StudentList.fromJson(jsonData['data']['students']);
    } else {
      throw Exception('Failed to load');
    }
  }
  showAlertDialog(BuildContext context) {

    showDialog<void>(
      barrierDismissible: false,
      context: _key.currentContext,
      builder: (BuildContext context) {

        if(function.getAbsent() == 0){
         setDefaultAttendance();
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child:  Padding(
                  padding: const EdgeInsets.only(left: 10.0,top: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Card(
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.greenAccent.shade700,
                            child: Icon(Icons.done,color: Colors.white,),
                          ),
                            elevation: 18.0,
                            shape: CircleBorder(),
                            clipBehavior: Clip.antiAlias
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'Success!',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.w500,fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'Total student : $totalStudent',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'Total Absent : ${function.getAbsent()}',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0,left: 10.0,right: 10.0,top: 15.0),
                        child: GestureDetector(
                          child:Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.purple,
                            ),
                            child: Text(
                              "OK",
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                          onTap: () {
                            sentNotificationToSection();
                            Navigator.pop(_key.currentContext);
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
  void setDefaultAttendance() async {
    print(InfixApi.attendanceDefaultSent(date, '$classCode', '$sectionCode'));
    final response = await http.get(InfixApi.attendanceDefaultSent(date, '$classCode', '$sectionCode'));
    if (response.statusCode == 200) {
      debugPrint('Attendance default successful');
    } else {
      throw Exception('Failed to load');
    }
  }
}
