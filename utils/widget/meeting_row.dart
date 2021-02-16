import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Dormitory.dart';
import 'package:Creativebuffer/utils/modal/zoom_meeting.dart';
import 'package:Creativebuffer/webview/webview_screen.dart';

import 'ScaleRoute.dart';

// ignore: must_be_immutable
class ZoomMeetingRow extends StatefulWidget {
  ZoomMeeting zoomMeeting;

  ZoomMeetingRow(this.zoomMeeting);

  @override
  _DormitoryScreenState createState() => _DormitoryScreenState(zoomMeeting);
}

class _DormitoryScreenState extends State<ZoomMeetingRow> {
  ZoomMeeting zoomMeeting;

  _DormitoryScreenState(this.zoomMeeting);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              zoomMeeting.topic,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 15.0),
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
                          'Start Date',
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
                          '${zoomMeeting.startDate}',
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
                          'Start Time',
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
                          '${zoomMeeting.startTime}',
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
                          'Password',
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
                          '${zoomMeeting.password}',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: OutlineButton(
                        child: Text(
                          'Join',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        borderSide:
                            BorderSide(width: 1, color: Colors.deepPurple),
                        onPressed: () {
                          Navigator.push(context, ScaleRoute(page: WebViewScreen(InfixApi.getJoinMeetingUrl(mid: zoomMeeting.meetingId))));
                        }),
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
    );
  }
}
