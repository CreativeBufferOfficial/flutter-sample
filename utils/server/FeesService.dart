import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/Fee.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Utils.dart';

class FeeService{

  int _id;

  FeeService(this._id);

  List<Fee> feeMap = List();
  List<String> totalMap = List();

  Future<List<Fee>> fetchFee() async {

    feeMap.clear();

    //Utils.showToast(InfixApi.getFeesUrl(_id));

    final response = await http.get(InfixApi.getFeesUrl(_id));

    var jsonData = json.decode(response.body);

    bool isSuccess = jsonData['success'];
    var data = jsonData['data']['fees'];

    if(isSuccess){
      for(var f in data){
        feeMap.add(Fee(f['fees_name'], f['due_date'], f['amount'].toString(), f['paid'].toString(), f['balance'].toString(),f['discount_amount'].toString(), f['fine'].toString(),f['fees_type_id']));
      }

    }else{
      Utils.showToast('try again later');
    }


    return feeMap;

  }

  Future<List<String>> fetchTotalFee() async {

    totalMap.clear();
    double _amount = 0;
    double _discount = 0;
    double _fine = 0;
    double _paid = 0;
    double _balance = 0;

    final response = await http.get(InfixApi.getFeesUrl(_id));

    var jsonData = json.decode(response.body);

    bool isSuccess = jsonData['success'];
    var data = jsonData['data']['fees'];

    if(isSuccess){
      for(var f in data){

        _amount = _amount + f['amount'];
        _discount = _discount + f['discount_amount'];
        _fine = _fine + f['fine'];
        _paid = _paid + f['paid'];
        _balance = _balance + f['balance'];

      }

      totalMap.add(_amount.toString());
      totalMap.add(_discount.toString());
      totalMap.add(_fine.toString());
      totalMap.add(_paid.toString());
      totalMap.add(_balance.toString());

    }else{
      Utils.showToast('try again later');
    }

    return totalMap;

  }


}