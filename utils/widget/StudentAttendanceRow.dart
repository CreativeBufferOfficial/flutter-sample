import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/GlobalClass.dart';
import 'package:Creativebuffer/utils/modal/Student.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class StudentAttendanceRow extends StatefulWidget {
  Student student;
  String mClass, mSection, date;

  StudentAttendanceRow(this.student, this.mClass, this.mSection, this.date);

  @override
  _StudentAttendanceRowState createState() =>
      _StudentAttendanceRowState(student, mClass, mSection, date);
}

class _StudentAttendanceRowState extends State<StudentAttendanceRow> {
  Student student;
  bool isSelected = true;
  String mClass, mSection, date;
  String atten = 'P';
  var function = GlobalDatae();
  Future<bool> isChecked;

  _StudentAttendanceRowState(
      this.student, this.mClass, this.mSection, this.date);

//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//
//    isChecked = checkAttendance();
//    isChecked.then((value){
//      if(value){
//        setDefaultAttendance();
//      }
//    });
//
//  }

  @override
  Widget build(BuildContext context) {
    String image = InfixApi.root + student.photo;
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          atten = isSelected ? 'P' : 'A';
          isSelected ? function.sub() : function.add();
          setAttendance();
        });
      },
      splashColor: Colors.purple.shade200,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: !isSelected
                ? CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.greenAccent.shade700,
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                  )
                : CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(image == InfixApi.root
                        ? 'http://saskolhmg.com/images/studentprofile.png'
                        : InfixApi.root + student.photo),
                    backgroundColor: Colors.grey,
                  ),
            title: Text(
              student.name,
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: Text(
                'Class : ${student.className} | Section : ${student.sectionName}',
                style: Theme.of(context).textTheme.display1),
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Colors.purple, Colors.deepPurple]),
            ),
          )
        ],
      ),
    );
  }

  void setAttendance() async {
    final response = await http.get(InfixApi.attendanceDataSend(
        '${student.uid}', atten, date, mClass, mSection));
    if (response.statusCode == 200) {
      debugPrint('Attendance successful');
    } else {
      throw Exception('Failed to load');
    }
  }

//  void setDefaultAttendance() async {
//    final response = await http.get(InfixApi.attendance_defalut_send(date, mClass, mSection));
//    if (response.statusCode == 200) {
//      debugPrint('Attendance default successful');
//    } else {
//      throw Exception('Failed to load');
//    }
//  }
  Future<bool> checkAttendance() async {
    final response =
        await http.get(InfixApi.attendanceCheck(date, mClass, mSection));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData['success'];
    } else {
      throw Exception('Failed to load');
    }
  }
}
