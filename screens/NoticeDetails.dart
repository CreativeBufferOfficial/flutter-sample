import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/modal/Notice.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';

// ignore: must_be_immutable
class NoticDetailsLayout extends StatefulWidget {

  Notice notice;


  NoticDetailsLayout(this.notice);

  @override
  _NoticDetailsLayoutState createState() => _NoticDetailsLayoutState(notice);
}

class _NoticDetailsLayoutState extends State<NoticDetailsLayout> {

  Notice notice;


  _NoticDetailsLayoutState(this.notice);

  @override
  Widget build(BuildContext context) {

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
    ));

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Scaffold(
        appBar: AppBarWidget.header(context, 'Details'),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                notice.title,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 15.0),
              ),
              SizedBox(height: 5.0,),
              Text(
                notice.date,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontWeight: FontWeight.w300, fontSize: 13.0),
              ),
              SizedBox(height: 10.0,),
              Text(
                notice.destails,
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontWeight: FontWeight.w300, fontSize: 13.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
