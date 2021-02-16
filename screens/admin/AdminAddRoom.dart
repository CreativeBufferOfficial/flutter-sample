import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/AdminDormitory.dart';
import 'package:Creativebuffer/utils/modal/RoomType.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddRoom extends StatefulWidget {
  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  TextEditingController roomNoController = TextEditingController();
  TextEditingController noOfBedController = TextEditingController();
  TextEditingController costPerBedController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  Future<AdminDormitoryList> dormitories;
  Future<AdminRoomTypeList> rooms;
  Response response;
  Dio dio = Dio();

  String selectedDormitory;
  int selectedDormitoryId;
  String selectedRoom;
  int selectedRoomId;

  @override
  void initState() {
    super.initState();
    dormitories = getAllDormitory();
    rooms = getAllRoomType();
    rooms.then((roomVal) {
      setState(() {
        selectedRoom = roomVal.rooms[0].title;
        selectedRoomId = roomVal.rooms[0].id;
      });
    });
    dormitories.then((dormiVal) {
      setState(() {
        selectedDormitory = dormiVal.dormitories[0].title;
        selectedDormitoryId = dormiVal.dormitories[0].id;
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
        appBar: AppBarWidget.header(context, 'Add Room'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  controller: roomNoController,
                  style: Theme.of(context).textTheme.display1,
                  decoration:
                  InputDecoration(hintText: 'Room no'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  controller: noOfBedController,
                  style: Theme.of(context).textTheme.display1,
                  decoration: InputDecoration(
                      hintText: 'Number of bed'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  controller: costPerBedController,
                  style: Theme.of(context).textTheme.display1,
                  decoration: InputDecoration(
                      hintText: 'Cost per bed'),
                ),
              ),
              FutureBuilder<AdminDormitoryList>(
                future: dormitories,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: getDormitoryDropdown(context,snapshot.data.dormitories),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              FutureBuilder<AdminRoomTypeList>(
                future: rooms,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: getRoomTypeDropdown(context,snapshot.data.rooms),
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
              Container(
                padding: const EdgeInsets.only(bottom: 16.0,top: 50.0),
                width: double.infinity,
                child: RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.white,
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    addRoomData(roomNoController.text,'$selectedDormitoryId','$selectedRoomId',costPerBedController.text,noOfBedController.text,noteController.text).then((value){
                      if(value){
                        roomNoController.text = '';
                        noOfBedController.text = '';
                        noteController.text = '';
                        costPerBedController.text = '';
                      }
                    });
                  Utils.showToast('${roomNoController.text}    ${noOfBedController.text}    ${costPerBedController.text}   ${selectedRoomId}  ${noteController.text}   ${selectedRoomId}');
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
  Widget getRoomTypeDropdown(BuildContext context,List<AdminRoomType> roomList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: roomList.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(item.title),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.display1.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedRoom = value;
            selectedRoomId = getCode(roomList, value);
            debugPrint('User select $selectedRoomId');
          });
        },
        value: selectedRoom,
      ),
    );
  }
  Widget getDormitoryDropdown(BuildContext context,List<AdminDormitory> dormitoryList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: dormitoryList.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(item.title),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.display1.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedDormitory = value;
            selectedDormitoryId = getCode(dormitoryList, value);
            debugPrint('User select $selectedDormitoryId');
          });
        },
        value: selectedDormitory,
      ),
    );
  }
  Future<bool> addRoomData(String roomNumber,String dormitoryId,String roomId, String cost,String numberOfBed,String des) async {
    FormData formData = FormData.fromMap({
      "room_number": roomNumber,
      "dormitory": dormitoryId,
      "room_type": roomId,
      "number_of_bed": numberOfBed,
      "cost_per_bed":cost,
      "description": des,
      "name": '$roomNumber',
    });
    try{
      response = await dio.post(InfixApi.dormitoryRoomList,data: formData);
      print(response);
      if (response.statusCode == 200) {
        Utils.showToast('room Added');
        return true;
      }else{
        return false;
      }
    }catch(e){
      print(e.toString());
    }
  }
  int getCode<T>(T t, String title) {
    int code;
    for (var cls in t) {
      if (cls.title == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }
  Future<AdminDormitoryList> getAllDormitory() async {
    final response = await http.get(InfixApi.dormitoryList);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AdminDormitoryList.fromJson(jsonData['data']['dormitory_lists']);
    } else {
      throw Exception('Failed to load');
    }
  }
  Future<AdminRoomTypeList> getAllRoomType() async {
    final response = await http.get(InfixApi.roomTypeList);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AdminRoomTypeList.fromJson(jsonData['data']['room_type_lists']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
