import 'package:flutter/material.dart';
import 'package:Creativebuffer/screens/parent/ChildDashboardScreen.dart';
import 'package:Creativebuffer/utils/FunctinsData.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Child.dart';

// ignore: must_be_immutable
class ChildRow extends StatefulWidget {

  Child child;


  ChildRow(this.child);

  @override
  _ChildRowState createState() => _ChildRowState(child);
}

class _ChildRowState extends State<ChildRow> {

  Child child;


  _ChildRowState(this.child);

  @override
  Widget build(BuildContext context) {
    String image = InfixApi.root + child.photo;
    return InkWell(
      onTap: (){
        Route route = MaterialPageRoute(
            builder: (context) => ChildHome(AppFunction.students, AppFunction.studentIcons,child.id,image == InfixApi.root? 'http://saskolhmg.com/images/studentprofile.png' : InfixApi.root + child.photo));
        Navigator.pushReplacement(context, route);
      },
      splashColor: Colors.purple.shade200,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(image == InfixApi.root? 'http://saskolhmg.com/images/studentprofile.png' : InfixApi.root + child.photo),
              backgroundColor: Colors.grey,
            ),
            title: Text(child.name,style: Theme.of(context).textTheme.title,),
            subtitle: Text('Class : ${child.className} | Section : ${child.sectionName}',style: Theme.of(context).textTheme.display1),
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
          )
        ],
      ),
    );
  }
}
