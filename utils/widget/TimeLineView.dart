import 'package:flutter/material.dart';
import 'package:Creativebuffer/utils/modal/Timeline.dart';
// ignore: must_be_immutable
class TimeLineView extends StatelessWidget {

  Timeline timeline;


  TimeLineView(this.timeline);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 14,
                height: 16,
                decoration: new BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 0.5,
                height: 150,
                decoration: new BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.rectangle,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                timeline.title,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                timeline.date,
                maxLines: 1,
                style: Theme.of(context).textTheme.display1,
              ),
              Text(
                timeline.description,
                maxLines: 5,
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}