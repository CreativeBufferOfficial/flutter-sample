import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Dormitory.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/Dormitory_row.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DormitoryScreen extends StatefulWidget {
  @override
  _DormitoryScreenState createState() => _DormitoryScreenState();
}

class _DormitoryScreenState extends State<DormitoryScreen> {
  Future<DormitoryList> dormitories;

  @override
  void initState() {
    super.initState();
    dormitories = getAllDormitory();
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
        appBar: AppBarWidget.header(context, 'Dormitory'),
        backgroundColor: Colors.white,
        body: FutureBuilder<DormitoryList>(
          future: dormitories,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.dormitories.length,
                itemBuilder: (context, index) {
                  return DormitoryRow(snapshot.data.dormitories[index]);
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

  Future<DormitoryList> getAllDormitory() async {
    final response = await http.get(InfixApi.studentDormitoryList);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return DormitoryList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
