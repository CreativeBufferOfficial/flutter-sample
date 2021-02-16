import 'package:flutter/material.dart';
import 'package:Creativebuffer/utils/modal/Book.dart';
// ignore: must_be_immutable
class BookListRow extends StatefulWidget {

  Book book;


  BookListRow(this.book);

  @override
  _BookListRowState createState() => _BookListRowState(book);
}

class _BookListRowState extends State<BookListRow> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation parentAnimation,childAnimation;
  Book book;


  _BookListRowState(this.book);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(seconds: 2),vsync: this);
    parentAnimation = Tween(begin: -1.0,end: 0.0).animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    childAnimation = Tween(begin: 1.0,end: 0.0).animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedBuilder(
          animation: parentAnimation,
          builder: (context,child){
            return Container(
              transform: Matrix4.translationValues(parentAnimation.value * width, 0.0, 0.0),
              child: Text(
                book.title,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontSize: 15.0),
                maxLines: 1,
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: parentAnimation,
          builder: (context,child){
            return Container(
              transform: Matrix4.translationValues(parentAnimation.value * width, 0.0, 0.0),
              child: Text(
                '${book.author} | ${book.publication}',
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontSize: 13.0),
                maxLines: 1,
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: parentAnimation,
          builder: (context,child){
            return Container(
              transform: Matrix4.translationValues(childAnimation.value * width, 0.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Subject',
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
                            book.subjectName,
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
                            'Book No',
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
                            book.bookNo == null ? 'not assigned':book.bookNo,
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
                            'Quantity',
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
                            book.quantity == null ? 'not assigned':book.quantity.toString(),
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
                            'Price',
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
                            book.price == null ? 'not assigned':book.price.toString(),
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
                            'Rack No',
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
                            book.reckNo == null ? 'not assigned':book.reckNo,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.display1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
        ),
      ],
    );
  }
}
