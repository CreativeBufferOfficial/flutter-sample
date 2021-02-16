import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/StudentHomework.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/Homework_row.dart';
// ignore: must_be_immutable
class StudentHomework extends StatefulWidget {
  String id;

  StudentHomework({this.id});

  @override
  _StudentHomeworkState createState() => _StudentHomeworkState();
}

class _StudentHomeworkState extends State<StudentHomework> {
  Future<HomeworkList> homeworks;

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('id').then((value) {
      setState(() {
        homeworks = fetchHomework(
            widget.id != null ? int.parse(widget.id) : int.parse(value));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
        appBar: AppBarWidget.header(context, 'Homework'),
        backgroundColor: Colors.white,
        body: FutureBuilder<HomeworkList>(
          future: homeworks,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot != null) {
              return ListView.builder(
                itemCount: snapshot.data.homeworks.length,
                itemBuilder: (context, index) {
                  return StudentHomeworkRow(snapshot.data.homeworks[index]);
                },
              );
            } else {
              return Text("loading...");
            }
          },
        ),
      ),
    );
  }

  Future<HomeworkList> fetchHomework(int id) async {
    final response = await http.get(InfixApi.getStudenthomeWorksUrl(id));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return HomeworkList.fromJson(jsonData['data']);
    } else {
      throw Exception('failed to load');
    }
  }
}
