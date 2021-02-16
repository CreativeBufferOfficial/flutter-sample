import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/ActiveOnlineExam.dart';
import 'package:Creativebuffer/utils/widget/ActiveOnlineExam.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: must_be_immutable
class ActiveOnlineExamScreen extends StatefulWidget {

  var id;
  
  ActiveOnlineExamScreen({this.id});

  @override
  _ActiveOnlineExamScreenState createState() => _ActiveOnlineExamScreenState(id: id);
}

class _ActiveOnlineExamScreenState extends State<ActiveOnlineExamScreen> {

  Future<ActiveExamList> exams;
  var id;


  _ActiveOnlineExamScreenState({this.id});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        id = id != null ? id : value;
        exams = getAllActiveExam(id);
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
        appBar: AppBarWidget.header(context, 'Active Exam'),
        backgroundColor: Colors.white,
        body: FutureBuilder<ActiveExamList>(
          future: exams,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Expanded(child: getExamList())
                ],
              );
            } else {
              return Center(child: Text("loading..."));
            }
          },
        ),
      ),
    );
  }


  Widget getExamList() {
    return FutureBuilder<ActiveExamList>(
      future: exams,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.activeExams.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ActiveOnlineExamRow(snapshot.data.activeExams[index]);
            },
          );
        } else {
          return Center(child: Text("loading..."));
        }
      },
    );
  }


  Future<ActiveExamList> getAllActiveExam(var id) async {
    final response = await http.get(InfixApi.getStudentOnlineActiveExam(id));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return ActiveExamList.fromJson(jsonData['data']['online_exams']);
    } else {
      throw Exception('Failed to load');
    }
  }

}
