import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Subject.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/SubjectRowLayout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: must_be_immutable
class SubjectScreen extends StatefulWidget {
  String id;

  SubjectScreen({this.id});

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  Future<SubjectList> subjects;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        subjects = getAllSubject(widget.id != null ? int.parse(widget.id):int.parse(value));
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
                      child: Text('Teacher',
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
              FutureBuilder<SubjectList>(
                future: subjects,
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.subjects.length,
                      itemBuilder: (context, index) {
                        return SubjectRowLayout(snapshot.data.subjects[index]);
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

  Future<SubjectList> getAllSubject(int id) async {
    final response = await http.get(InfixApi.getSubjectsUrl(id));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return SubjectList.fromJson(jsonData['data']['student_subjects']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
