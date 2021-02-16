import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/LeaveAdmin.dart';
import 'package:Creativebuffer/utils/widget/Line.dart';

// ignore: must_be_immutable
class LeaveRowLayout extends StatelessWidget {
  LeaveAdmin leave;
  Response response;
  Dio dio = Dio();
  final _globalKey = GlobalKey();
  String radioStr = 'Pending';

  LeaveRowLayout(this.leave);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  leave.type,
                  style: Theme.of(context).textTheme.headline,
                  maxLines: 1,
                ),
              ),
              Container(
                width: 80.0,
                child: GestureDetector(
                  onTap: () {
                    showAlertDialog(context);
                  },
                  child: Text(
                    'View',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.headline.copyWith(
                        color: Colors.deepPurpleAccent,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Apply Date',
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        leave.applyDate,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'To',
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        leave.leaveTo,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'From',
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        leave.leaveFrom,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Status',
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      getStatus(context),
                    ],
                  ),
                ),
              ],
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
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {

    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {

            return Material(
              color: Colors.transparent,
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    leave.reason,
                                    style: Theme.of(context).textTheme.headline,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            BottomLine(),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Leave Type',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1
                                              .copyWith(fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          leave.type,
                                          maxLines: 1,
                                          style: Theme.of(context).textTheme.display1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Leave From',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1
                                              .copyWith(fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          leave.leaveFrom,
                                          maxLines: 1,
                                          style: Theme.of(context).textTheme.display1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BottomLine(),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Leave To',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1
                                              .copyWith(fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          leave.leaveTo,
                                          maxLines: 1,
                                          style: Theme.of(context).textTheme.display1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Apply Date',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1
                                              .copyWith(fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          leave.applyDate,
                                          maxLines: 1,
                                          style: Theme.of(context).textTheme.display1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BottomLine(),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text(
                                'Leave Status',
                                style: Theme.of(context).textTheme.display1.copyWith(fontSize: 16),
                                maxLines: 1,
                              ),
                            ),
                            RadioListTile(
                              groupValue: radioStr,
                              title: Text("Pending",style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(fontSize: 15.0)),
                              value: 'Pending',
                              onChanged: (val) {
                                setState(() {
                                  radioStr = val;
                                });
                              },
                              activeColor: Colors.purple,
                              selected: true,
                              dense: true,
                            ),
                            RadioListTile(
                              groupValue: radioStr,
                              title: Text("Approve",style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(fontSize: 15.0)),
                              value: 'Approve',
                              onChanged: (val) {
                                setState(() {
                                  radioStr = val;
                                });
                              },
                              activeColor: Colors.purple,
                              selected: true,
                              dense: true,
                            ),
                            RadioListTile(
                              groupValue: radioStr,
                              title: Text("Reject",style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(fontSize: 15.0)),
                              value: 'Reject',
                              onChanged: (val) {
                                setState(() {
                                  radioStr = val;
                                });
                              },
                              activeColor: Colors.purple,
                              selected: true,
                              dense: true,
                            ),
                            GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.purple,
                                  ),
                                  child: Text(
                                    "Save",
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(color: Colors.white, fontSize: 16.0),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Utils.showToast('${leave.id}  ${radioStr.substring(0,1)}');
                                addUpdateData(leave.id, radioStr.substring(0,1)).then((value){
                                  if(value){
                                    Navigator.pop(_globalKey.currentContext);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Future<bool> addUpdateData(int id,String status) async {
    response = await dio.get(InfixApi.setLeaveStatus(id, status));
    if (response.statusCode == 200) {
      Utils.showToast('Leave Updated');
      return true;
    }else{
      return false;
    }
  }

  Widget getStatus(BuildContext context) {
    if (leave.status == 'P') {
      radioStr = 'Pending';
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.green.shade400),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Pending',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .display1
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (leave.status == 'A') {
      radioStr = 'Approve';
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.amberAccent),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Approved',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .display1
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }else{
      radioStr = 'Reject';
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.redAccent),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Rejected',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .display1
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
  }
}
