import 'package:flutter/material.dart';
import 'package:Creativebuffer/utils/modal/Teacher.dart';


// ignore: must_be_immutable
class StudentTeacherRowLayout extends StatelessWidget {

  Teacher teacher;
  int per;


  StudentTeacherRowLayout(this.teacher,this.per);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child:  Text(teacher.teacherName,style:Theme.of(context).textTheme.display1.copyWith(fontSize: 10.0)),
              ),
              Expanded(
                child:  Text(teacher.teacherEmail,style:Theme.of(context).textTheme.display1.copyWith(fontSize: 10.0)),
              ),
              Expanded(
                child:  Text(per == 1 ? teacher.teacherPhone: 'not available',style:Theme.of(context).textTheme.display1.copyWith(fontSize: 10.0)),
              ),
            ],
          ),
        ),
        Container(
          height: 0.5,
          margin: EdgeInsets.only(top: 10.0,bottom: 5.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Colors.purple, Colors.deepPurple]),
          ),
        ),
      ],
    );
  }
}
