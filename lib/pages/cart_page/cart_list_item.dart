import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart_provide.dart';
import '../../model/cartModel.dart';

class CartListItem extends StatelessWidget {
  final CartModel item;
  var isChoose = false;
  CartListItem(this.item);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(220),
      margin: EdgeInsets.only(
        bottom: 2.0
      ),
      color: Colors.white,
      // padding: EdgeInsets.fromLTRB(0, 10.0, 8.0, 10.0),
      child: Row(
        children: <Widget>[
          _checkBox(context),
          _imgBox(),
          _goodsName(),
          _price(context)
        ],
      ),
    );
  }
  Widget _checkBox(context){
    return Container(
      child: Checkbox(
        value: item.isChoose,
        activeColor: Colors.pink,
        onChanged: (bool val){
          Provide.value<CartProvide>(context).choose(item.goodsId, val);
        },
      ),
    );
  }
  Widget _imgBox(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Colors.black12
        )
      ),
      width: ScreenUtil().setWidth(160),
      child: Image.network(item.images),
    );
  }
  Widget _goodsName(){
    return Container(
      width: ScreenUtil().setWidth(320),
      height: ScreenUtil().setHeight(190),
      padding: EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Text(item.goodsName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: _NumBox(),
          )
        ],
      ),
    );
  }
  Widget _NumBox(){
    return Provide<CartProvide>(builder: (context,child,val){
      return Container(
            width: 120.0,
            height: 35.0,
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Provide.value<CartProvide>(context).reduceCount(item.goodsId);
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0,color: Colors.black12)
                      ),
                      child: Center(
                        child: Text('-'),
                      ),
                    )
                  )
                ),
                Expanded(
                  child: InkWell(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.0,color: Colors.black12),
                          top: BorderSide(width: 1.0,color: Colors.black12),
                        )
                      ),
                      child: Center(
                        child: Text('${item.count}'),
                      ),
                    )
                  )
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Provide.value<CartProvide>(context).addCount(item.goodsId);
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0,color: Colors.black12)
                      ),
                      child: Center(
                        child: Text('+'),
                      ),
                    )
                  )
                ),
              ],
            ),
      );
    },);
  }
  Widget _price(context){
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerRight,
      width: ScreenUtil().setWidth(167),
      child: Column(
        children: <Widget>[
          Text(
            '￥${item.price}',
             maxLines: 1,
             overflow: TextOverflow.ellipsis,
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: (){
                print(item.goodsId);
                Provide.value<CartProvide>(context).delCart(item.goodsId);
              },
              child: Icon(
                Icons.delete_forever,
                color:Colors.black12,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}