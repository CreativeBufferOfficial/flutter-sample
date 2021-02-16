import 'package:flutter/material.dart';
import 'package:Creativebuffer/utils/CardItem.dart';
import 'package:Creativebuffer/utils/FunctinsData.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';

// ignore: must_be_immutable
class LibraryHome extends StatefulWidget {
  var _titles;
  var _images;
  var id;

  LibraryHome(this._titles,this._images,{this.id});

  @override
  _HomeState createState() => _HomeState(_titles,_images);
}

class _HomeState extends State<LibraryHome> {
  bool isTapped;
  int currentSelectedIndex;
  var _titles;
  var _images;

  _HomeState(this._titles,this._images);

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
        appBar: AppBarWidget.header(context,'Library'),
        backgroundColor: Colors.white,
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
                  AppFunction.getLibraryDashboardPage(context, _titles[index],id: widget.id);
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
