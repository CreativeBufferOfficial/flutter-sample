import 'package:Creativebuffer/screens/admin/Repository/StaffRepository.dart';
import 'package:Creativebuffer/utils/modal/LeaveAdmin.dart';
import 'package:rxdart/rxdart.dart';

class StuffLeaveListBloc{

  String url;
  String endPoint;

  StuffLeaveListBloc(this.url, this.endPoint);

  final _repository = StaffRepository();

  final _subject = BehaviorSubject<LeaveAdminList>();

  getStaffLeaveList() async {
    LeaveAdminList list = await _repository.getStaffLeave(url,endPoint);
    _subject.sink.add(list);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<LeaveAdminList> get getStaffLeaveSubject => _subject;

}
