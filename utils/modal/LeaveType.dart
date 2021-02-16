class LeaveType {
  String type;
  int id;

  LeaveType({this.type, this.id});

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(id: json['id'], type: json['type']);
  }
}
class LeaveList {
  List<LeaveType> types;

  LeaveList(this.types);

  factory LeaveList.fromJson(List<dynamic> json) {
    List<LeaveType> typelist = List<LeaveType>();
    typelist = json.map((i) => LeaveType.fromJson(i)).toList();
    return LeaveList(typelist);
  }
}
