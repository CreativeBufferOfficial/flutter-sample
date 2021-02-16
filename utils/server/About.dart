import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/InfixMap.dart';

class About {
  List<InfixMap> infixMap = List();

  Future<List<InfixMap>> fetchAboutServices() async {
    infixMap.clear();

    final response = await http.get(InfixApi.about);

    var jsonData = json.decode(response.body);

    var data = jsonData['data'];

    infixMap.add(InfixMap('Description', data['main_description']));
    infixMap.add(InfixMap('Address', data['address']));
    infixMap.add(InfixMap('Phone', data['phone']));
    infixMap.add(InfixMap('Email', data['email']));
    infixMap.add(InfixMap('School Code', data['school_code']));
    infixMap.add(InfixMap('Session', data['session']));

    return infixMap;
  }

  static Future<int> phonePermission() async{
    final response = await http.get(InfixApi.currentPermission);
    var jsonData = json.decode(response.body);
    int no = jsonData['data']['phone_number_privacy'];
    return no;
  }

}
