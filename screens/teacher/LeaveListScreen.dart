import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Leave.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:Creativebuffer/utils/widget/Leave_row.dart';

class LeaveListScreen extends StatefulWidget {
  @override
  _LeaveListScreenState createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> {
  Future<LeaveList> leaves;

  @override
  void initState() {
    super.initState();

    Utils.getStringValue('id').then((value) {
      setState(() {
        leaves = fetchLeave(int.parse(value));
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
        appBar: AppBarWidget.header(context, 'Leave List'),
        backgroundColor: Colors.white,
        body: FutureBuilder<LeaveList>(
          future: leaves,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot != null) {
              return ListView.builder(
                itemCount: snapshot.data.leaves.length,
                itemBuilder: (context, index) {
                  return LeaveRow(snapshot.data.leaves[index]);
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

  Future<LeaveList> fetchLeave(int id) async {
    print(InfixApi.getLeaveList(id));
    final response = await http.get(InfixApi.getLeaveList(id));
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return LeaveList.fromJson(jsonData['data']['leave_list']);
    } else {
      throw Exception('failed to load');
    }
  }
}
