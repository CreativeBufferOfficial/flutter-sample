import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Notice.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/NoticeRow.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoticeScreen extends StatefulWidget {
  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  Future<NoticeList> notices;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        notices = getNotices(int.parse(value));
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
        appBar: AppBarWidget.header(context, 'Notice'),
        backgroundColor: Colors.white,
        body: FutureBuilder<NoticeList>(
            future: notices,
            builder: (context,snapshot){

              if(snapshot.hasData){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: snapshot.data.notices.length,
                    itemBuilder: (context,index){
                      return NoticRowLayout(snapshot.data.notices[index]);
                    },
                  ),
                );
              }else{
                return Center(child: Text('loading...'));
              }
            },
          ),
      ),
    );
  }

  Future<NoticeList> getNotices(int id) async {
    final response = await http.get(InfixApi.getNoticeUrl(id));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return NoticeList.fromJson(jsonData['data']['allNotices']);
    } else {
      throw Exception('Failed to load');
    }
  }

}
