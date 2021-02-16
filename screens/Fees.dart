import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/modal/Fee.dart';
import 'package:Creativebuffer/utils/server/FeesService.dart';
import 'package:Creativebuffer/utils/widget/Fees_row_layout.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
// ignore: must_be_immutable
class FeeScreen extends StatefulWidget {
  String id;

  FeeScreen({this.id});

  @override
  _FeeScreenState createState() => _FeeScreenState();
}

class _FeeScreenState extends State<FeeScreen> {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
    ));

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Scaffold(
        appBar: AppBarWidget.header(context, 'Fees'),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Grand Total',
                      style: Theme.of(context)
                          .textTheme
                          .headline
                          .copyWith(fontSize: 20.0),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0,bottom: 20.0),
              child: Container(
                child:FutureBuilder(
                  future: Utils.getStringValue('id'),
                  builder: (context,id){
                    if(id.hasData){
                      return Container(
                        child: FutureBuilder(
                          future: FeeService(int.parse(widget.id!= null ? widget.id : id.data)).fetchTotalFee(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> totalSnapshot){

                            if(totalSnapshot.hasData){
                              return Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Amount',
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
                                          '\$'+ totalSnapshot.data[0],
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
                                          'Discount',
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
                                          '\$'+totalSnapshot.data[1],
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
                                          'Fine',
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
                                          '\$'+totalSnapshot.data[2],
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
                                          'Paid',
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
                                          '\$'+totalSnapshot.data[3],
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
                                          'Balance',
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
                                          '\$'+totalSnapshot.data[4],
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: Theme.of(context).textTheme.display1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      );
                    }else {
                      return Container(
                        child: Text('...'),
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              height: 15.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xfff3e5f5).withOpacity(0.5), Colors.white]),
              ),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder(
                  future: Utils.getStringValue('id'),
                  builder: (context, snapId) {
                    if (snapId.hasData) {
                      return Container(
                        child: FutureBuilder(
                          future:
                              FeeService(int.parse(widget.id!= null ? widget.id : snapId.data)).fetchFee(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Fee>> feeSnapshot) {
                            if (feeSnapshot.hasData) {
                              return ListView.builder(
                                  itemCount: feeSnapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return FeesRow(feeSnapshot.data[index],widget.id!= null ? widget.id : snapId.data);
                                  });
                            } else {
                              return Text(
                                'Loading...',
                                style: Theme.of(context).textTheme.headline,
                              );
                            }
                          },
                        ),
                      );
                    } else {
                      return Container(
                        child: Text('Loading...'),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}