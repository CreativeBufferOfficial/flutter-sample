import 'package:flutter/material.dart';

// ignore: must_be_immutable
class  RoutineRowDesign extends StatelessWidget {

  String time;
  String subject;
  String room;


  RoutineRowDesign(this.time, this.subject, this.room);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child:  Text(time,style:Theme.of(context).textTheme.display1),
          ),
          Expanded(
            child:  Text(subject,style:Theme.of(context).textTheme.display1),
          ),
          Expanded(
            child:  Text(room,style:Theme.of(context).textTheme.display1),
          ),
        ],
      ),
    );
  }
}
