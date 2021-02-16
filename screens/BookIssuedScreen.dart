import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/BookIssued.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/BookIssuedRow.dart';
// ignore: must_be_immutable
class BookIssuedScreen extends StatefulWidget {
  var id;

  BookIssuedScreen({this.id});

  @override
  _BookIssuedScreenState createState() => _BookIssuedScreenState();
}

class _BookIssuedScreenState extends State<BookIssuedScreen> {
  Future<BookIssuedList> bookList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        bookList = getIssuedBooks(widget.id != null ? int.parse(widget.id):int.parse(value));
      });
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
        appBar: AppBarWidget.header(context, 'Book Issued'),
        backgroundColor: Colors.white,
        body: FutureBuilder<BookIssuedList>(
          future: bookList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data.bookIssues.length,
                  itemBuilder: (context, index) {
                    return BookListRow(snapshot.data.bookIssues[index]);
                  },
                ),
              );
            } else {
              return Center(child: Text('loading...'));
            }
          },
        ),
      ),
    );
  }

  Future<BookIssuedList> getIssuedBooks(int id) async {
    
    final response = await http.get(InfixApi.getStudentIssuedBook(id));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return BookIssuedList.fromJson(jsonData['data']['issueBooks']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
