import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/cart_provide.dart';
import './cart_page/cart_list_item.dart';
import './cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('购物车'),),
      body: FutureBuilder(
        future: _getData(context),
        builder: (context,snapshot){
          if(snapshot.hasData){
            if(snapshot.data.length == 0){
              return Center(
                child: Text('暂无数据'),
              );
            }else{
              return Provide<CartProvide>(builder: (context,child,val){
                return Stack(
                  children: <Widget>[
                    ListView.builder(
                      itemCount: val.cartList.length,
                      itemBuilder: (context,index){
                        return CartListItem(snapshot.data[index]);
                      },
                      padding: EdgeInsets.only(bottom: 60.0),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: CartBottom(val.allMoney,val.allCount,val.allChoose),
                    )
                  ],
                );
              },);
              // return Stack(
              //   children: <Widget>[
              //     Provide<CartProvide>(builder: (context,child,val){
              //       return ListView.builder(
              //         itemCount: val.cartList.length,
              //         itemBuilder: (context,index){
              //           return CartListItem(snapshot.data[index]);
              //         },
              //           padding: EdgeInsets.only(bottom: 60.0),
              //       );
              //     }),
              //     Positioned(
              //       bottom: 0,
              //       left: 0,
              //       child: CartBottom(allMoney),
              //     )
              //   ],
              // );
            }
          }else{
            return Center(
              child: Text('加载中...'),
            );
          }
        }
      )
    );
  }
  Future _getData(context) async {
     print('进入了购物车');
     await Provide.value<CartProvide>(context).getCartList();
     return Provide.value<CartProvide>(context).cartList;
  }
}