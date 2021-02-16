class Book {
  String title;
  String author;
  String publication;
  String subjectName;
  String bookNo;
  String reckNo;
  int quantity;
  int price;

  Book(
      {this.title,
      this.author,
      this.publication,
      this.subjectName,
      this.bookNo,
      this.reckNo,
      this.quantity,
      this.price});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['book_title'],
      author: json['author_name'],
      publication: json['publisher_name'],
      subjectName: json['subject_name'],
      bookNo: json['book_number'],
      reckNo: json['rack_number'],
      quantity: json['quantity'],
      price: json['book_price'],
    );
  }
}

class BookList {
  List<Book> books;

  BookList(this.books);

  factory BookList.fromJson(List<dynamic> json) {
    List<Book> booklist = json.map((i) => Book.fromJson(i)).toList();

    return BookList(booklist);
  }
}
