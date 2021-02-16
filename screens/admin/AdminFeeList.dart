import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/AdminFees.dart';
import 'package:Creativebuffer/utils/widget/Admin_Fees_List_Row.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class AdminFeeListView extends StatefulWidget {
  @override
  _AdminFeeListViewState createState() => _AdminFeeListViewState();
}

class _AdminFeeListViewState extends State<AdminFeeListView> {

  Future<AdminFeesList> fees;

  @override
  void initState() {
    super.initState();
    fees = getAllFee();
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
        appBar: AppBarWidget.header(context, 'Fees Type'),
        backgroundColor: Colors.white,
        body: FutureBuilder<AdminFeesList>(
          future: fees,
          builder: (context,snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data.adminFees.length,
                itemBuilder: (context,index){
                  return AdminFeesListRow(snapshot.data.adminFees[index]);
                },
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          },
        )
      ),
    );
  }

  Future<AdminFeesList> getAllFee() async {
    final response = await http.get(InfixApi.adminFeeList);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AdminFeesList.fromjson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

}
