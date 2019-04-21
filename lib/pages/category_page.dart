import 'package:flutter/material.dart';
import '../config/service_api.dart';
import '../config/service_url.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../model/categoryGoodsList.dart';
import '../provide/categoty_good_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftNav(),
            Column(
              children: <Widget>[RightNav(), RightList()],
            )
          ],
        ),
      ),
    );
  }
}

// 左边分类
class LeftNav extends StatefulWidget {
  @override
  _LeftNavState createState() => _LeftNavState();
}

class _LeftNavState extends State<LeftNav> {
  List list = [];
  var currentIndex = 0;

  @override
  void initState() {
    getCategory();
    getCategoryGoodsList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(right: BorderSide(color: Colors.black12, width: 0.5))),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _listItem(index);
        },
      ),
    );
  }

  // 每一项
  Widget _listItem(int index) {
    bool isClick = false;
    isClick = (index == currentIndex) ? true : false;
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        Provide.value<ChildCategory>(context)
            .getChildCategory(childList, list[index].mallCategoryId);
        // 点击调用商品列表
        var categoryId = list[index].mallCategoryId;
        getCategoryGoodsList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(90),
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black12, width: 0.5))),
        child: Text(list[index].mallCategoryName,
            style: TextStyle(
                fontSize:
                    isClick ? ScreenUtil().setSp(34) : ScreenUtil().setSp(28),
                color: isClick ? Colors.pink : Colors.black)),
      ),
    );
  }

  // 获取商品列表接口
  void getCategoryGoodsList({categoryId}) async {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': '',
      'page': 1
    };
    await request(servicePath['categoryList'], formData: data).then((val) {
      var data = json.decode(val);
      CategoryGoodListModel cateGoodList = CategoryGoodListModel.fromJson(data);
      Provide.value<CategoryGoodList>(context)
          .getCateGoodList(cateGoodList.data);
    });
  }

  // 获取分类的方法
  void getCategory() async {
    await request(servicePath['category']).then((val) {
      var data = json.decode(val.toString());
      CategoryModel catelist = CategoryModel.fromJson(data);
      setState(() {
        list = catelist.data;
      });
      Provide.value<ChildCategory>(context).getChildCategory(
          catelist.data[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }
}

// 右边分类
class RightNav extends StatefulWidget {
  final Widget child;

  RightNav({Key key, this.child}) : super(key: key);

  _RightNavState createState() => _RightNavState();
}

class _RightNavState extends State<RightNav> {
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context, child, childCategory) {
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.black12))),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategory.length,
            itemBuilder: (context, index) {
              return _rightNav(index, childCategory.childCategory[index]);
            },
          ),
        );
      },
    );
  }

  // 每一项
  Widget _rightNav(index, item) {
    bool isChoose = true;
    isChoose = (index == Provide.value<ChildCategory>(context).rightIndex)
        ? true
        : false;
    return InkWell(
      onTap: () {
        Provide.value<ChildCategory>(context).changeIndex(index,item.mallSubId);
        getCategoryGoodsList(subId: item.mallSubId);
        print('-------------');
        print(Provide.value<ChildCategory>(context).page);
        print(Provide.value<ChildCategory>(context).loadText);
      },
      child: Container(
        height: ScreenUtil().setHeight(80),
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        alignment: Alignment.center,
        child: Text(
          '${item.mallSubName}',
          style: TextStyle(color: isChoose ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  // 获取商品列表接口
  void getCategoryGoodsList({subId}) async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': subId,
      'page': 1
    };
    await request(servicePath['categoryList'], formData: data).then((val) {
      var data = json.decode(val);
      CategoryGoodListModel cateGoodList = CategoryGoodListModel.fromJson(data);
      if (cateGoodList.data == null) {
        Provide.value<CategoryGoodList>(context).getCateGoodList([]);
      } else {
        Provide.value<CategoryGoodList>(context)
            .getCateGoodList(cateGoodList.data);
      }
    });
  }
}

// 右边商品列表
class RightList extends StatefulWidget {
  final Widget child;

  RightList({Key key, this.child}) : super(key: key);

  _RightListState createState() => _RightListState();
}

class _RightListState extends State<RightList> {

  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  var scrollControll = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodList>(
      builder: (context, child, data) {
        try{
          if(Provide.value<ChildCategory>(context).page == 1){
            scrollControll.jumpTo(0.0);
          }
        }
        catch(e){
          print('进入页面第一次初始化：${e}');
        }
        if (data.cateGoodList.length != 0) {
          return Expanded(
              child: Container(
                width: ScreenUtil().setWidth(570),
                child:EasyRefresh(
                  refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  // 背景颜色
                  bgColor: Colors.transparent,
                  // 文字颜色
                  textColor: Colors.black,
                  loadText: '上拉加载',
                  loadReadyText: '松手加载',
                  loadingText: '正在加载',
                  noMoreText: Provide.value<ChildCategory>(context).loadText==''?'加载完成': Provide.value<ChildCategory>(context).loadText,
                  loadHeight: 50.0,
                  showMore: true,
                  moreInfoColor:Colors.black,
                  moreInfo: '更新于%T',
                  ),
                  child: ListView.builder(
                    controller: scrollControll,
                    itemCount: data.cateGoodList.length,
                    itemBuilder: (context, index) {
                      return _rightListItem(data.cateGoodList, index);
                    },
                  ),
                  loadMore: () async{
                    getMore();
                  },
                )
              )
          );
        } else {
          return Text('没有数据');
        }
      },
    );
  }

  // 加载更多的方法
  void getMore() async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page':Provide.value<ChildCategory>(context).page + 1
    };
    await request(servicePath['categoryList'], formData: data).then((val) {
      var data = json.decode(val);
      CategoryGoodListModel cateGoodList = CategoryGoodListModel.fromJson(data);
      if (cateGoodList.data == null) {
        Provide.value<ChildCategory>(context).changeText('已经没有更多了~');
        print(Provide.value<ChildCategory>(context).loadText);
        Fluttertoast.showToast(
          msg: '没有更多了',
          backgroundColor: Colors.pink,
          textColor: Colors.white
        );
      } else {
        Provide.value<ChildCategory>(context).addPage();
        Provide.value<ChildCategory>(context).changeText('加载完成');
        Provide.value<CategoryGoodList>(context).getMoreGoodList(cateGoodList.data);
      }
    });
  }

  // 每一项
  Widget _rightListItem(List goodsList, int index) {
    return InkWell(
        onTap: () {
          print('点击了第${index}个,叫${goodsList[index].goodsName}');
        },
        child: Container(
          padding: EdgeInsets.all(7.0),
          margin: EdgeInsets.only(bottom: 3.0),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(200),
                child: Image.network(goodsList[index].image, fit: BoxFit.fill),
              ),
              Container(
                width: ScreenUtil().setWidth(330),
                padding: EdgeInsets.only(left: 7.0),
                alignment: Alignment.topLeft,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${goodsList[index].goodsName}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '抢购价：${goodsList[index].presentPrice}',
                              style: TextStyle(
                                color: Colors.pink,
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5.0),
                              child: Text(
                                '${goodsList[index].oriPrice}',
                                style: TextStyle(
                                    color: Colors.black12,
                                    decoration: TextDecoration.lineThrough),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
