class Leave{
  int id;
  String type;
  String status;
  String from;
  String to;
  String apply;

  Leave({this.id, this.type, this.status, this.from, this.to, this.apply});

  factory Leave.fromJson(Map<String,dynamic> json){
    return Leave(
      id:json['id'],
      type: json['type'],
      to: json['leave_to'],
      from: json['leave_from'],
      apply: json['apply_date'],
      status: json['approve_status'],
    );
  }
}
class LeaveList{

  List<Leave> leaves;

  LeaveList(this.leaves);

  factory LeaveList.fromJson(List<dynamic> json){

    List<Leave> contentList = List<Leave>();

    contentList = json.map((i)=> Leave.fromJson(i)).toList();

    return LeaveList(contentList);
  }

}