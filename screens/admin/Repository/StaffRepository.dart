import 'package:Creativebuffer/screens/admin/ApiProvider/StaffApiProvider.dart';
import 'package:Creativebuffer/utils/modal/LeaveAdmin.dart';
import 'package:Creativebuffer/utils/modal/LibraryCategoryMember.dart';
import 'package:Creativebuffer/utils/modal/Staff.dart';

class StaffRepository{


  StaffApiProvider _provider = StaffApiProvider();

  Future<LibraryMemberList> getStaff(){
    return _provider.getAllCategory();
  }

  Future<StaffList> getStaffList(int id){
    return _provider.getAllStaff(id);
  }

  Future<LeaveAdminList> getStaffLeave(String url , String endPoint){
    return _provider.getAllLeave(url,endPoint);
  }

}