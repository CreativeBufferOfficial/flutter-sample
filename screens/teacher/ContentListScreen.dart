import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Content.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/Content_row.dart';

class ContentListScreen extends StatefulWidget {
  @override
  _ContentListScreenState createState() => _ContentListScreenState();
}

class _ContentListScreenState extends State<ContentListScreen> {

  Future<ContentList> contents;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    contents = fetchContent();
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
        appBar: AppBarWidget.header(context, 'Contents'),
        backgroundColor: Colors.white,
        body: FutureBuilder<ContentList>(
          future: contents,
          builder: (context,snapshot){
            if(snapshot.hasData && snapshot != null){
              return AnimatedList(
                key: _listKey,
                initialItemCount: snapshot.data.contents.length,
                itemBuilder: (context , index,animation){
                  return ContentRow(snapshot.data.contents[index],animation,onPressed: (){
//                     snapshot.data.contents.removeAt(index);
//                     Utils.showToast('$index');
                     _removeSingleItems(index, snapshot.data.contents);
                  },);
                },
              );
            }else{
              return Text("loading...");
            }
          },
        ),
      ),
    );
  }


  void _removeSingleItems(int index,List<Content> cList) {
//    Content removedItem = cList.removeAt(index);
//    // This builder is just so that the animation has something
//    // to work with before it disappears from view since the original
//    // has already been deleted.
//    AnimatedListRemovedItemBuilder builder = (context, animation) {
//      return Content_row(removedItem,animation);
//    };
//    _listKey.currentState.removeItem(index, builder);
  }


  Future<ContentList> fetchContent() async{

    final response = await http.get(InfixApi.getAllContent());

    if(response.statusCode == 200){

      var jsonData = jsonDecode(response.body);

      return ContentList.fromJson(jsonData['data']['content_list']);

    }else{
      throw Exception('failed to load');
    }
  }

}
