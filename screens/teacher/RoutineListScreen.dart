import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/FunctinsData.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/Routine_row.dart';

// ignore: must_be_immutable
class StudentRoutine extends StatelessWidget {

  List<String> weeks = AppFunction.weeks;
  int classCode;
  int sectionCode;


  StudentRoutine(this.classCode, this.sectionCode);

  @override
  Widget build(BuildContext context) {

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
    ));

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Scaffold(
        appBar: AppBarWidget.header(context, 'Routine'),
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemCount: weeks.length,
          itemBuilder: (context,index){
            return RoutineRow(title:weeks[index],classCode: classCode,sectionCode: sectionCode,);
          },
        ),
      ),
    );
  }

}
