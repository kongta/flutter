import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/cart_provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartBottom extends StatelessWidget {
  double allMoney = 0.00;
  int allCount = 0;
  bool allChoose = false;
  CartBottom(this.allMoney,this.allCount,this.allChoose);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(98),
      padding: EdgeInsets.fromLTRB(0, 2.0, 0, 2.0),
        child: Row(
          children: <Widget>[
            _checkBox(context),
            _addPrice(),
            _goButton()
          ],
        ),
    );
  }
  Widget _checkBox(context){
    return Provide<CartProvide>(builder: (context,child,val){
      return Container(
        width: ScreenUtil().setWidth(200),
        height: ScreenUtil().setHeight(98),
        child: Row(
          children: <Widget>[
            Checkbox(
              value: val.allChoose,
              activeColor: Colors.pink,
              onChanged: (val){
                print(val);
                Provide.value<CartProvide>(context).changeAllChooese(val);
              },
            ),
            Text('全选')
          ],
        ),
      );
    },);
    
  }
  Widget _addPrice(){
    return Container(
      width: ScreenUtil().setWidth(380),
      height: ScreenUtil().setHeight(98),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  width: ScreenUtil().setWidth(200),
                  child: Text('合计：'),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: ScreenUtil().setWidth(180),
                  child: Text('￥${allMoney}',
                    style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(26)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: ScreenUtil().setWidth(380),
            child: Text('满10元免配送费，预购免配送费'),
          ),
        ],
      ),
    );
  }
  Widget _goButton(){
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
      child: InkWell(
        onTap: (){

        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
             color: Colors.pink,
             borderRadius: BorderRadius.circular(5.0)
          ),
          child: Text('计算(${allCount})',
            style: TextStyle(color:Colors.white),
          ),
        ),
      )
    );
  }
}