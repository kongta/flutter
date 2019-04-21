import 'package:flutter/material.dart';
import '../model/cartModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class CartProvide with ChangeNotifier {
  List<CartModel> cartList = [];
  double allMoney = 0;
  int allCount = 0;
  bool allChoose = false;

  // 商品增加数量
  addCount(String goodsId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartList.forEach((item){
      if(item.goodsId == goodsId){
        item.count++;
      }
    });
    prefs.setString('cartList', json.encode(cartList).toString());
    calData();
    notifyListeners();
  }
  // 商品减少
  reduceCount(String goodsId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartList.forEach((item){
      if(item.goodsId == goodsId){
        if(item.count <= 1){
          Fluttertoast.showToast(
            msg:'不能再减少了哦'
          );
          return;
        }
        item.count--;
      }
    });
    prefs.setString('cartList', json.encode(cartList).toString());
    calData();
    notifyListeners();
  }
  // 删除方法
  delCart(String goodsId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = 0;
    int temIndex = 0;
    cartList.forEach((item){
      if(item.goodsId == goodsId){
        temIndex = index;
      }
      index++;
    });
    cartList.removeAt(temIndex);
    prefs.setString('cartList', json.encode(cartList).toString());
    Fluttertoast.showToast(
        msg: '已删除',
    );
    calData();
    notifyListeners();
  }
  // 添加方法
  addCart(String goodsId, String goodsName, int count, double price, String images) async{
    cartList = [];// 初始化为空
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 从本地中获取
    String cartListString = prefs.getString('cartList');
    var isHave = false;
    if(cartListString == null){
      cartList = [];
    }else {
      List<Map> tempList = (json.decode(cartListString.toString()) as List).cast();
      tempList.forEach((item){
          cartList.add(new CartModel.fromJson(item));
       });
       // 判断添加的商品是否已存在
        cartList.forEach((item){
          if(item.goodsId == goodsId){
            item.count++;
            isHave = true;
          }
        });
    }
    if(!isHave){
      Map<String,dynamic> goods = {
        'goodsId':goodsId,
        'goodsName':goodsName,
        'count':count,
        'price':price,
        'images':images,
        'isChoose':true
      };
      cartList.add(CartModel.fromJson(goods));
    }
    prefs.setString('cartList', json.encode(cartList).toString());
    Fluttertoast.showToast(
        msg: '已加到购物车~',
    );
    calData();
    notifyListeners();
  }
  // 清空所有
  clearCart() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    cartList = [];
    pref.remove('cartList');
    allMoney = 0;
    print('清空了');
  }
  // 更改是否选中状态
  choose(String goodsId,bool flag) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = 0;
    cartList.forEach((item){
      if(item.goodsId == goodsId){
        cartList[index].isChoose = flag;
      }
      index++;
    });
    prefs.setString('cartList', json.encode(cartList).toString());
    calData();
    notifyListeners();
  }
  // 全部不选
  changeAllChooese(bool flag) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    allChoose = flag;
    if(flag){
      cartList.forEach((item)=>item.isChoose = true);
    }else{
      cartList.forEach((item)=>item.isChoose = false);
    }
    prefs.setString('cartList', json.encode(cartList).toString());
    calData();
    notifyListeners();
  }
  // 计算所有数量、金额、是否选中
  calData(){
    allMoney = 0;
    allCount = 0;
    allChoose = true;
    if(cartList.length > 0){
      cartList.forEach((item){
        if(item.isChoose){
          allMoney+=item.price*item.count;
          allCount+=item.count;
        }else if(!item.isChoose){
          allChoose = false;
        }
      });
    }
    notifyListeners();
  }
  // 获取本地储存中数据
  getCartList() async{
    print('获取');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartListString = prefs.getString('cartList');
    cartList = [];
    if(cartListString==null){
       cartList=[];
     }else{
       List<Map> tempList = (json.decode(cartListString.toString()) as List).cast();
       tempList.forEach((item){
          cartList.add(new CartModel.fromJson(item));
       });
        print('============>${cartList}');
     }
     calData();
    notifyListeners();
  }
}