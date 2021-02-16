import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Creativebuffer/utils/FunctinsData.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Content.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permissions_plugin/permissions_plugin.dart';

// ignore: must_be_immutable
class ContentRow extends StatefulWidget {
  Content content;
  Animation animation;
  final VoidCallback onPressed;

  ContentRow(this.content, this.animation, {this.onPressed});

  @override
  _ContentRowState createState() => _ContentRowState(content);
}

class _ContentRowState extends State<ContentRow> {
  Content content;
  var progress = "Download";

  _ContentRowState(this.content);

  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.animation,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      content.title == null ? 'NA' : content.title,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 15.0),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    width: 80.0,
                    child: GestureDetector(
                      onTap: () {
                        checkPermissions(context);
                        if (progress == 'Download') {
                          showDownloadAlertDialog(context);
                        }
                      },
                      child: Text(
                        progress,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.title.copyWith(
                            color: Colors.deepPurpleAccent,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  Container(
                    width: 80.0,
                    child: GestureDetector(
                      onTap: () {
                        showDeleteAlertDialog(context);
                      },
                      child: Text(
                        'Delete',
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.title.copyWith(
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
                            'Type',
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
                            content.type == null
                                ? 'not assigned'
                                : AppFunction.getContentType(content.type),
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
                            'Date',
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
                            content.date == null
                                ? 'not assigned'
                                : content.date,
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
                            'Class',
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
                            content.mClass == null
                                ? 'not assigned'
                                : content.mClass,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.display1,
                          ),
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
        ),
      ),
    );
  }

  showDeleteAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("no"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = FlatButton(
      child: Text("delete"),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          deleteContent(content.id);
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Delete",
        style: Theme.of(context).textTheme.headline,
      ),
      content: Text("Would you like to delete the file?"),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDownloadAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("no"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = FlatButton(
      child: Text("download"),
      onPressed: () {
        content.url != null
            ? downloadFile(content.url)
            : Utils.showToast('no file found');
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Download",
        style: Theme.of(context).textTheme.headline,
      ),
      content: Text("Would you like to download the file?"),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> deleteContent(int cid) async {
    final response = await http.get(InfixApi.deleteContent(cid));

    if (response.statusCode == 200) {
      widget.onPressed();
      Utils.showToast('Content deleted');
    } else {
      throw Exception('failed to load');
    }
  }

  Future<void> downloadFile(String url) async {
    Dio dio = Dio();

    String dirloc = "";
    if (Platform.isAndroid) {
      dirloc = "/sdcard/download/";
    } else {
      dirloc = (await getApplicationDocumentsDirectory()).path;
    }
    try {
      FileUtils.mkdir([dirloc]);
      await dio
          .download(InfixApi.root + url, dirloc + AppFunction.getExtention(url),
              onReceiveProgress: (receivedBytes, totalBytes) {
        setState(() {
          progress =
              ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
          if (progress == '100%')
            Utils.showToast(
                "Download completed\n please check download folder");
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkPermissions(BuildContext context) async {
    Map<Permission, PermissionState> permission =
        await PermissionsPlugin.checkPermissions([
      Permission.WRITE_EXTERNAL_STORAGE,
      Permission.READ_EXTERNAL_STORAGE,
    ]);

    if (permission[Permission.WRITE_EXTERNAL_STORAGE] !=
        PermissionState.GRANTED && permission[Permission.READ_EXTERNAL_STORAGE] !=
        PermissionState.GRANTED) {
      try {
        permission = await PermissionsPlugin.requestPermissions([
          Permission.WRITE_EXTERNAL_STORAGE,
          Permission.READ_EXTERNAL_STORAGE,
        ]);
      } on Exception {
        debugPrint("Error");
      }

      if (permission[Permission.WRITE_EXTERNAL_STORAGE] ==
          PermissionState.GRANTED)
        print("write  permission ok");
      else
        permissionsDenied(context);
    } else {
      print("write permission ok");
    }

    if (permission[Permission.READ_EXTERNAL_STORAGE] ==
        PermissionState.GRANTED)
      print("Read  permission ok");
    else
      permissionsDenied(context);
  }

  }

  void permissionsDenied(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return SimpleDialog(
            title: const Text("Permission denied"),
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                child: const Text(
                  "You must grant all permission to use this application",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
            ],
          );
        });
  }

