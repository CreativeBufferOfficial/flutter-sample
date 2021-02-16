import 'package:flutter/material.dart';
import 'package:Creativebuffer/utils/modal/TeacherSubject.dart';

// ignore: must_be_immutable
class TeacherSubjectRowLayout extends StatelessWidget {

  TeacherSubject subject;


  TeacherSubjectRowLayout(this.subject);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child:  Text(subject.subjectName,style:Theme.of(context).textTheme.display1),
              ),
              Expanded(
                child:  Text(subject.subjectCode,style:Theme.of(context).textTheme.display1),
              ),
              Expanded(
                child:  Text(subject.subjectType == 'T' ? 'Theory' : 'Lab',style:Theme.of(context).textTheme.display1),
              ),
            ],
          ),
        ),
        Container(
          height: 0.5,
          margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
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
