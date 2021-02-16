import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Child.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/ChildRow.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChildListScreen extends StatefulWidget {

  @override
  _ChildListScreenState createState() => _ChildListScreenState();
}

class _ChildListScreenState extends State<ChildListScreen> {
  Future<ChildList> childs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        childs = getAllStudent(value);
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
        appBar: AppBarWidget.header(context, 'Child List'),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: FutureBuilder<ChildList>(
          future: childs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.students.length,
                itemBuilder: (context, index) {
                  return ChildRow(snapshot.data.students[index]);
                },
              );
            } else {
              return Center(child: Text("loading..."));
            }
          },
        ),
      ),
    );
  }

  Future<ChildList> getAllStudent(String id) async {
    final response = await http.get(InfixApi.getParentChildList(id));

    if (response.statusCode == 200) {

      var jsonData = jsonDecode(response.body);

      return ChildList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
