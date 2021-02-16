import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/InfixMap.dart';

class ProfileService {
  String email;
  String password;
  String id;
  String schoolId;
  ProfileService({this.email,this.password,this.id,this.schoolId});

  List<InfixMap> infixMap = List();

  Future<List<InfixMap>> fetchPersonalServices(String section) async {

    infixMap.clear();

    final response = await http.get(id == null ? InfixApi.login(email, password) : InfixApi.getChildren(id));

    print(response.body);

    var jsonData = json.decode(response.body);

    var details = jsonData['data']['userDetails'];
    var religion = jsonData['data']['religion'];
    var blood = jsonData['data']['blood_group'];
    var transport = jsonData['data']['transport'];

    switch(section){

      case 'personal':
        infixMap.add(InfixMap('Date of birth',details['date_of_birth']));
        infixMap.add(InfixMap('Religion',religion != null ? religion['name'] : null));
        infixMap.add(InfixMap('Phone number',details['mobile']));
        infixMap.add(InfixMap('Email address',details['email']));
        infixMap.add(InfixMap('Present address',details['current_address']));
        infixMap.add(InfixMap('Parmanent address',details['permanent_address']));
        infixMap.add(InfixMap('Father\'s name',details['fathers_name']));
        infixMap.add(InfixMap('Mother\'s name',details['mothers_name']));
        infixMap.add(InfixMap('Blood group',blood != null ? blood['name'] : null));
        break;
      case 'parents':
        infixMap.add(InfixMap('Father\'s name',details['fathers_name']));
        infixMap.add(InfixMap('Father\'s phone',details['fathers_mobile']));
        infixMap.add(InfixMap('Father\'s occupation',details['fathers_occupation']));
        infixMap.add(InfixMap('Mother\'s name',details['mothers_name']));
        infixMap.add(InfixMap('Mother\'s phone',details['mothers_mobile']));
        infixMap.add(InfixMap('Mother\'s occupation',details['mothers_occupation']));
        infixMap.add(InfixMap('Guardian\'s name',details['guardians_name']));
        infixMap.add(InfixMap('Guardian\'s email',details['guardians_email']));
        infixMap.add(InfixMap('Guardian\'s occupation',details['guardians_occupation']));
        infixMap.add(InfixMap('Guardian\'s phone',details['guardians_mobile']));
        infixMap.add(InfixMap('Guardian\'s relation',details['guardians_relation']));
        break;
      case 'transport':
        if(transport != null) {
          infixMap.add(InfixMap('Driver\'s name', transport['driver_name']));
          infixMap.add(InfixMap('Car no', transport['vehicle_no']));
          infixMap.add(InfixMap('Car model', transport['vehicle_model']));
          infixMap.add(InfixMap('Car info', transport['note']));
        }
        break;
      case 'others':
        infixMap.add(InfixMap('Height',details['height']+'(inch)'));
        infixMap.add(InfixMap('Weight',details['weight']+'(kg)'));
        infixMap.add(InfixMap('Caste',details['caste']));
        infixMap.add(InfixMap('National id',details['national_id_no']));
        break;
      case 'profile':
        infixMap.add(InfixMap('name',details['full_name']));
        infixMap.add(InfixMap('section_name',details['section_name']));
        infixMap.add(InfixMap('class_name',details['class_name']));
        infixMap.add(InfixMap('roll_no',details['roll_no'].toString()));
        infixMap.add(InfixMap('adm',details['admission_no'].toString()));
        break;

    }

    //Utils.showToast(infixMap[0].key+' '+infixMap[0].value);

    return infixMap;
  }



}