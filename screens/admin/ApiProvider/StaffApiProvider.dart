import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/LeaveAdmin.dart';
import 'package:Creativebuffer/utils/modal/LibraryCategoryMember.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:Creativebuffer/utils/modal/Staff.dart';
class StaffApiProvider{

  Future<LibraryMemberList> getAllCategory() async {
    final response = await http.get(InfixApi.getStuffCategory);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LibraryMemberList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<StaffList> getAllStaff(int staffId) async {
    final response = await http.get(InfixApi.getAllStaff(staffId));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StaffList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<LeaveAdminList> getAllLeave(String url , String endPoint) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LeaveAdminList.fromJson(jsonData['data'][endPoint]);
    } else {
      throw Exception('Failed to load');
    }
  }

}