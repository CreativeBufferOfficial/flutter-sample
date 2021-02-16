import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/TeacherSubject.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/TeacherSubjectRow.dart';

class MySubjectScreen extends StatefulWidget {
  @override
  _MySubjectScreenState createState() => _MySubjectScreenState();
}

class _MySubjectScreenState extends State<MySubjectScreen> {
  Future<TeacherSubjectList> subjects;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        subjects = getAllSubject(int.parse(value));
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
        appBar: AppBarWidget.header(context, 'Subjects'),
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Subject',
                          style: Theme.of(context).textTheme.display1.copyWith(
                              fontSize: 13.0, fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
                      child: Text('Code',
                          style: Theme.of(context).textTheme.display1.copyWith(
                              fontSize: 13.0, fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
                      child: Text('Type',
                          style: Theme.of(context).textTheme.display1.copyWith(
                              fontSize: 13.0, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              FutureBuilder<TeacherSubjectList>(
                future: subjects,
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.subjects.length,
                      itemBuilder: (context, index) {
                        return TeacherSubjectRowLayout(snapshot.data.subjects[index]);
                      },
                    );
                  }else{
                    return Center(child: Text("Loading..."));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<TeacherSubjectList> getAllSubject(int id) async {
    final response = await http.get(InfixApi.getTeacherSubject(id));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return TeacherSubjectList.fromJson(jsonData['data']['subjectsName']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
