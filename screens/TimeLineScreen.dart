import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Timeline.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/TimeLineView.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: must_be_immutable
class TimelineScreen extends StatefulWidget {
  String id;

  TimelineScreen({this.id});

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {

  Future<TimelineList> timelinelist;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        timelinelist = getAllTimeline(widget.id != null ? int.parse(widget.id):int.parse(value));
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
        appBar: AppBarWidget.header(context, 'Timeline'),
        backgroundColor: Colors.white,
        body: FutureBuilder<TimelineList>(
          future: timelinelist,
          builder: (context,snapshot){
            if(snapshot.hasData){
              return Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: snapshot.data.timelines.length,
                  itemBuilder: (context, index) {
                    return TimeLineView(snapshot.data.timelines[index]);
                  },
                ),
              );
            }else{
              return Center(child: Text("Loading..."));
            }
          },
        ),
      ),
    );
  }

  Future<TimelineList> getAllTimeline(int id) async {
    final response = await http.get(InfixApi.getStudentTimeline(id));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return TimelineList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
