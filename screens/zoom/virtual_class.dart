import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/zoom_meeting.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:Creativebuffer/utils/widget/meeting_row.dart';

class VirtualClassScreen extends StatelessWidget {

  final uid;

  VirtualClassScreen({this.uid});

  @override
  Widget build(BuildContext context) {

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
    ));

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Scaffold(
        appBar: AppBarWidget.header(context, 'Online class'),
        backgroundColor: Colors.white,
        body: FutureBuilder<ZoomMeetingList>(
          future: getAllMeeting(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data.meetings.length < 1){
                return Center(child: Text("Empty"));
              }
              return ListView.builder(
                itemCount: snapshot.data.meetings.length,
                itemBuilder: (context, index) {
                  return ZoomMeetingRow(snapshot.data.meetings.elementAt(index));
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

  Future<ZoomMeetingList> getAllMeeting() async {
    print(InfixApi.getMeeting(uid: uid, param: InfixApi.createVirtualClass));
    final response = await http
        .get(InfixApi.getMeeting(uid: uid, param: InfixApi.createVirtualClass));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return ZoomMeetingList.fromJson(jsonData['data']['meetings']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
