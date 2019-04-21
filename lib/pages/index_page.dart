import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'cart_page.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'member_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/currentIndex.dart';

class IndexPage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750,height: 1334)..init(context);

    final bottomBars = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), title: Text('首页')),
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), title: Text('分类')),
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.shopping_cart), title: Text('购物车')),
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.profile_circled), title: Text('会员中心')),
    ];
    final tabBody = <Widget>[HomePage(), CategoryPage(), CartPage(), MemberPage()];

    return Provide<CurrentIndexProvide>(
      builder: (context,child,val){
      return Scaffold(
        backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
        body: IndexedStack(
          index: val.currentIndex,
          children: tabBody
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomBars,
          currentIndex: val.currentIndex,
          onTap: (index) {
            Provide.value<CurrentIndexProvide>(context).changeIndex(index);
          },
          type: BottomNavigationBarType.fixed,
        ),
      );
    });
  }
}

// class IndexPage extends StatefulWidget {
//   _IndexPageState createState() => _IndexPageState();
// }

// class _IndexPageState extends State<IndexPage> {
//   final List<BottomNavigationBarItem> bottomBars = [
//     BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), title: Text('首页')),
//     BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), title: Text('分类')),
//     BottomNavigationBarItem(
//         icon: Icon(CupertinoIcons.shopping_cart), title: Text('购物车')),
//     BottomNavigationBarItem(
//         icon: Icon(CupertinoIcons.profile_circled), title: Text('会员中心')),
//   ];
//   int currentIndex = 0;
//   var currentPage;
//   final List<Widget> tabBody = [HomePage(), CategoryPage(), CartPage(), MemberPage()];

//   @override
//   void initState() {
//     currentPage = tabBody[currentIndex];
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.instance = ScreenUtil(width: 750,height: 1334)..init(context);
//     return Provide<CurrentIndexProvide>(builder: (context,child,val){
//       return Scaffold(
//       body: IndexedStack(
//         index: val.currentIndex,
//         children: tabBody
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: bottomBars,
//         currentIndex: currentIndex,
//         onTap: (index) {
//           Provide.value<CurrentIndexProvide>(context).changeIndex(index);
//         },
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//     });
//   }
// }
