import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:Creativebuffer/utils/CardItem.dart';
import 'package:Creativebuffer/utils/FunctinsData.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
// ignore: must_be_immutable
class ChildHome extends StatefulWidget {
  var _titles;
  var _images;
  int id;
  String profileImage;

  ChildHome(this._titles, this._images,this.id,this.profileImage);

  @override
  _ChildHomeState createState() => _ChildHomeState(_titles, _images);
}

class _ChildHomeState extends State<ChildHome> {
  bool isTapped;
  int currentSelectedIndex;
  var _titles;
  var _images;

  _ChildHomeState(this._titles, this._images);

  @override
  void initState() {
    super.initState();
    isTapped = false;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
    ));

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Scaffold(
        appBar: AppBarWidget.header(context, 'Child Dashboard'),
        body: GridView.builder(
          itemCount: _titles.length,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (context, index) {
            return CustomWidget(
              index: index,
              isSelected: currentSelectedIndex == index,
              onSelect: () {
                setState(() {
                  currentSelectedIndex = index;
                  AppFunction.getDashboardPage(context, _titles[index],id:widget.id.toString(),image: widget.profileImage);
                });
              },
              headline: _titles[index],
              icon: _images[index],
            );
          },
        ),
      ),
    );
  }
}

//Future<String> getImageUrl(String email, String password, String rule) async {
//  var image = 'https://i.imgur.com/BoN9kdC.png';
//
//  var response = await http.get(InfixApi.login(email, password));
//
//  if (response.statusCode == 200) {
//    Map<String, dynamic> user = jsonDecode(response.body) as Map;
//
//    if (rule == '2')
//      image = InfixApi.root + user['data']['userDetails']['student_photo'];
//    else
//      image = InfixApi.root + user['data']['userDetails']['staff_photo'];
//  }
//  return '$image';
//}

void navigateToPreviousPage(BuildContext context) {
  Navigator.pop(context);
}
