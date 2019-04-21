import 'package:flutter/material.dart';
 import '../model/detail.dart';
import '../config/service_api.dart';
import '../config/service_url.dart';
import 'dart:convert';

class DetailProvde with ChangeNotifier{

  DetailModel goodsDetail = null;
  int choose = 0;

  changeStates(int states){
    choose = states;
    notifyListeners();
  }
  getGoodsDetail(String id) async{
    var formData = {
      'goodId':id
    };
   await request(servicePath['getGoodDetailById'],formData: formData).then((val){
      var res = json.decode(val.toString());
      goodsDetail = DetailModel.fromJson(res);
      print(res);
    });
    notifyListeners();
  }
}