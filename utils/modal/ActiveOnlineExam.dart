class ActiveOnlineExam {
  String title;
  String subject;
  String date;
  int status;

  ActiveOnlineExam({this.title, this.subject, this.date, this.status});

  factory ActiveOnlineExam.fromJson(Map<String, dynamic> json) {
    return ActiveOnlineExam(
        title: json['exam_title'],
        subject: json['subject_name'],
        date: json['date'],
        status: json['onlineExamTakeStatus']);
  }
}

class ActiveExamList {
  List<ActiveOnlineExam> activeExams;

  ActiveExamList(this.activeExams);

  factory ActiveExamList.fromJson(List<dynamic> jsonArr) {
    List<ActiveOnlineExam> examlist = List<ActiveOnlineExam>();

    examlist = jsonArr.map((i) => ActiveOnlineExam.fromJson(i)).toList();

    return ActiveExamList(examlist);
  }
}
