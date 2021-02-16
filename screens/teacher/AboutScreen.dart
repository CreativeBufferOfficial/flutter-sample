import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/modal/InfixMap.dart';
import 'package:Creativebuffer/utils/server/About.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/ProfileListRow.dart';

// ignore: must_be_immutable
class AboutScreen extends StatelessWidget {
  About about = About();
  @override
  Widget build(BuildContext context) {

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
    ));

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Scaffold(
        appBar: AppBarWidget.header(context, 'About'),
        backgroundColor: Colors.white,
        body: getAboutList(context),
      ),
    );
  }

  Widget getAboutList(BuildContext context){
    return FutureBuilder<List<InfixMap>>(
      future: about.fetchAboutServices(),
      builder: (context,snapshot){
        if(snapshot.hasData){
         return Padding(
           padding: const EdgeInsets.all(8.0),
           child: Column(
             children: <Widget>[
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text('${snapshot.data[0].value}',style: Theme.of(context).textTheme.display1,),
               ),
                 Expanded(
                   child: ListView.builder(
                     itemCount: snapshot.data.length-1,
                     itemBuilder: (context,index){
                       return ProfileRowList(
                           snapshot.data[index+1].key, snapshot.data[index+1].value);
                     },
                   ),
                 ),
             ],
           ),
         );
        }else{
          return Center(
            child: Text(
              'Loading...',
              style: Theme.of(context).textTheme.title,
            ),
          );
        }
      },
    );
  }

}
