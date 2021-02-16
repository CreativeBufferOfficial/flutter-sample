import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'AdminLeavePager.dart';

class LeaveAdminHomeScreen extends StatefulWidget {
  @override
  _LeaveAdminHomeScreenState createState() => _LeaveAdminHomeScreenState();
}

class _LeaveAdminHomeScreenState extends State<LeaveAdminHomeScreen> {
  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.timeline), title: new Text('Pending')),
      BottomNavigationBarItem(
        icon: new Icon(Icons.done),
        title: new Text('Approved'),
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.close), title: Text('Rejected'))
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        AdminLeavePage(InfixApi.pendingLeave,"pending_request"),
        AdminLeavePage(InfixApi.approvedLeave,"approved_request"),
        AdminLeavePage(InfixApi.rejectedLeave,"reject_request"),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
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
        backgroundColor: Colors.white,
        appBar: AppBarWidget.header(context, 'Leave'),
        body: buildPageView(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomSelectedIndex,
          onTap: (index) {
            bottomTapped(index);
          },
          items: buildBottomNavBarItems(),
        ),
      ),
    );
  }
}
