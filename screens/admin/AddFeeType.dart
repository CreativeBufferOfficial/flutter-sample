import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';

// ignore: must_be_immutable
class AddFeeType extends StatelessWidget {

  TextEditingController titleController = TextEditingController();
  TextEditingController descripController = TextEditingController();
  Response response;
  Dio dio = Dio();


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
        appBar: AppBarWidget.header(context, 'Add Fees Type'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
                      children: <Widget>[
                        TextField(
                          controller: titleController,
                          style: Theme.of(context).textTheme.display1,
                          decoration:
                          InputDecoration(hintText: 'Enter title here'),
                        ),
                        TextField(
                          controller: descripController,
                          style: Theme.of(context).textTheme.display1,
                          decoration: InputDecoration(
                              hintText: 'Enter discription here'),
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
                              addFeeData(titleController.text, descripController.text).then((value){
                                if(value){
                                    titleController.text = '';
                                    descripController.text = '';
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
  Future<bool> addFeeData(String title, String des) async {
    response = await dio.get(InfixApi.feesDataSend(title, des));
    if (response.statusCode == 200) {
      Utils.showToast('Fee Type Added');
      return true;
    }else{
      return false;
    }
  }
}
