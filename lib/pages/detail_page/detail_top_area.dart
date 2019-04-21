import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/goods_detail.dart';
import 'package:provide/provide.dart';

class DetailTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailProvde>(
      builder: (context,child,val){
        var goodsInfo = Provide.value<DetailProvde>(context).goodsDetail.data.goodInfo;
        if (goodsInfo != null){
          return Container(
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  _imageArea(goodsInfo.image1),
                  _goodsName(goodsInfo.goodsName),
                  _goodsNum(goodsInfo.goodsSerialNumber),
                  _goodsPrice(goodsInfo.presentPrice,goodsInfo.oriPrice)
                ],
              ),
          );
        }else{
          return Text('正在加载中...');
        }
      },
    );
  }
  Widget _imageArea(src){// 图片区域
    return Container(
      child: Image.network(
        src,
        width: ScreenUtil().setWidth(740),
      ),
    );
  }
  Widget _goodsName(name){ //商品名称
    return Container(
      width: ScreenUtil().setWidth(740),
      padding: EdgeInsets.only(top: 7.0,bottom: 7.0),
      child: Text(
        name,
        maxLines: 1,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30)
        ),
      ),
    );
  }
  Widget _goodsNum(num){ //商品编号
    return Container(
      width: ScreenUtil().setWidth(740),
      child: Text(
        '编号：${num}',
        style: TextStyle(
          color: Colors.black38,
          fontSize: ScreenUtil().setSp(26)
        ),
      ),
    );
  }
  Widget _goodsPrice(now,old){
    return Container(
     width: ScreenUtil().setWidth(730),
     padding: EdgeInsets.only(top:5.0),
     child:Row(
       children: <Widget>[
         Container(
           margin: EdgeInsets.only(right: 15.0),
           child: Text(
              '￥${now}',
              style:TextStyle(
                color: Colors.orange,
                fontSize: ScreenUtil().setSp(32)
              ),
            ),
         ),
         Text(
           '市场价:',
           style:TextStyle(
              fontSize: ScreenUtil().setSp(30)
            )
         ),
         Text(
           '￥${old}',
           style:TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: Colors.black26,
              decoration:TextDecoration.lineThrough
            )
         )
       ],
     )
    );
  }
}