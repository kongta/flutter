import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategory = [];
  int rightIndex = 0;// 右侧类别索引
  String categoryId = '4';// 默认大类id4
  int page = 1; //页数
  String loadText = '加载完成';//上拉加载底部text
  String subId = '';//子分类ID

  getChildCategory(List<BxMallSubDto> list,String id) {// 更改大类
    page = 1;
    loadText = '';

    rightIndex = 0;
    categoryId = id;
    
    subId = '';

    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '00';
    all.mallSubName = '全部';
    all.comments = 'null';
    childCategory = [all];
    childCategory.addAll(list);
    notifyListeners();
  }

  changeIndex(int index,String id) { // 更改小类
    page = 1;
    subId = id;
    rightIndex = index;
    notifyListeners();
  }

  addPage(){ //页数增加
    page++;
    notifyListeners();
  }

  changeText(String text){// 改变上拉加载文字
    loadText = text;
    notifyListeners();
  } 
}
