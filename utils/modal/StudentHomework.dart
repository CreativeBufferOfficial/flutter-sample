class Homework {
  String description;
  String subjectName;
  String homeworkDate;
  String submissionDate;
  String evaluationDate;
  String fileUrl;
  String status;

  Homework(
      {this.description,
      this.subjectName,
      this.homeworkDate,
      this.submissionDate,
      this.evaluationDate,
      this.fileUrl,
      this.status});

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
        description: json['description'],
        subjectName: json['subject_name'],
        homeworkDate: json['homework_date'],
        submissionDate: json['submission_date'],
        evaluationDate: json['evaluation_date'],
        fileUrl: json['file'],
        status: json['status']);
  }
}
class HomeworkList{

  List<Homework> homeworks;

  HomeworkList(this.homeworks);

  factory HomeworkList.fromJson(List<dynamic> json){

    List<Homework> homeworklist = List<Homework>();

    homeworklist = json.map((i) => Homework.fromJson(i)).toList();

    return HomeworkList(homeworklist);
  }


}
