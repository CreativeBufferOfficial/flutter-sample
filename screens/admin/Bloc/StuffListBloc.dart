import 'package:Creativebuffer/screens/admin/Repository/StaffRepository.dart';
import 'package:Creativebuffer/utils/modal/Staff.dart';
import 'package:rxdart/rxdart.dart';

class StuffListBloc{

  int id;

  StuffListBloc({this.id});

  final _repository = StaffRepository();

  final _subject = BehaviorSubject<StaffList>();

  getStaffList() async {
    StaffList list = await _repository.getStaffList(id);
    _subject.sink.add(list);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<StaffList> get getStaffSubject => _subject;

}
