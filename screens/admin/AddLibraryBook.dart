import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/AdminBookCategory.dart';
import 'package:Creativebuffer/utils/modal/AdminBookSubject.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:Creativebuffer/utils/widget/Line.dart';

class AddAdminBook extends StatefulWidget {
  @override
  _AddAdminBookState createState() => _AddAdminBookState();
}

class _AddAdminBookState extends State<AddAdminBook> {
  String id;
  var selectedCategory;
  var selectedCategoryId;
  var selectedSubject;
  var selectedSubjectId;

  Future<AdminSubjectList> subjectList;
  Future<AdminCategoryList> categoryList;
  TextEditingController titleController = TextEditingController();
  TextEditingController bookNoController = TextEditingController();
  TextEditingController isbnNoController = TextEditingController();
  TextEditingController publisherNameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController rackNoController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String maxDateTime = '2031-11-25';
  String initDateTime = '2019-05-17';
  String _format = 'yyyy-MMMM-dd';
  DateTime date;
  DateTime _dateTime;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  String _selectedaAssignDate = 'Date';

  Response response;
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();

    Utils.getStringValue('id').then((value) {
      id = value;
    });

    subjectList = getAllSubject();
    subjectList.then((value) {
      selectedSubject = value.subjects[0].title;
      selectedSubjectId = value.subjects[0].id;
    });

    categoryList = getAllCategory();
    categoryList.then((value) {
      selectedCategory = value.categories[0].title;
      selectedCategoryId = value.categories[0].id;
    });
    //date time init
    date = DateTime.now();
    //initial date
    initDateTime =
        '${date.year}-${getAbsoluteDate(date.month)}-${getAbsoluteDate(date.day)}';
    _dateTime = DateTime.parse(initDateTime);
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
        appBar: AppBarWidget.header(context, 'Add Book'),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: FutureBuilder<AdminSubjectList>(
                          future: subjectList,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return getSubjectsDropdown(
                                  snapshot.data.subjects);
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<AdminCategoryList>(
                          future: categoryList,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return getCategoriesDropdown(
                                  snapshot.data.categories);
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: titleController,
                    style: Theme.of(context).textTheme.display1,
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: 'Enter title here', border: InputBorder.none),
                  ),
                  BottomLine(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: bookNoController,
                          style: Theme.of(context).textTheme.display1,
                          autofocus: false,
                          decoration: InputDecoration(
                              hintText: 'Book number',
                              border: InputBorder.none),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: isbnNoController,
                          style: Theme.of(context).textTheme.display1,
                          autofocus: false,
                          decoration: InputDecoration(
                              hintText: 'ISBN', border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                  BottomLine(),
                  TextField(
                    controller: publisherNameController,
                    style: Theme.of(context).textTheme.display1,
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: 'Publisher name', border: InputBorder.none),
                  ),
                  BottomLine(),
                  TextField(
                    controller: authorController,
                    style: Theme.of(context).textTheme.display1,
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: 'Author name', border: InputBorder.none),
                  ),
                  BottomLine(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: rackNoController,
                          style: Theme.of(context).textTheme.display1,
                          autofocus: false,
                          decoration: InputDecoration(
                              hintText: 'Rack number',
                              border: InputBorder.none),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: quantityController,
                          style: Theme.of(context).textTheme.display1,
                          autofocus: false,
                          decoration: InputDecoration(
                              hintText: 'Quantity', border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                  BottomLine(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          controller: priceController,
                          style: Theme.of(context).textTheme.display1,
                          decoration: InputDecoration(
                              hintText: 'Price', border: InputBorder.none),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              pickerTheme: DateTimePickerTheme(
                                confirm: Text('Done',
                                    style: TextStyle(color: Colors.red)),
                                cancel: Text('cancel',
                                    style: TextStyle(color: Colors.cyan)),
                              ),
                              minDateTime: DateTime.parse(initDateTime),
                              maxDateTime: DateTime.parse(maxDateTime),
                              initialDateTime: _dateTime,
                              dateFormat: _format,
                              locale: _locale,
                              onChange: (dateTime, List<int> index) {
                                setState(() {
                                  _dateTime = dateTime;
                                });
                              },
                              onConfirm: (dateTime, List<int> index) {
                                setState(() {
                                  setState(() {
                                    _dateTime = dateTime;
                                    print(
                                        '${_dateTime.year}-0${_dateTime.month}-${_dateTime.day}');
                                    _selectedaAssignDate =
                                        '${_dateTime.year}-${getAbsoluteDate(_dateTime.month)}-${getAbsoluteDate(_dateTime.day)}';
                                    dateController.text = _selectedaAssignDate;
                                  });
                                });
                              },
                            );
                          },
                          child: Text(
                            _selectedaAssignDate,
                            style: Theme.of(context).textTheme.display1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  BottomLine(),
                  TextField(
                    controller: descriptionController,
                    style: Theme.of(context).textTheme.display1,
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: 'Description', border: InputBorder.none),
                  ),
                  BottomLine(),
                  Container(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 100.0),
                    width: double.infinity,
                    child: RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      color: Colors.deepPurpleAccent,
                      onPressed: () {
                        String title = titleController.text;
                        String bookNo = bookNoController.text;
                        String isbn = isbnNoController.text;
                        String pubName = publisherNameController.text;
                        String author = authorController.text;
                        String rackNo = rackNoController.text;
                        String quantity = quantityController.text;
                        String price = priceController.text;
                        String description = descriptionController.text;

                        if (title.isNotEmpty &&
                            bookNo.isNotEmpty &&
                            isbn.isNotEmpty &&
                            id.isNotEmpty) {
                          addBookData(
                                  title,
                                  '$selectedCategoryId',
                                  bookNo,
                                  isbn,
                                  pubName,
                                  author,
                                  '$selectedSubjectId',
                                  rackNo,
                                  quantity,
                                  price,
                                  description,
                                  '$_selectedaAssignDate',
                                  id)
                              .then((value) {
                            if (value) {
                              titleController.text = '';
                              bookNoController.text = '';
                              isbnNoController.text = '';
                              publisherNameController.text = '';
                              authorController.text = '';
                              rackNoController.text = '';
                              quantityController.text = '';
                              priceController.text = '';
                              descriptionController.text = '';
                            }
                          });
                        }
                      },
                      child: new Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSubjectsDropdown(List<AdminSubject> subjects) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: subjects.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(item.title),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.display1.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            //_selectedClass = value;
            selectedSubject = value;
            selectedSubjectId = getCode(subjects, value);
            debugPrint('User select $selectedSubjectId');
          });
        },
        value: selectedSubject,
      ),
    );
  }

  Widget getCategoriesDropdown(List<Admincategory> categories) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: categories.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(item.title),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.display1.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            //_selectedClass = value;
            selectedCategory = value;
            selectedCategoryId = getCode(categories, value);
            debugPrint('User select $selectedCategoryId');
          });
        },
        value: selectedCategory,
      ),
    );
  }

  int getCode<T>(T t, String title) {
    int code;
    for (var cls in t) {
      if (cls.title == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  Future<AdminSubjectList> getAllSubject() async {
    final response = await http.get(InfixApi.subjectList);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AdminSubjectList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<AdminCategoryList> getAllCategory() async {
    final response = await http.get(InfixApi.bookCategory);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AdminCategoryList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  Future<bool> addBookData(
      String title,
      String categoryId,
      String bookNo,
      String isbn,
      String publisherName,
      String authorName,
      String subjectId,
      String reckNo,
      String quantity,
      String price,
      String details,
      String date,
      String userId) async {

    response = await dio.get(InfixApi.addBook(
        title,
        categoryId,
        bookNo,
        isbn,
        publisherName,
        authorName,
        subjectId,
        reckNo,
        quantity,
        price,
        details,
        date,
        userId));
    if (response.statusCode == 200) {
      Utils.showToast('Book Added');
      return true;
    } else {
      return false;
    }
  }
}
