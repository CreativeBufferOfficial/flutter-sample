import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/AdminFees.dart';

import 'Line.dart';

// ignore: must_be_immutable
class AdminFeesListRow extends StatefulWidget {
  AdminFees adminFees;
  AdminFeesListRow(this.adminFees);

  @override
  _AdminFeesListRowState createState() => _AdminFeesListRowState();
}

class _AdminFeesListRowState extends State<AdminFeesListRow> {

  GlobalKey _scaffold = GlobalKey();
  Response response;
  Dio dio = Dio();

  TextEditingController titleController, descripController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            widget.adminFees.name ?? 'NA',
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Text(
            widget.adminFees.description ?? 'NA',
            style: Theme.of(context).textTheme.display1,
          ),
          trailing: InkWell(
            child: Text(
              'Update',
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(decoration: TextDecoration.underline),
            ),
            onTap: () {
              showAlertDialog(context);
            },
          ),
        ),
        BottomLine(),
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    titleController = TextEditingController();
    descripController = TextEditingController();
    titleController.text = widget.adminFees.name;
    descripController.text = widget.adminFees.description;

    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          key: _scaffold,
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 20.0, right: 10.0),
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
                              updateFeeData(titleController.text, descripController.text, widget.adminFees.id, context).then((value){
                                if(value){
                                  setState(() {
                                    widget.adminFees.name = titleController.text;
                                    widget.adminFees.description = descripController.text;
                                  });
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
              )
            ],
          ),
        );
      },
    );
  }

  Future<bool> updateFeeData(String title, String des, int id,BuildContext context) async {
    response = await dio.get(InfixApi.feesDataUpdate(title, des, id));
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      return true;
    }else{
      return false;
    }
  }
}

