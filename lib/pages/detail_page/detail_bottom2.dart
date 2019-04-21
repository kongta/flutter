import 'package:flutter/material.dart';

class TabBarSample extends StatelessWidget {
  final List<Tab> myTabs = <Tab>[Tab(text: '详情'), Tab(text: '评论')];
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new DefaultTabController(
        length: myTabs.length, //传入选项卡数量
        child: new Scaffold(
          appBar: new AppBar(
            bottom: new TabBar(
                isScrollable: true, //设置为可以滚动
                tabs: myTabs),
          ),
          //添加选项卡视图
          body: TabBarView(
            children: <Widget>[Text('22222')],
          ),
        ),
      ),
    );
  }
}
