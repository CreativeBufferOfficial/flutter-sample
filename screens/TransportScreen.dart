import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Transport.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/TransportRow.dart';

class TransportScreen extends StatefulWidget {
  @override
  _TransportState createState() => _TransportState();
}

class _TransportState extends State<TransportScreen> {

  Future<TransportList> transports;

  @override
  void initState() {
    super.initState();
    transports = getAllTransport();
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
        appBar: AppBarWidget.header(context, 'Transport'),
        backgroundColor: Colors.white,
        body: FutureBuilder<TransportList>(
          future: transports,
          builder: (context,snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data.transports.length,
                itemBuilder: (context, index) {
                  return TransportRow(snapshot.data.transports[index]);
                },
              );
            }else{
              return Text("loading...");
            }
          },
        )
      ),
    );
  }

  Future<TransportList> getAllTransport() async {

    print(InfixApi.studentTransportList);

    final response = await http.get(InfixApi.studentTransportList);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return TransportList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
