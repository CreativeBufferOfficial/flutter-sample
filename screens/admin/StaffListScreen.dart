import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/screens/admin/Bloc/StuffListBloc.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Staff.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/ScaleRoute.dart';

import 'AdminStaffDetails.dart';
// ignore: must_be_immutable
class StaffListScreen extends StatefulWidget {

  int id;


  StaffListScreen(this.id);

  @override
  _StaffListScreenState createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {

  StuffListBloc listBloc;

  @override
  void initState() {
    super.initState();
    //blocStuff.getStaffList();
    listBloc = StuffListBloc(id: widget.id);
    listBloc.getStaffList();
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
        appBar: AppBarWidget.header(context, 'Stuff List'),
        body: StreamBuilder<StaffList>(
          stream: listBloc.getStaffSubject.stream,
          builder: (context, snap) {
            if (snap.hasData) {
              if (snap.error != null) {
                return _buildErrorWidget(snap.error.toString());
              }
              return _buildStaffListWidget(snap.data);
            } else if (snap.hasError) {
              return _buildErrorWidget(snap.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        ),
      ),
    );
  }
  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Loading data from API..."), CircularProgressIndicator()],
        ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error occured: $error"),
          ],
        ));
  }
  Widget _buildStaffListWidget(StaffList data) {
    return ListView.builder(
      itemCount: data.staffs.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.push(context, ScaleRoute(page: StaffDetailsScreen(data.staffs[index])));
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(InfixApi.root+data.staffs[index].photo),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(data.staffs[index].name,style: Theme.of(context).textTheme.title,),
                subtitle: Text('Phone : ${data.staffs[index].phone} | Address : ${data.staffs[index].currentAddress}',style: Theme.of(context).textTheme.display1),
              ),
            ),
            Container(
              height: 0.5,
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Colors.purple, Colors.deepPurple]),
              ),
            )
          ],
        );
      },
    );
  }
}
