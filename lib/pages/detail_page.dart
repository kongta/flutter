import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/goods_detail.dart';
import './detail_page/detail_top_area.dart';
import './detail_page/detail_explain.dart';
import './detail_page/detail_tabbar.dart';
import './detail_page/detail_bottom.dart';
import './detail_page/detail_bottom2.dart';

class DetailPage extends StatelessWidget {
  final String goodsId;

  DetailPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('商品详情页')),
      body: FutureBuilder(
          future: _getGoodsDetail(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      DetailTopArea(),
                      DetailExplain(),
                      DetailTabbar()
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: DetailBottom(),
                  )
                ],
              );
            } else {
              return Center(
                child: Text('加载中...'),
              );
            }
          }),
    );
  }

  Future _getGoodsDetail(context) async {
    await Provide.value<DetailProvde>(context).getGoodsDetail(goodsId);
    return '加载完成';
  }
}
