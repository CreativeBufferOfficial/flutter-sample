import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/ONlineExamResult.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/OnlineExamResultRow.dart';
// ignore: must_be_immutable
class OnlineExamResultScreen extends StatefulWidget {
  var id;

  OnlineExamResultScreen({this.id});

  @override
  _OnlineExamResultScreenState createState() => _OnlineExamResultScreenState();
}

class _OnlineExamResultScreenState extends State<OnlineExamResultScreen> {

  Future<OnlineExamResultList> results;
  var id;
  int code;
  var _selected;
  Future<OnlineExamNameList> exams;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        id = widget.id != null ? widget.id : value;
        exams = getAllOnlineExam(id);
        exams.then((val) {
          _selected = val.names[0].title;
          code = val.names[0].id;
          results = getAllOnlineExamResult(id, code);
        });
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
        appBar: AppBarWidget.header(context,'Result'),
        backgroundColor: Colors.white,
        body: FutureBuilder<OnlineExamNameList>(
          future: exams,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  getDropdown(snapshot.data.names),
                  SizedBox(
                    height: 15.0,
                  ),
                  Expanded(child: getExamResultList())
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

  Widget getDropdown(List<OnlineExamName> names) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: names.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Text(item.title),
          );
        }).toList(),
        style: Theme.of(context).textTheme.display1.copyWith(fontSize: 15.0),
        onChanged: (value) {
          setState(() {
            _selected = value;

            code = getExamCode(names, value);

            debugPrint('User select $code');

            results = getAllOnlineExamResult(id, code);

            getExamResultList();
          });
        },
        value: _selected,
      ),
    );
  }

  Future<OnlineExamResultList> getAllOnlineExamResult(
      var id, int code) async {
    final response =
    await http.get(InfixApi.getStudentOnlineActiveExamResult(id, code));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return OnlineExamResultList.fromJson(jsonData['data']['exam_result']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<OnlineExamNameList> getAllOnlineExam(var id) async {
    final response = await http.get(InfixApi.getStudentOnlineActiveExamName(id));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return OnlineExamNameList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  int getExamCode(List<OnlineExamName> names, String title) {
    int code;
    for (OnlineExamName name in names) {
      if (name.title == title) {
        code = name.id;
        break;
      }
    }
    return code;
  }

  Widget getExamResultList() {
    return FutureBuilder<OnlineExamResultList>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.results.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return OnlineExamResultRow(snapshot.data.results[index]);
            },
          );
        } else {
          return Center(child: Text("loading..."));
        }
      },
    );
  }

}
