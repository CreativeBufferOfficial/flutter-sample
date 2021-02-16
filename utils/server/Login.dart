import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:Creativebuffer/utils/FunctinsData.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  final String email;
  final String password;

  Login(this.email,this.password);

  Future<bool> getData(BuildContext context) async {
    bool isSuccessed = false;
    int id;
    int rule;
    int schoolId;
    String image;
    String isAdministrator;
//    InfixApi api = InfixApi();


    Response response = await get(InfixApi.login(email, password));
    //print(InfixApi.login(email, password,sId));
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> user = jsonDecode(response.body) as Map;
      isSuccessed = user['success'];
      id = user['data']['user']['id'];
      rule = user['data']['user']['role_id'];
      schoolId = user['data']['user']['school_id'];
      isAdministrator = user['data']['user']['is_administrator'];
      image = user['data']['userDetails'] != null ? user['data']['userDetails']['staff_photo']:null;

      if (isSuccessed) {
        saveBooleanValue('isLogged', isSuccessed);
        saveStringValue('email', email);
        saveStringValue('password', password);
        saveStringValue('id','$id');
        saveStringValue('rule', '$rule');
        saveStringValue('schoolId', '$schoolId');
        saveStringValue('image', '$image');
        saveStringValue('isAdministrator', '$isAdministrator');
        saveStringValue('lang', 'en');
        AppFunction.getFunctions(context,rule.toString());
      }

    }
    return isSuccessed;
  }

  Future<bool> saveBooleanValue(String key ,bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(key, value);
  }

  Future<bool> saveStringValue(String key ,String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

}
