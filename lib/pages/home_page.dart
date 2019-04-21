import 'package:flutter/material.dart';
import '../config/service_api.dart';
import '../config/service_url.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../router/application.dart';
class HomePage extends StatefulWidget {
  final Widget child;
  HomePage({Key key, this.child}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final List<Map> hotGoodsList = [];
  int page = 1;

  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活+'),
      ),
      body: FutureBuilder(
        future: request(servicePath['homePageContent'], formData: formData),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            List<Map> swiperList = (data['data']['slides'] as List).cast();
            List<Map> navigatorList = (data['data']['category'] as List).cast();
            String picUrl = (data['data']['advertesPicture']['PICTURE_ADDRESS']);
            String leaderImage = (data['data']['shopInfo']['leaderImage']);
            String leadrPhone = (data['data']['shopInfo']['leaderPhone']);
            List<Map> recommendList = (data['data']['recommend'] as List).cast();
            String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
            List<Map> floor1 = (data['data']['floor1'] as List).cast();
            String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
            List<Map> floor2 = (data['data']['floor2'] as List).cast();
            String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];
            List<Map> floor3 = (data['data']['floor3'] as List).cast();
            return EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                // 背景颜色
                bgColor: Colors.transparent,
                // 文字颜色
                textColor: Colors.black,
                loadText: '上拉加载',
                loadReadyText: '松手加载',
                loadingText: '正在加载',
                noMoreText: '加载完成',
                loadHeight: 50.0,
                showMore: true,
                moreInfoColor:Colors.black,
                moreInfo: '更新于%T',
              ),
              refreshHeader: ClassicsHeader(
                key: _headerKey,
                bgColor: Colors.transparent,
                textColor: Colors.black,
                refreshText:'下拉刷新',
                refreshReadyText: '松手刷新',
                refreshingText: '正在刷新',
                refreshedText:'刷新完成',
                moreInfoColor:Colors.black,
                showMore: true,
                moreInfo: '更新于%T',
              ),
              child: ListView(
                children: <Widget>[
                  SwiperShow(swiperList: swiperList),
                  TopNavigator(navigatorList: navigatorList),
                  AdBanner(picUrl: picUrl),
                  LeaderPart(image: leaderImage, phone: leadrPhone),
                  Recommend(recommendList: recommendList),
                  FloorGoods(picUrl: floor1Title, goodsList: floor1),
                  FloorGoods(picUrl: floor2Title, goodsList: floor2),
                  FloorGoods(picUrl: floor3Title, goodsList: floor3),
                  HotArea(hotGoodsList: hotGoodsList)
                ],
              ),
              // 下拉加载
              loadMore: () async {
                // 获取火爆专区数据
                print('页数为${page}');
                var formData = {'page': page};
                await request(servicePath['homePageHot'], formData: formData).then((val) {
                  print(val);
                  var data = json.decode(val.toString());
                  List<Map> hotList = (data['data'] as List).cast();
                  setState(() {
                    hotGoodsList.addAll(hotList);
                    page++;
                  });
                });
              },
               onRefresh: () async {
                await new Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    page = 1;
                    hotGoodsList.clear();
                  });
                });
              },
            );
          } else {
            return Center(
              child: Text('加载中'),
            );
          }
        },
      ),
    );
  }
}

// 轮播组件
class SwiperShow extends StatelessWidget {
  final List swiperList;

  SwiperShow({Key key, this.swiperList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.getInstance().setHeight(333),
      width: ScreenUtil.getInstance().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: (){
              Application.router.navigateTo(context, '/detail?id=${swiperList[index]['goodsId']}');
            },
            child:  Image.network(
                "${swiperList[index]['image']}",
                fit: BoxFit.fill,
                  ),
            );
        },
        itemCount: swiperList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 导航
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key, this.navigatorList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeLast();
    }
    return Container(
      color: Colors.white,
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        physics: new NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _navigatorItem(context, item);
        }).toList(),
      ),
    );
  }

  // 每一项
  Widget _navigatorItem(BuildContext contextt, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Image.network(item['image'], width: ScreenUtil().setWidth(95)),
            Text(item['mallCategoryName'])
          ],
        ),
      ),
    );
  }
}

// 广告
class AdBanner extends StatelessWidget {
  final String picUrl;

  AdBanner({Key key, this.picUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(picUrl),
    );
  }
}

// 店长
class LeaderPart extends StatelessWidget {
  final String image;
  final String phone;

  LeaderPart({Key key, this.image, this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          print(phone);
          _callLeader(phone);
        },
        child: Image.network(image),
      ),
    );
  }

  // 拨打电话的方法
  void _callLeader(url) async {
    // 电话
    url = 'tel:' + url;
    // 短信
    // url='sms:'+url;
    // 网页
    // url = 'http://baidu.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '非法链接';
    }
  }
}

// 推荐模块
class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({Key key, this.recommendList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5.0, 0, 0),
      child: Column(
        children: <Widget>[_recommendTitle(), _recommendListView()],
      ),
    );
  }

  // 推荐标题
  Widget _recommendTitle() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
            Border(bottom: BorderSide(color: Colors.black12, width: 0.5))),
            child: Text('商品推荐'));
  }

  // 列表项
  Widget _listItem(context,index) {
    return InkWell(
        onTap: () {
          Application.router.navigateTo(context, '/detail?id=${recommendList[index]['goodsId']}');
        },
        child: Container(
          width: ScreenUtil().setWidth(250),
          height: ScreenUtil().setHeight(350),
          padding: EdgeInsets.all(7.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(left: BorderSide(width: 0.5, color: Colors.black12))),
          child: Column(
            children: <Widget>[
              Image.network(recommendList[index]['image']),
              Text('￥${recommendList[index]['mallPrice']}'),
              Text(
                '￥${recommendList[index]['price']}',
                style: TextStyle(
                    color: Colors.black12,
                    decoration: TextDecoration.lineThrough),
              )
            ],
          ),
        ));
  }

  // 列表
  Widget _recommendListView() {
    return Container(
        height: ScreenUtil().setHeight(350),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _listItem(context,index);
          },
        ));
  }
}

// 楼层商品
class FloorGoods extends StatelessWidget {
  final String picUrl;
  final List goodsList;
  FloorGoods({Key key, this.picUrl, this.goodsList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_topPic(picUrl), _floorOne(), _floorTwo()],
      ),
    );
  }

  // 顶部图片
  Widget _topPic(picUrl) {
    return Container(
      child: Image.network(picUrl),
    );
  }

  //商品每每一项
  Widget _goodsItem(Map goods) {
    return Container(
        padding: EdgeInsets.all(2.0),
        width: ScreenUtil().setWidth(375),
        child: InkWell(
            onTap: () {
              print('点击了楼层商品');
            },
            child: Image.network(goods['image'])));
  }

  // 商品楼层1
  Widget _floorOne() {
    return Container(
      child: Row(
        children: <Widget>[
          _goodsItem(goodsList[0]),
          Column(
            children: <Widget>[
              _goodsItem(goodsList[1]),
              _goodsItem(goodsList[2]),
            ],
          )
        ],
      ),
    );
  }

  // 商品楼层2
  Widget _floorTwo() {
    return Row(
      children: <Widget>[
        _goodsItem(goodsList[3]),
        _goodsItem(goodsList[4]),
      ],
    );
  }
}

// 火爆专区
class HotArea extends StatelessWidget {
  final List hotGoodsList;

  HotArea({Key key, this.hotGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_hotTitle(), _wrapList(context)],
      ),
    );
  }

  // 标题
  Widget _hotTitle() {
    if(hotGoodsList.length != 0){
      return Container(
      padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
      margin: EdgeInsets.only(top:5.0),
      width: ScreenUtil().setWidth(750),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          border:Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.black12
                  )
          )
      ),
      child: Text('火爆专区'),
    );
    }else{
      return Text('没有数据');
    }
  }

  // 子项
  Widget _hotItem(context,item) {
    return InkWell(
        onTap: () {
          Application.router.navigateTo(context,"/detail?id=${item['goodsId']}");
        },
        child: Container(
          padding: EdgeInsets.all(5.0),
          color: Colors.white,
          width: ScreenUtil().setWidth(372),
          child: Column(
            children: <Widget>[
              Image.network(item['image'], width: ScreenUtil().setWidth(370)),
              Text(
                item['name'],
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
              ),
              Row(
                children: <Widget>[
                  Text("￥${item['mallPrice']}"),
                  Text(
                    "￥${item['mallPrice']}",
                    style: TextStyle(
                        color: Colors.black54,
                        decoration: TextDecoration.lineThrough),
                  )
                ],
              ),
            ],
          ),
        ));
  }
  Widget _wrapList(context) {
      return Container(
        child: Wrap(
            spacing: 2,
            children: hotGoodsList.map((val) {
              return _hotItem(context,val);
            }).toList()),
      );
  }
}
