import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';

// ignore: must_be_immutable
class AddRoute extends StatelessWidget {

  TextEditingController titleController = TextEditingController();
  TextEditingController fareController = TextEditingController();
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
        appBar: AppBarWidget.header(context, 'Add Route'),
        body: FutureBuilder<String>(
          future: Utils.getStringValue('id'),
          builder: (context,snapshot){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    style: Theme.of(context).textTheme.display1,
                    decoration:
                    InputDecoration(hintText: 'Route title here'),
                  ),
                  TextField(
                    controller: fareController,
                    style: Theme.of(context).textTheme.display1,
                    decoration: InputDecoration(
                        hintText: 'Enter fare here'),
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
                        addFeeData(titleController.text, fareController.text,snapshot.data).then((value){
                          if(value){
                            titleController.text = '';
                            fareController.text = '';
                          }
                        });
                      },
                      child: new Text("Save"),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Future<bool> addFeeData(String title, String fare,String uid) async {
    print(InfixApi.addRoute(title, fare,uid));
    response = await dio.get(InfixApi.addRoute(title, fare,uid));
    if (response.statusCode == 200) {
      Utils.showToast('Route Added');
      return true;
    }else{
      return false;
    }
  }
}
