import 'package:flutter/material.dart';
import 'package:Creativebuffer/screens/NoticeDetails.dart';
import 'package:Creativebuffer/utils/modal/Notice.dart';
import 'package:Creativebuffer/utils/widget/ScaleRoute.dart';

// ignore: must_be_immutable
class NoticRowLayout extends StatefulWidget {
  Notice notice;

  NoticRowLayout(this.notice);

  @override
  _NoticRowLayoutState createState() => _NoticRowLayoutState(notice);
}

class _NoticRowLayoutState extends State<NoticRowLayout> {
  Notice notice;

  _NoticRowLayoutState(this.notice);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, ScaleRoute(page: NoticDetailsLayout(notice)));
      },
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
          SizedBox(
            height: 5.0,
          ),
          Text(
            notice.date,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .display1
                .copyWith(fontWeight: FontWeight.w300, fontSize: 13.0),
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
}
