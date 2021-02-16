import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Staff.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddVehicle extends StatefulWidget {
  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  TextEditingController vehicleNoController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController yearMadeModelController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  Future<StaffList> staffs;
  Response response;
  Dio dio = Dio();

  String selectedDriver;
  int selectedId;

  @override
  void initState() {
    super.initState();
    staffs = getAllStaff();
    staffs.then((staffVal) {
      setState(() {
        selectedDriver = staffVal.staffs[0].name;
        selectedId = staffVal.staffs[0].id;
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
        backgroundColor: Colors.white,
        appBar: AppBarWidget.header(context, 'Add Vehicle'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  controller: vehicleNoController,
                  style: Theme.of(context).textTheme.display1,
                  decoration:
                  InputDecoration(hintText: 'Vehicle No'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  controller: vehicleModelController,
                  style: Theme.of(context).textTheme.display1,
                  decoration: InputDecoration(
                      hintText: 'Vehicle Model'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  controller: yearMadeModelController,
                  style: Theme.of(context).textTheme.display1,
                  decoration: InputDecoration(
                      hintText: 'Year Made'),
                ),
              ),
              FutureBuilder<StaffList>(
                future: staffs,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: getDriverDropdown(context,snapshot.data.staffs),
                    );
                  } else {
                    return Container();
                  }
                },
              ),

              Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  controller: noteController,
                  style: Theme.of(context).textTheme.display1,
                  decoration: InputDecoration(
                      hintText: 'Note'),
                ),
              ),

              Expanded(child: Container()),
              Container(
                padding: const EdgeInsets.only(bottom: 16.0),
                width: double.infinity,
                child: RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.white,
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    addVehicleData(vehicleNoController.text, vehicleModelController.text,'$selectedId',noteController.text,yearMadeModelController.text).then((value){
                      if(value){
                        vehicleNoController.text = '';
                        vehicleModelController.text = '';
                        noteController.text = '';
                        yearMadeModelController.text = '';
                      }
                    });
                  },
                  child: new Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget getDriverDropdown(BuildContext context,List<Staff> driverList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: driverList.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(item.name),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.display1.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedDriver = value;
            selectedId = getCode(driverList, value);
            debugPrint('User select $selectedId');
          });
        },
        value: selectedDriver,
      ),
    );
  }
  Future<bool> addVehicleData(String vehicleNo,String model,String driverId, String note,String year) async {
    print(InfixApi.addVehicle(vehicleNo, model,driverId,note,year));
    response = await dio.get(InfixApi.addVehicle(vehicleNo, model,driverId,note,year));
    if (response.statusCode == 200) {
      Utils.showToast('Vehicle Added');
      return true;
    }else{
      return false;
    }
  }
  int getCode<T>(T t, String title) {
    int code;
    for (var cls in t) {
      if (cls.name == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }
  Future<StaffList> getAllStaff() async {


    final response = await http.get(InfixApi.driverList);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StaffList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
