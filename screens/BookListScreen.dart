import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Book.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/BookRowLayout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookListScreen extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookListScreen> {
  Future<BookList> books;

  @override
  void initState() {
    super.initState();
    books = getAllBooks();
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
        appBar: AppBarWidget.header(context, 'Book List'),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<BookList>(
            future: books,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.books.length,
                  itemBuilder: (context, index) {
                    return BookListRow(snapshot.data.books[index]);
                  },
                );
              } else {
                return Center(child: Text("loading..."));
              }
            },
          ),
        ),
      ),
    );
  }

  Future<BookList> getAllBooks() async {
    final response = await http.get(InfixApi.bookList);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return BookList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
