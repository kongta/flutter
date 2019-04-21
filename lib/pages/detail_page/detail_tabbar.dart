import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/goods_detail.dart';
import 'package:provide/provide.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailTabbar extends StatelessWidget {
  final List<Tab> myTabs = <Tab> [
    Tab(text:'详情'),
    Tab(text:'评论')
  ];
  @override
  Widget build(BuildContext context) {
    return Provide<DetailProvde>(
      builder: (context,child,val){
        var states = Provide.value<DetailProvde>(context).choose;
        return Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: (){
                    Provide.value<DetailProvde>(context).changeStates(0);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          color: states==0?Colors.pink:Colors.white
                        )
                      )
                    ),
                    width: ScreenUtil().setWidth(375),
                    height: ScreenUtil().setHeight(90),
                    alignment: Alignment.center,
                    child: Text('详情',
                      style: TextStyle(
                        color: states==0?Colors.pink:Colors.black,
                        fontSize: ScreenUtil().setSp(30)
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Provide.value<DetailProvde>(context).changeStates(1);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          color: states==1?Colors.pink:Colors.white
                        )
                      )
                    ),
                    width: ScreenUtil().setWidth(375),
                    height: ScreenUtil().setHeight(90),
                    alignment: Alignment.center,
                     child: Text('评论',
                      style: TextStyle(
                        color: states==1?Colors.pink:Colors.black,
                        fontSize: ScreenUtil().setSp(30)
                      ),
                    ),
                  ),
                )
              ],
            )
          ),
          Container(
            child: _tabBody(),
          )
        ],
      );
      },
    );
  }
  Widget _tabBody(){
      return Provide<DetailProvde>(
        builder: (context,child,val){
          var html = Provide.value<DetailProvde>(context).goodsDetail.data.goodInfo.goodsDetail;
          var states = Provide.value<DetailProvde>(context).choose;
          if(states == 0){
            return Html(
              padding:EdgeInsets.only(bottom: ScreenUtil().setHeight(90)),
             data:html,
           );
          }else{
            return Container(
              padding:EdgeInsets.only(bottom: ScreenUtil().setHeight(90)),
              child: Text('没有数据'),
            );
          }
        },
      );  
  }
}