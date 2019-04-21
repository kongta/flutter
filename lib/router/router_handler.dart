import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/detail_page.dart';

// 详情页
Handler DetailPageHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    String goodsd = params['id'].first;
    return DetailPage(goodsd);
  }
);