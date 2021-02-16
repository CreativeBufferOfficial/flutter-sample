import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/AdminDormitory.dart';
import 'package:Creativebuffer/utils/modal/RoomType.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';

class AddDormitory extends StatefulWidget {
  @override
  _AddDormitoryState createState() => _AddDormitoryState();
}

class _AddDormitoryState extends State<AddDormitory> {
  TextEditingController nameController = TextEditingController();
  TextEditingController intakeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  Future<AdminDormitoryList> dormitories;
  Future<AdminRoomTypeList> rooms;
  Response response;
  Dio dio = Dio();

  String selectedType;

  var types = ['Boys','Girls'];

  @override
  void initState() {
    super.initState();

    selectedType = 'Boys';
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
        appBar: AppBarWidget.header(context, 'Add Dormitory'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  controller: nameController,
                  style: Theme.of(context).textTheme.display1,
                  decoration:
                  InputDecoration(hintText: 'Dormitory name'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  controller: intakeController,
                  style: Theme.of(context).textTheme.display1,
                  decoration: InputDecoration(
                      hintText: 'Intake'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: TextField(
                  controller: addressController,
                  style: Theme.of(context).textTheme.display1,
                  decoration: InputDecoration(
                      hintText: 'Address'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: getRoomTypeDropdown(context,types),
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
                    addDormitoryData(nameController.text,intakeController.text,addressController.text,noteController.text,selectedType.substring(0,1)).then((value){
                      if(value){
                        nameController.text = '';
                        intakeController.text = '';
                        noteController.text = '';
                        addressController.text = '';
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
  Widget getRoomTypeDropdown(BuildContext context,List<String> typeList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: typeList.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(item),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.display1.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedType = value;
          });
        },
        value: selectedType,
      ),
    );
  }
  Future<bool> addDormitoryData(String name,String intake,String address, String note,String type) async {
    print(InfixApi.addDormitory(name, type, intake, address, note));
    response = await dio.post(InfixApi.addDormitory(name, type, intake, address, note));
    if (response.statusCode == 200) {
      Utils.showToast('dormitory Added');
      return true;
    }else{
      return false;
    }
  }



}
