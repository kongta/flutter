import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/goods_detail.dart';
import '../../provide/cart_provide.dart';
import '../../provide/currentIndex.dart';
import 'package:provide/provide.dart';
class DetailBottom extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var goodsInfo = Provide.value<DetailProvde>(context).goodsDetail.data.goodInfo;
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(90),
      child: Row(
        children: <Widget>[
          Provide<CartProvide>(builder: (context,child,val){
            return Stack(
              children: <Widget>[
                  InkWell(
                    onTap: (){
                      Provide.value<CurrentIndexProvide>(context).changeIndex(2);
                      Navigator.pop(context);
                    },
                      child:  Container(
                      height: ScreenUtil().setHeight(90),
                      width: ScreenUtil().setWidth(150),
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.pink,
                      )
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(12.0)
                      ),
                      padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                      child: Text('${val.allCount}',style: TextStyle(color: Colors.white,fontSize:ScreenUtil().setSp(20)),),
                    ),
                  )
              ],
            );
          }),
          InkWell(
            onTap: () async{
              await Provide.value<CartProvide>(context).addCart(goodsInfo.goodsId, goodsInfo.goodsName, 1, goodsInfo.presentPrice, goodsInfo.image1);
            },
            child: Container( 
              height: ScreenUtil().setHeight(90),
              color: Colors.pink,
              width: ScreenUtil().setWidth(300),
              alignment: Alignment.center,
              child: Text('加入购物车',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)))
            ),
          ),
          InkWell(
            onTap: () async{
              await Provide.value<CartProvide>(context).clearCart();
            },
            child: Container(
              height: ScreenUtil().setHeight(90),
              color: Colors.green,
              width: ScreenUtil().setWidth(300),
              alignment: Alignment.center,
              child: Text('立即购买',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)))
            ) ,
          )
        ],
      ),
    );
  }
}